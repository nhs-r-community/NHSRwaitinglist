test_that("wl_percentile_hist returns documented and legacy names", {
  wl_hist <- data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 100,
    report_date = as.Date("2024-01-31")
  )

  result <- wl_percentile_hist(wl_hist, percentage = 50)

  expect_named(
    result,
    c("date_percentile", "weeks_percentile", "date", "weeks", "percentage")
  )
  expect_equal(result$date_percentile, result$date)
  expect_equal(result$weeks_percentile, result$weeks)
  expect_equal(result$percentage, 50)
  expect_s3_class(result$date_percentile, "Date")
  expect_equal(result$date_percentile, as.Date("2024-01-05"))
  expect_equal(result$weeks_percentile, 4)
})

test_that("wl_percentile_hist rejects invalid percentages", {
  wl_hist <- data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 100,
    report_date = as.Date("2024-01-31")
  )

  expect_error(wl_percentile_hist(wl_hist, percentage = -1))
  expect_error(wl_percentile_hist(wl_hist, percentage = 101))
  expect_error(wl_percentile_hist(wl_hist, percentage = "50"))
})

test_that("wl_percentile_hist returns missing values for empty totals", {
  wl_hist <- data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 0,
    report_date = as.Date("2024-01-31")
  )

  result <- wl_percentile_hist(wl_hist, percentage = 50)

  expect_true(is.na(result$date_percentile))
  expect_true(is.na(result$weeks_percentile))
  expect_true(is.na(result$date))
  expect_true(is.na(result$weeks))
})
