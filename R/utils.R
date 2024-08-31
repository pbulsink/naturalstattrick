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
#' @param filename csv file to add the selected game to
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
    utils::write.table(nstdf, file = filename, append = TRUE, row.names = FALSE, col.names = FALSE, sep = ",", )
    closeAllConnections()
    gc(verbose = FALSE)
    clear_cache()
  }

  invisible(TRUE)
}

#' Get a Season and Write to File
#'
#' @description a convenience function to write a whole season's nst data to file. Note this will try *all* possible
#' playoff games and result in messages reporting errors for all series that didn't go to 7 games.
#'
#' @param season season (four number year)
#' @param playoffs binary, whether or not to get the playoff data. Default false (get regular season). If true, only gets playoffs.
#' @param filename File to write data to (will also verify that data isn't in file before trying to download)
#'
#' @return invisible TRUE if finished ok.
#' @export
get_season_to_file <- function(season, playoffs = FALSE, filename = "~/Documents/natstattrick.csv") {
  stopifnot(as.integer(substr(season, 1, 4)) >= 2007)
  season <- substr(season, 1,4)
  if(!playoffs) {
    gid <- 20001:21312
  } else {
    gid <- c(30111:30117, 30121:30127, 30131:30137, 30141:30147, 30151:30157, 30161:30167, 30171:30177, 30181:30187,
             30211:30217, 30221:30227, 30231:30237, 30241:30247, 30311:30317, 30321:30327, 30411:30417)
    if(season == 2020){
      gid <- c(30001:30007, 30011:30017, 30021:30027, 30031:30037, 30041:30047, 30051:30057, 30061:30067, 30071:30077, 30081:30087, 30091:30097, gid)
    }
  }
  gid <- paste0(season, "0", gid)

  for(g in seq_along(gid)) {
    tryCatch(
      write_game_df_to_file(gid = gid[g], filename = filename),
      error = function(e) message(paste0("Error in ", gid[g], ": ", e))
    )
  }

  invisible(TRUE)
}
