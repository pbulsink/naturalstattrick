# nocov start
.onLoad <- function(libname, pkgname) {
  assign(
    x = "nst_game_call",
    value = memoise::memoise(nst_game_call),
    envir = rlang::ns_env("naturalstattrick")
  )
}
# nocov end
