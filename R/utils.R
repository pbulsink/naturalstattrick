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
