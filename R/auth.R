# Internal environment for access key and request timing
.nst_env <- new.env(parent = emptyenv())

#' Set Natural Stat Trick access key
#'
#' @description Store a Natural Stat Trick access key for future requests.
#' The key is kept in a hidden package environment and is not written to disk.
#'
#' @param key A single character access key from Natural Stat Trick.
#'
#' @return Invisibly returns NULL.
#' @export
nst_key_set <- function(key) {
  stopifnot(is.character(key), length(key) == 1, nzchar(key))
  .nst_env$nst_key <- key
  invisible(NULL)
}

#' @rdname nst_key_set
#' @export
nst_key_clear <- function() {
  .nst_env$nst_key <- NULL
  invisible(NULL)
}

nst_get_key <- function() {
  key <- .nst_env$nst_key
  if (!is.null(key) && nzchar(key)) {
    return(key)
  }

  key <- Sys.getenv("NST_ACCESS_KEY", "")
  if (nzchar(key)) {
    return(key)
  }

  return(NULL)
}

nst_wait_rate_limit <- function() {
  last <- .nst_env$last_request
  if (!is.null(last)) {
    elapsed <- as.numeric(difftime(Sys.time(), last, units = "secs"))
    delay <- 20 - elapsed
    if (delay > 0) {
      Sys.sleep(delay)
    }
  }
  .nst_env$last_request <- Sys.time()
  invisible(NULL)
}
