# Internal environment for access key and request timing
.nst_env <- new.env(parent = emptyenv())

#' Set Natural Stat Trick access key
#'
#' @description Store a Natural Stat Trick access key for future requests.
#' The key is kept in a hidden package environment and is not written to disk.
#' This key will be used for all subsequent requests to data.naturalstattrick.com.
#' Alternatively, set the environment variable NST_ACCESS_KEY.
#'
#' @param key A single character access key from Natural Stat Trick.
#' @return Invisibly returns NULL.
#' @export
#' @examples
#' \dontrun{
#' nst_key_set("your-access-key-here")
#' }
nst_key_set <- function(key) {
  stopifnot(is.character(key), length(key) == 1, nzchar(key))
  .nst_env$nst_key <- key
  invisible(NULL)
}

#' Clear Natural Stat Trick access key
#'
#' @description Remove the stored Natural Stat Trick access key.
#' After clearing, requests will fall back to the NST_ACCESS_KEY environment variable,
#' or fail if no key is available.
#'
#' @return Invisibly returns NULL.
#' @export
#' @examples
#' \dontrun{
#' nst_key_clear()
#' }
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
