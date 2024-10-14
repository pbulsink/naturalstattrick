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
  stopifnot(as.integer(substr(season, 1, 4)) >= 2007)
  if (nchar(season) != 8) {
    s1 <- as.numeric(substr(season, 1, 4))
    season <- as.numeric(paste0(s1, s1 + 1))
  }
  stopifnot(nchar(season) == 8)
  playoffs <- ifelse(playoffs, 3, 2)

  # This works?
  nst_html <- glue::glue("https://www.naturalstattrick.com/game.php?fromseason={season}&thruseason={season}&stype={playoffs}&sit=all&loc=B&team=All&rate=n",
    season = season, playoffs = playoffs
  ) %>%
    httr::GET(httr::user_agent("naturalstattrick r package - github.com/pbulsink/naturalstattrick")) %>%
    httr::content() %>%
    rvest::html_element(css = "#teams") %>%
    rvest::html_table()

  Sys.sleep(18) # NST has a max hit rate
  return(nst_html)
}
