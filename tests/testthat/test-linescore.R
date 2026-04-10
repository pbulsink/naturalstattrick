# Test nst_linescore_call input validation
test_that("nst_linescore_call requires season >= 2007", {
  expect_error(
    naturalstattrick:::nst_linescore_call(20062007),
    class = "simpleError"
  )
})

test_that("nst_linescore_call accepts valid seasons", {
  # Test that valid season passes validation (will fail on network, but not validation)
  skip_if_offline()

  # Season 2022-2023 is valid
  # The function will try to make a network request which might fail,
  # but we're just checking it passes the validation phase
  expect_error(
    naturalstattrick:::nst_linescore_call(20222023),
    NA # Should not have validation error
  )
})

# Test season format padding
test_that("nst_linescore_call pads 4-digit season to 8-digit", {
  skip_if_offline()

  # 2022 should pad to 20222023
  expect_error(
    naturalstattrick:::nst_linescore_call(2022),
    NA # Should not have validation error
  )
})

test_that("nst_linescore_call converts numeric season", {
  skip_if_offline()

  # Test with 4-digit numeric that should become 8-digit
  expect_error(
    naturalstattrick:::nst_linescore_call(2023),
    NA # Should not have validation error
  )
})

# Test regular season vs playoff parameter
test_that("nst_season_results accepts regular season parameter", {
  skip_if_offline()

  # Should not error on parameter validation
  expect_error(
    nst_season_results(20222023, playoffs = FALSE),
    NA # Should not error from parameter validation
  )
})

test_that("nst_season_results accepts playoff parameter", {
  skip_if_offline()

  expect_error(
    nst_season_results(20222023, playoffs = TRUE),
    NA # Should not error from parameter validation
  )
})

# Test with network available
test_that("nst_season_results returns data frame when network available", {
  skip_if_offline()
  if (nzchar(Sys.getenv("NST_ACCESS_KEY", ""))) {
    nst_key_set(Sys.getenv("NST_ACCESS_KEY"))
  }

  result <- nst_season_results(20222023, playoffs = FALSE)
  expect_true(is.data.frame(result))
})

test_that("nst_season_results returns data with expected structure", {
  skip_if_offline()
  if (nzchar(Sys.getenv("NST_ACCESS_KEY", ""))) {
    nst_key_set(Sys.getenv("NST_ACCESS_KEY"))
  }

  result <- nst_season_results(20222023, playoffs = FALSE)
  # Check for key columns that should exist after cleanup
  expect_true("team" %in% colnames(result))
})
