test_that("plot_rtt_journey returns a ggplot object", {
  p <- plot_rtt_journey(referral_rate = 100)
  expect_s3_class(p, "ggplot")
})

test_that("plot_rtt_journey works with custom rtt_performance", {
  p <- plot_rtt_journey(
    referral_rate = 100,
    rtt_performance = c(0.7, 0.85, 0.92)
  )
  expect_s3_class(p, "ggplot")
})

test_that("plot_rtt_journey works with custom n_bins", {
  p <- plot_rtt_journey(referral_rate = 100, n_bins = 32)
  expect_s3_class(p, "ggplot")
})

test_that("plot_rtt_journey subtitle contains referral rate", {
  rate <- 150
  p <- plot_rtt_journey(referral_rate = rate)
  expect_match(p$labels$subtitle, as.character(rate))
})

test_that("plot_rtt_journey errors on invalid rtt_performance values", {
  expect_error(
    plot_rtt_journey(referral_rate = 100, rtt_performance = c(0.5, 1.5))
  )
  expect_error(
    plot_rtt_journey(referral_rate = 100, rtt_performance = c(-0.1, 0.5))
  )
})

test_that("plot_rtt_journey errors on non-positive referral rate", {
  expect_error(plot_rtt_journey(referral_rate = 0))
  expect_error(plot_rtt_journey(referral_rate = -10))
})

test_that("plot_rtt_journey has correct number of fill levels", {
  perf <- c(0.5, 0.70, 0.92)
  p <- plot_rtt_journey(referral_rate = 100, rtt_performance = perf)
  n_fills <- length(unique(ggplot2::ggplot_build(p)$data[[1]]$fill))
  expect_equal(n_fills, length(perf))
})

test_that("plot_rtt_journey handles a single rtt_performance value", {
  p <- plot_rtt_journey(referral_rate = 100, rtt_performance = 0.92)
  expect_s3_class(p, "ggplot")
})

test_that("plot_rtt_journey handles large referral rates", {
  p <- plot_rtt_journey(referral_rate = 10000)
  expect_s3_class(p, "ggplot")
})
