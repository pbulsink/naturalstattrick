#' Save Natural Stat Trick access key
#'
#' @description Save a Natural Stat Trick access key to .Rprofile for persistent use.
#' The key will be set as the NST_ACCESS_KEY environment variable when R starts.
#'
#' @param key A single character access key from Natural Stat Trick.
#'
#' @return Invisibly returns the path to .Rprofile.
#' @export
#' @examples
#' \dontrun{
#' save_nst_access_key("your-access-key-here")
#' }
save_nst_access_key <- function(key) {
  stopifnot(is.character(key), length(key) == 1, nzchar(key))

  rprofile <- file.path(Sys.getenv("HOME"), ".Rprofile")

  existing_content <- if (file.exists(rprofile)) {
    readLines(rprofile)
  } else {
    character(0)
  }

  # Remove any existing NST_ACCESS_KEY lines
  existing_content <- existing_content[!grepl("NST_ACCESS_KEY", existing_content)]

  # Add the new key line
  new_line <- sprintf("Sys.setenv(NST_ACCESS_KEY = \"%s\")", key)
  new_content <- c(existing_content, new_line)

  writeLines(new_content, rprofile)
  invisible(rprofile)
}

nst_get_key <- function() {
  key <- Sys.getenv("NST_ACCESS_KEY", "")
  if (nzchar(key)) {
    return(key)
  }
  return(NULL)
}
