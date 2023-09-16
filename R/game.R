#' Get Game Report
#'
#' @description Get a game report from Natural Stat Trick. Game reports are lists of data frames for different strength
#' scenarios, each showing things like coris for/against, fenwick for/against, xg for/against, goals for/against and toi
#' for the specific strenght.
#'
#' @param season Season in 8 numeric format (i.e. 20212022)
#' @param game_id Game Id in 5 digit format 20001. Regular season games begin with a 2, playoff games with a 3
#'
#' @return a list of tibbles with different scenarios (all, 5v5, 5v4, 4v5, etc)
#' @export
nst_report_list <- function(season, game_id) {
  # #tbtsall
  # #tbtsev
  # #tbts5v5
  # #tbtssva
  # #tbtspp
  # #tbtspk

  nst_html <- nst_game_call(season, game_id)

  tall <- nst_html %>%
    rvest::html_element(css = "#tbtsall") %>%
    rvest::html_table() %>%
    janitor::clean_names() %>%
    nst_table_cleanup()

  tev <- nst_html %>%
    rvest::html_element(css = "#tbtsev") %>%
    rvest::html_table() %>%
    janitor::clean_names() %>%
    nst_table_cleanup()

  t5v5 <- nst_html %>%
    rvest::html_element(css = "#tbts5v5") %>%
    rvest::html_table() %>%
    janitor::clean_names() %>%
    nst_table_cleanup()

  tsva <- nst_html %>%
    rvest::html_element(css = "#tbtssva") %>%
    rvest::html_table() %>%
    janitor::clean_names() %>%
    nst_table_cleanup()

  tpp <- nst_html %>%
    rvest::html_element(css = "#tbtspp") %>%
    rvest::html_table() %>%
    janitor::clean_names() %>%
    nst_table_cleanup()

  tpk <- nst_html %>%
    rvest::html_element(css = "#tbtspk") %>%
    rvest::html_table() %>%
    janitor::clean_names() %>%
    nst_table_cleanup()

  return(list(tall = tall, tev = tev, t5v5 = t5v5, tsva = tsva, tpp = tpp, tpk = tpk))
}

#' NST Table Cleanup
#'
#' @param data partial nst table
#'
#' @return nst table after cleanup
#' @importFrom rlang .data
nst_table_cleanup <- function(data) {
  if('corski_f' %in% colnames(data)){
    data <- data %>%
      dplyr::rename("cf" = "corski_f", "ca" = "corski_a", "cf_percent" = "corski_f_percent",
                    "ff" = "fenski_f", "fa" = "fenski_a", "ff_percent" = "fenski_f_percent")
  }
  if(!'x' %in% colnames(data)){
    data$x <- c('UnknownHome', 'UnknownAway')
  }
  if(all(is.na(data$x))){
    data$x <- c('UnknownHome', 'UnknownAway')
  }
  data %>%
    dplyr::rename("team" = "x", "xgf" = "x_gf", "xga" = "x_ga", "xgf_percent" = "x_gf_percent") %>%
    dplyr::mutate(period = sub("\nFinal", "Final", .data$period)) %>%
    dplyr::mutate(period = sub("Final", "\nFinal", .data$period)) %>%
    tidyr::separate_longer_delim(
      c(
        "period", "toi", "cf", "cf", "ca", "cf_percent", "ff", "fa", "ff_percent", "sf", "sa",
        "sf_percent", "scf", "sca", "scf_percent", "hdcf", "hdca", "hdcf_percent", "xgf",
        "xga", "xgf_percent", "gf", "ga", "gf_percent"
      ),
      "\n"
    ) %>%
    dplyr::mutate(
      toi_sec = time_to_sec(.data$toi),
      cf = as.numeric(.data$cf),
      ca = as.numeric(.data$ca),
      cf_percent = as.numeric(unlist(strsplit(.data$cf_percent, "%", fixed = TRUE))) / 100,
      ff = as.numeric(.data$ff),
      fa = as.numeric(.data$fa),
      ff_percent = as.numeric(unlist(strsplit(.data$ff_percent, "%", fixed = TRUE))) / 100,
      sf = as.numeric(.data$sf),
      sa = as.numeric(.data$sa),
      sf_percent = as.numeric(unlist(strsplit(.data$sf_percent, "%", fixed = TRUE))) / 100,
      scf = as.numeric(.data$scf),
      sca = as.numeric(.data$sca),
      scf_percent = as.numeric(unlist(strsplit(.data$scf_percent, "%", fixed = TRUE))) / 100,
      hdcf = as.numeric(.data$hdcf),
      hdca = as.numeric(.data$hdca),
      hdcf_percent = as.numeric(unlist(strsplit(.data$hdcf_percent, "%", fixed = TRUE))) / 100,
      xgf = as.numeric(.data$xgf),
      xga = as.numeric(.data$xga),
      xgf_percent = as.numeric(unlist(strsplit(.data$xgf_percent, "%", fixed = TRUE))) / 100,
      gf = as.numeric(.data$gf),
      ga = as.numeric(.data$ga),
      gf_percent = as.numeric(unlist(strsplit(.data$gf_percent, "%", fixed = TRUE))) / 100
    ) %>%
    suppressWarnings() %>%
    return()
}

