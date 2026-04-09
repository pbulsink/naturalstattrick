# nocov start
.onLoad <- function(libname, pkgname) {
  .nst_env$nst_key <- NULL
  .nst_env$last_request <- NULL

  assign(
    x = "nst_game_call",
    value = memoise::memoise(nst_game_call),
    envir = rlang::ns_env("naturalstattrick")
  )
}
# nocov end
