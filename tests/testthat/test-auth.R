test_that("access key can be set and cleared", {
  nst_key_clear()
  expect_null(naturalstattrick:::.nst_env$nst_key)

  nst_key_set("test-key")
  expect_equal(naturalstattrick:::.nst_env$nst_key, "test-key")

  nst_key_clear()
  expect_null(naturalstattrick:::.nst_env$nst_key)
})
