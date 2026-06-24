test_that("wl_fit_geometric_hist fits uncensored weekly counts", {
  hist <- data.frame(
    weeks_waiting = 0:3,
    n = c(50, 25, 12, 6)
  )

  fit <- wl_fit_geometric_hist(hist)

  expect_s3_class(fit, "wl_geometric_hist_fit")
  expect_equal(sum(fit$fitted$fitted_probability), 1 - (1 - fit$summary$geometric_p)^4)
  expect_equal(fit$summary$total_waiting, sum(hist$n))
})

test_that("wl_fit_geometric_hist handles an open-ended final bin", {
  hist <- data.frame(
    weeks_waiting = c(0, 1, 2),
    open_ended = c(FALSE, FALSE, TRUE),
    n = c(50, 25, 10)
  )

  fit <- wl_fit_geometric_hist(hist)

  expect_equal(sum(fit$fitted$fitted_probability), 1)
  expect_equal(fit$summary$open_ended_week, 2)
  expect_gt(fit$summary$fitted_open_ended, 0)
})
