# Test nst_linescore_call input validation
test_that("nst_linescore_call requires season >= 2007", {
  expect_error(
    nst_linescore_call(20062007), "NaturalStatTrick data only available from 2007-2008 and onward"
  )
})

# Test season format padding
test_that("nst_linescore_call converts numeric season", {
  skip_if_offline()

  result <- naturalstattrick:::nst_linescore_call(2023)
  expect_true(is.data.frame(result))
})

# Test regular season vs playoff parameter
test_that("nst_season_results accepts regular season parameter", {
  skip_if_offline()

  result <- nst_season_results(20222023, playoffs = FALSE)
  expect_true(is.data.frame(result))
})

test_that("nst_season_results accepts playoff parameter", {
  skip_if_offline()

  result <- nst_season_results(20222023, playoffs = TRUE)
  expect_true(is.data.frame(result))
})

# Test with network available
test_that("nst_season_results returns data frame when network available", {
  skip_if_offline()
  if (!nzchar(Sys.getenv("NST_ACCESS_KEY", ""))) {
    skip("NST access key not configured")
  }

  result <- nst_season_results(20222023, playoffs = FALSE)
  expect_true(is.data.frame(result))
  expect_true("team" %in% colnames(result))
  result2 <- nst_season_results(20222023)
  expect_equal(result, result2)
  result3 <- nst_season_results(20222023, playoffs = TRUE)
  expect_equal(colnames(result2), colnames(result3))
})
