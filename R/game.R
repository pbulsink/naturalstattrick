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
get_game_report <- function(season, game_id) {
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

nst_table_cleanup <- function(data){
  data %>%
    dplyr::rename("team" = "x", "xgf" = "x_gf", "xga" = "x_ga", "xgf_percent" = "x_gf_percent") %>%
    dplyr::mutate(period = sub("\nFinal", "Final", .data$period)) %>%
    dplyr::mutate(period = sub("Final", "\nFinal", .data$period)) %>%
    tidyr::separate_longer_delim(c("period", "toi", "cf", "cf", "ca", "cf_percent", "ff", "fa", "ff_percent", "sf", "sa",
                                   "sf_percent", "scf", "sca", "scf_percent", "hdcf", "hdca", "hdcf_percent", "xgf",
                                   "xga", "xgf_percent", "gf", "ga", "gf_percent"),
                                 "\n") %>%
    dplyr::mutate(toi_sec = time_to_sec(.data$toi),
                  cf = as.numeric(.data$cf),
                  ca = as.numeric(.data$ca),
                  cf_percent = as.numeric(unlist(strsplit(.data$cf_percent, "%", fixed = TRUE)))/100,
                  ff = as.numeric(.data$ff),
                  fa = as.numeric(.data$fa),
                  ff_percent = as.numeric(unlist(strsplit(.data$ff_percent, "%", fixed = TRUE)))/100,
                  sf = as.numeric(.data$sf),
                  sa = as.numeric(.data$sa),
                  sf_percent = as.numeric(unlist(strsplit(.data$sf_percent, "%", fixed = TRUE)))/100,
                  scf = as.numeric(.data$scf),
                  sca = as.numeric(.data$sca),
                  scf_percent = as.numeric(unlist(strsplit(.data$scf_percent, "%", fixed = TRUE)))/100,
                  hdcf = as.numeric(.data$hdcf),
                  hdca = as.numeric(.data$hdca),
                  hdcf_percent = as.numeric(unlist(strsplit(.data$hdcf_percent, "%", fixed = TRUE)))/100,
                  xgf = as.numeric(.data$xgf),
                  xga = as.numeric(.data$xga),
                  xgf_percent = as.numeric(unlist(strsplit(.data$xgf_percent, "%", fixed = TRUE)))/100,
                  gf = as.numeric(.data$gf),
                  ga = as.numeric(.data$ga),
                  gf_percent = as.numeric(unlist(strsplit(.data$gf_percent, "%", fixed = TRUE)))/100) %>%
    suppressWarnings() %>%
    return()
}

.nst_game_call <- function(season, game_id){
  nst_game_url <- glue::glue("https://www.naturalstattrick.com/game.php?season={season}&game={game}",
                        season = season, game = game_id)
  httr::set_config(httr::user_agent("naturalstattrick r package - github.com/pbulsink/naturalstattrick"))
  nst_html<-rvest::read_html(nst_game_url)

  return(nst_html)
}

nst_game_call <- memoise::memoise(.nst_game_call)

#' NST Short Report
#'
#' @description
#' Get a short report from NST for a single game.
#' For more information call get_game_report
#'
#' @param season Season in 8 numeric format (i.e. 20212022)
#' @param game_id Game Id in 5 digit format 20001. Regular season games begin with a 2, playoff games with a 3
#'
#' @return a tibble of all scenario data with
#' corsi, fenwick, shots, and more data retuned for each team
#'
#' @export
nst_short_report <- function(season, game_id) {
  game <- get_game_report(season, game_id)

  gall <- game$tall %>%
    dplyr::filter(.data$period == 'Final') %>%
    dplyr::select(c("team", "cf", "ff", "sf", "scf", "hdcf", "xgf", "gf")) %>%
    dplyr::mutate("h_a" = c("home", "away"))

  return(gall)
}
