test_that("simple game works", {
  game_df<-nst_report_df(20222023, 20001)
  game_list<-nst_report_list(20222023, 20001)

  expect_equal(game_df$team, c("Predators", "Sharks"))

  expect_equal(game_df$cf_all, game_list$tall$cf[c(4,8)])
})

test_that("OT regular game works", {
  game_df<-nst_report_df(20222023, 21301)
  game_list<-nst_report_list(20222023, 21301)

  expect_equal(game_df$team, c("Capitals", "Devils"))

  expect_equal(game_df$cf_all, game_list$tall$cf[c(5,10)])
  expect_equal(game_df$cf_all, c(50, 77))
})

test_that("SO game works", {
  game_df<-nst_report_df(20222023, 21282)
  game_list<-nst_report_list(20222023, 21282)

  expect_equal(game_df$team, c("Flames", "Predators"))

  expect_equal(game_df$cf_all, game_list$tall$cf[c(5,10)])
  expect_equal(game_df$cf_all, c(84, 49))
})

test_that("Multi-OT playoff game works", {
  game_df<-nst_report_df(20222023, 30311)
  game_list<-nst_report_list(20222023, 30311)

  expect_equal(game_df$team, c("Hurricanes", "Panthers"))

  expect_equal(game_df$cf_all, game_list$tall$cf[c(8,16)])
  expect_equal(game_df$cf_all, c(145, 126))
})
