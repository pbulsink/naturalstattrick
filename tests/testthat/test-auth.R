test_that("save_nst_access_key requires non-empty key", {
  expect_error(save_nst_access_key(""), class = "error")
  expect_error(save_nst_access_key(c("key1", "key2")), class = "error")
  expect_error(save_nst_access_key(123), class = "error")
})

test_that("nst_get_key retrieves from environment", {
  withr::with_envvar(c("NST_ACCESS_KEY" = "test-key"), {
    expect_equal(naturalstattrick:::nst_get_key(), "test-key")
  })

  withr::with_envvar(c("NST_ACCESS_KEY" = ""), {
    expect_null(naturalstattrick:::nst_get_key())
  })
})
