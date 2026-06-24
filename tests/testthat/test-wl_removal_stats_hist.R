# Test wl_removal_stats_hist function

# Helper function to create test histogram data
create_test_histogram <- function(report_dates, arrival_weeks = c(0, 1, 2, 3),
                                  counts_per_week = c(10, 15, 20, 25)) {
  # Create histogram with multiple report dates
  hist_list <- lapply(report_dates, function(rd) {
    data.frame(
      arrival_since = as.Date(rd) - (arrival_weeks * 7 + 6),
      arrival_before = as.Date(rd) - (arrival_weeks * 7),
      n = counts_per_week,
      report_date = as.Date(rd)
    )
  })

  do.call(rbind, hist_list)
}

# Test 1: Valid histogram with 2 report dates
test_that("wl_removal_stats_hist calculates correctly for 2 snapshots", {
  # Create histogram with 2 report dates, 1 month apart
  wl_hist <- create_test_histogram(
    report_dates = c("2024-01-31", "2024-02-29"),
    arrival_weeks = c(0, 1, 2, 3),
    counts_per_week = c(100, 80, 60, 40) # Total: 280 patients each snapshot
  )

  result <- wl_removal_stats_hist(wl_hist)

  # Check that result is a data frame
  expect_s3_class(result, "data.frame")

  # Check that required columns exist
  expect_true("capacity_weekly" %in% colnames(result))
  expect_true("capacity_daily" %in% colnames(result))
  expect_true("capacity_cov" %in% colnames(result))
  expect_true("removal_count" %in% colnames(result))

  # Check that values are numeric and non-negative
  expect_true(is.numeric(result$capacity_weekly))
  expect_true(result$capacity_weekly >= 0)
  expect_true(result$capacity_daily >= 0)
  expect_true(result$removal_count >= 0)
})

# Test 2: Histogram with decreasing queue (removals occurring)
test_that("wl_removal_stats_hist detects removals correctly", {
  # Create histogram where queue size decreases over time
  wl_hist <- rbind(
    data.frame(
      arrival_since = as.Date("2024-01-01") - c(6, 13, 20),
      arrival_before = as.Date("2024-01-01") - c(0, 7, 14),
      n = c(100, 100, 100), # 300 total patients
      report_date = as.Date("2024-01-31")
    ),
    data.frame(
      arrival_since = as.Date("2024-01-01") - c(6, 13, 20),
      arrival_before = as.Date("2024-01-01") - c(0, 7, 14),
      n = c(80, 80, 80), # 240 total patients (60 removed)
      report_date = as.Date("2024-02-29")
    )
  )

  result <- wl_removal_stats_hist(wl_hist)

  # 60 removals over 29 days (Jan 31 to Feb 29)
  expect_equal(result$removal_count, 60)
  expect_equal(round(result$capacity_daily, 4), round(60 / 29, 4))
  expect_equal(round(result$capacity_weekly, 4), round((60 / 29) * 7, 4))
})

# Test 3: Multiple report dates (more than 2)
test_that("wl_removal_stats_hist handles multiple report dates", {
  # Create histogram with 3 report dates
  wl_hist <- create_test_histogram(
    report_dates = c("2024-01-31", "2024-02-29", "2024-03-31"),
    counts_per_week = c(100, 80, 60, 40)
  )

  result <- wl_removal_stats_hist(wl_hist)

  expect_s3_class(result, "data.frame")
  expect_true(result$removal_count >= 0)
  # Should average across both periods (Jan-Feb and Feb-Mar)
})

# Test 4: Error when less than 2 report dates
test_that("wl_removal_stats_hist errors with single report date", {
  wl_hist <- create_test_histogram(
    report_dates = "2024-01-31"
  )

  expect_error(
    wl_removal_stats_hist(wl_hist),
    "at least 2 report_date values"
  )
})

# Test 5: Date range filtering with start_date and end_date
test_that("wl_removal_stats_hist respects date range filters", {
  # Create histogram with 4 report dates
  wl_hist <- create_test_histogram(
    report_dates = c("2024-01-31", "2024-02-29", "2024-03-31", "2024-04-30")
  )

  # Filter to only Feb-Mar period
  result <- wl_removal_stats_hist(
    wl_hist,
    start_date = "2024-02-01",
    end_date = "2024-03-31"
  )

  expect_s3_class(result, "data.frame")
  # Should only use Feb 29 and Mar 31 snapshots
})

# Test 6: Error when date range contains less than 2 dates
test_that("wl_removal_stats_hist errors when filtered dates < 2", {
  wl_hist <- create_test_histogram(
    report_dates = c("2024-01-31", "2024-02-29", "2024-03-31")
  )

  # Filter to range with only 1 date
  expect_error(
    wl_removal_stats_hist(wl_hist, start_date = "2024-03-01", end_date = "2024-03-31"),
    "at least 2 report_date values"
  )
})

# Test 7: No removals (queue stays same or grows)
test_that("wl_removal_stats_hist handles zero removals", {
  # Create histogram where queue stays same
  wl_hist <- rbind(
    data.frame(
      arrival_since = as.Date("2024-01-01"),
      arrival_before = as.Date("2024-01-07"),
      n = 100,
      report_date = as.Date("2024-01-31")
    ),
    data.frame(
      arrival_since = as.Date("2024-01-01"),
      arrival_before = as.Date("2024-01-07"),
      n = 100, # Same count
      report_date = as.Date("2024-02-29")
    )
  )

  result <- wl_removal_stats_hist(wl_hist)

  # No removals
  expect_equal(result$removal_count, 0)
  expect_equal(result$capacity_daily, 0)
  expect_equal(result$capacity_weekly, 0)
})

# Test 8: Coefficient of variation is always 1 (hardcoded)
test_that("wl_removal_stats_hist returns capacity_cov of 1", {
  wl_hist <- create_test_histogram(
    report_dates = c("2024-01-31", "2024-02-29")
  )

  result <- wl_removal_stats_hist(wl_hist)

  expect_equal(result$capacity_cov, 1)
})

# Test 9: Missing report_date column
test_that("wl_removal_stats_hist handles missing report_date column gracefully", {
  wl_hist <- data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 100
    # Missing report_date column
  )

  # Should error or handle gracefully
  expect_error(wl_removal_stats_hist(wl_hist))
})
