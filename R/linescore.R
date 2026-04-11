#' Linescore
#' @description Get a whole season or playoffs at once!
#'
#' @param season Season in 8 numeric format (i.e. 20212022)
#' @param playoffs whether to get the playoff game data (TRUE) or regular season (FALSE)
#'
#' @export
nst_season_results <- function(season, playoffs = FALSE) {
  nst_html <- nst_linescore_call(season, playoffs) %>%
    janitor::clean_names() %>%
    nst_table_cleanup()

  return(nst_html)
}

nst_linescore_call <- function(season, playoffs = FALSE) {
  if(!as.integer(substr(season, 1, 4)) >= 2007){
    cli::cli_abort("NaturalStatTrick data only available from 2007-2008 and onward.")
  }
  if (nchar(season) != 8) {
    s1 <- as.numeric(substr(season, 1, 4))
    season <- as.numeric(paste0(s1, s1 + 1))
  }
  stopifnot(nchar(season) == 8)
  playoffs <- ifelse(playoffs, 3, 2)

  req <- httr2::request("https://data.naturalstattrick.com") %>%
    httr2::req_url_path_append("games.php") %>%
    httr2::req_url_query(
      "fromseason" = season,
      "thruseason" = season,
      "stype" = playoffs,
      "sit" = "all",
      "loc" = "B",
      "team" = "All",
      "rate" = "n"
    )

  key <- nst_get_key()
  if (!is.null(key)) {
    req <- httr2::req_headers(req, "nst-key" = key)
  } else {
    cli::cli_abort(c('Error in saturalstattrick:::nst_linescore_call: no nst-key available.',
                     i = "See https://www.naturalstattrick.com/scraping.php for info."))
  }

  nst_html <- req %>%
    httr2::req_throttle(180 / 3600) %>%
    httr2::req_retry(5) %>%
    httr2::req_timeout(30) %>%
    httr2::req_user_agent("naturalstattrick r package - github.com/pbulsink/naturalstattrick") %>%
    httr2::req_perform() %>%
    httr2::resp_body_html() %>%
    rvest::html_element(css = "#teams") %>%
    rvest::html_table()

  return(nst_html)
}
