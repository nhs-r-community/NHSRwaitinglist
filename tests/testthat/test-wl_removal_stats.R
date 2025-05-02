# Test for valid output with correct column names
test_that("wl_removal_stats returns a dataframe with correct columns", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_removal_stats(waiting_list)
  expect_s3_class(result, "data.frame")
  expect_true("capacity_weekly" %in% colnames(result))
  expect_true("capacity_daily" %in% colnames(result))
  expect_true("capacity_cov" %in% colnames(result))
  expect_true("removal_count" %in% colnames(result))
})

# Test for calculation of removal statistics
test_that("wl_removal_stats computes removal statistics correctly", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_removal_stats(waiting_list)
  expect_equal(result$removal_count, 1)  # Only one removal in this case
  expect_true(result$capacity_weekly > 0)
  expect_true(result$capacity_daily > 0)
  expect_true(result$capacity_cov >= 0)  # Coefficient of variation non-negative
})

# Test for handling missing `start_date` and `end_date`
test_that("wl_removal_stats uses the correct default start_date and end_date", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04"))
  removals <- c(as.Date("2024-01-08"), NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_removal_stats(waiting_list)
  expect_equal(result$capacity_daily, 1 / 7)
  expect_equal(result$capacity_weekly, 1) # Capacity should be computed based
  # on the removal date difference
})

# Test for behaviour when there are no removals
test_that("wl_removal_stats handles missing removals gracefully", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"))
  removals <- c(NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_removal_stats(waiting_list)
  expect_equal(result$removal_count, 0)  # No removals should result in count 0
  expect_equal(result$capacity_weekly, NaN)  # No removals should not allow
  # capacity calculation
})

# Test for custom `start_date` and `end_date` inputs
test_that("wl_removal_stats handles custom start_date and end_date correctly", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04"))
  removals <- c(as.Date("2024-01-08"), NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_removal_stats(waiting_list, start_date = "2024-01-02"
                             , end_date = "2024-01-10")
  expect_equal(result$removal_count, 1)  # Only one removal
})

# Test for correct behaviour with edge case of an empty waiting list
test_that("wl_removal_stats handles an empty waiting list", {
  waiting_list <- data.frame(referral = as.Date(character(0))
                             , removal = as.Date(character(0)))
  expect_error(wl_removal_stats(waiting_list))
})

test_that("wl_removal_stats errors with incorrect arg classes", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  wl_msg <- "`waiting_list` must be of class <data.frame>"

  expect_error(wl_removal_stats(waiting_list = 1), wl_msg)
  expect_error(wl_removal_stats(waiting_list = "cat"), wl_msg)
  expect_error(wl_removal_stats(list(), additions), wl_msg)

  start_msg <- "`start_date` must be of class <Date/character>"

  expect_error(wl_removal_stats(waiting_list, start_date = 1), start_msg)
  expect_error(wl_removal_stats(waiting_list, start_date = list()), start_msg)
  expect_error(wl_removal_stats(waiting_list, start_date = data.frame()), start_msg)

  end_msg <- "`end_date` must be of class <Date/character>"

  expect_error(wl_removal_stats(waiting_list, end_date = 1), end_msg)
  expect_error(wl_removal_stats(waiting_list, end_date = list()), end_msg)
  expect_error(wl_removal_stats(waiting_list, end_date = data.frame()), end_msg)

  rem_msg <- "`removal_index` must be of class <numeric/character/logical>"

  expect_error(wl_removal_stats(waiting_list, removal_index = list()), rem_msg)
  expect_error(wl_removal_stats(waiting_list, removal_index = NULL), rem_msg)
  expect_error(wl_removal_stats(waiting_list, removal_index = sum), rem_msg)
})