nst_game_call <- function(season, game_id) {
  stopifnot(as.integer(substr(season, 1, 4)) >= 2007)
  nst_html <- httr2::request("https://www.naturalstattrick.com") %>%
    httr2::req_url_path_append(glue::glue("game.php?season={season}&game={game}",
      season = season, game = game_id
    )) %>%
    httr2::req_throttle(180 / 3600) %>% # 180 calls per h
    httr2::req_retry(5) %>%
    httr2::req_timeout(30) %>%
    httr2::req_user_agent("naturalstattrick r package - github.com/pbulsink/naturalstattrick") %>%
    httr2::req_perform() %>%
    httr2::resp_body_html()

  return(nst_html)
}


#' NST Short Report
#'
#' @description
#' Get a short report from NST for a single game.
#' For more information call get_game_report
#'
#' @param season Season in 8 numeric format (i.e. 20212022)
#' @param game_id Game Id in 5 digit format 20001. Regular season games begin with a 2, playoff games with a 3
#'
#' @return a tibble of all scenarios' data with
#' corsi, fenwick, shots, and more data returned for each team
#'
#' @export
nst_report_df <- function(season, game_id) {
  game <- nst_report_list(season, game_id)

  gall <- game$tall %>%
    dplyr::filter(.data$period == "Final") %>%
    dplyr::mutate("h_a" = c("home", "away")) %>%
    dplyr::select("team", "h_a",
      "cf_all" = "cf", "ff_all" = "ff", "sf_all" = "sf", "scf_all" = "scf",
      "hdcf_all" = "hdcf", "xgf_all" = "xgf", "gf_all" = "gf"
    )

  gev <- game$tev %>%
    dplyr::filter(.data$period == "Final") %>%
    dplyr::select("team",
      "cf_ev" = "cf", "ff_ev" = "ff", "sf_ev" = "sf", "scf_ev" = "scf",
      "hdcf_ev" = "hdcf", "xgf_ev" = "xgf", "gf_ev" = "gf"
    )
  g5v5 <- game$t5v5 %>%
    dplyr::filter(.data$period == "Final") %>%
    dplyr::select("team",
      "cf_5v5" = "cf", "ff_5v5" = "ff", "sf_5v5" = "sf", "scf_5v5" = "scf",
      "hdcf_5v5" = "hdcf", "xgf_5v5" = "xgf", "gf_5v5" = "gf"
    )

  gsva <- game$tsva %>%
    dplyr::filter(.data$period == "Final") %>%
    dplyr::select("team",
      "cf_sva" = "cf", "ff_sva" = "ff", "sf_sva" = "sf", "scf_sva" = "scf",
      "hdcf_sva" = "hdcf", "xgf_sva" = "xgf", "gf_sva" = "gf"
    )

  gpp <- game$tpp %>%
    dplyr::filter(.data$period == "Final") %>%
    dplyr::select("team",
      "cf_pp" = "cf", "ff_pp" = "ff", "sf_pp" = "sf", "scf_pp" = "scf",
      "hdcf_pp" = "hdcf", "xgf_pp" = "xgf", "gf_pp" = "gf"
    )

  gpk <- game$tpk %>%
    dplyr::filter(.data$period == "Final") %>%
    dplyr::select("team",
      "cf_pk" = "cf", "ff_pk" = "ff", "sf_pk" = "sf", "scf_pk" = "scf",
      "hdcf_pk" = "hdcf", "xgf_pk" = "xgf", "gf_pk" = "gf"
    )

  greport <- gall %>%
    dplyr::left_join(gev, by = "team") %>%
    dplyr::left_join(g5v5, by = "team") %>%
    dplyr::left_join(gsva, by = "team") %>%
    dplyr::left_join(gpp, by = "team") %>%
    dplyr::left_join(gpk, by = "team")

  return(greport)
}
