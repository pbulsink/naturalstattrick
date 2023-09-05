time_to_sec <- function(time) {
  subfun <- function(x) {
    if (is.na(x)) {
      NA
    } else if (is.numeric(x)) {
      x
    } else {
      split <- as.numeric(strsplit(x, ":", fixed = TRUE)[[1]])
      if (length(split) == 3) {
        split[1] * 3600 + split[2] * 60 + split[3]
      } else if (length(split) == 2) {
        split[1] * 60 + split[2]
      } else if (length(split) == 1) {
        split
      }
    }
  }
  v_tts <- Vectorize(subfun, USE.NAMES = FALSE)
  v_tts(time)
}

clear_cache <- function() {
  memoise::forget(nst_game_call)
}

#' Write NST Game DF to R
#'
#' @param gid gameID in YYYY0#GGGG format, or NULL to use season and game_id directly
#' @param season season in YYYYYYYY format (i.e. 20072008). Overwritten by calculated season if gid is provided
#' @param game_id game_id in ##### format (i.e. 21200). Overwritten by calculated game_id if gid is provided
#' @param file csv file to add the selected game to
#'
#' @return None, called for side-effects
#' @export
write_game_df_to_file <- function(gid, season = NULL, game_id = NULL, filename = "~/Documents/natstattrick.csv") {
  if (!is.null(gid)) {
    season <- paste0(as.integer(substr(gid, 1, 4)), as.integer(substr(gid, 1, 4)) + 1)
    game_id <- substr(gid, 6, 10)
  } else {
    gid <- paste0(substr(season, 1, 4), "0", game_id)
  }

  # Using grep to test the file has the gameid in it or not is faster than loading the file
  # each and every time.
  if (system2("grep", paste0('-l "', gid, '" ', filename), stdout = FALSE) != 0) {
    nstdf <- nst_report_df(season, game_id)
    nstdf$game_id <- gid
    write.table(nstdf, file = filename, append = TRUE, row.names = FALSE, col.names = FALSE, sep = ",", )
  }
}
