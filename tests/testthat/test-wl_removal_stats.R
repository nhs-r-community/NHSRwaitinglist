# Test for valid output with correct column names
test_that("wl_removal_stats returns a dataframe with correct columns", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_removal_stats(waiting_list)
  expect_s3_class(result, "data.frame")
  expect_true("capacity.weekly" %in% colnames(result))
  expect_true("capacity.daily" %in% colnames(result))
  expect_true("capacity.cov" %in% colnames(result))
  expect_true("removal.count" %in% colnames(result))
})

# Test for calculation of removal statistics
test_that("wl_removal_stats computes removal statistics correctly", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_removal_stats(waiting_list)
  expect_equal(result$removal.count, 1)  # Only one removal in this case
  expect_true(result$capacity.weekly > 0)
  expect_true(result$capacity.daily > 0)
  expect_true(result$capacity.cov >= 0)  # Coefficient of variation non-negative
})

# Test for handling missing `start_date` and `end_date`
test_that("wl_removal_stats uses the correct default start_date and end_date", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04"))
  removals <- c(as.Date("2024-01-08"), NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_removal_stats(waiting_list)
  expect_equal(result$capacity.daily, 1/7)
  expect_equal(result$capacity.weekly, 1) # Capacity should be computed based
  # on the removal date difference
})

# Test for behaviour when there are no removals
test_that("wl_removal_stats handles missing removals gracefully", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"))
  removals <- c(NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_removal_stats(waiting_list)
  expect_equal(result$removal.count, 0)  # No removals should result in count 0
  expect_equal(result$capacity.weekly, NaN)  # No removals should not allow
  # capacity calculation
})

# Test for custom `start_date` and `end_date` inputs
test_that("wl_removal_stats handles custom start_date and end_date correctly", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04"))
  removals <- c(as.Date("2024-01-08"), NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_removal_stats(waiting_list, start_date = "2024-01-02"
                             , end_date = "2024-01-10")
  expect_equal(result$removal.count, 1)  # Only one removal
})

# Test for correct behaviour with edge case of an empty waiting list
test_that("wl_removal_stats handles an empty waiting list", {
  waiting_list <- data.frame(referral = as.Date(character(0))
                             , removal = as.Date(character(0)))
  expect_error(wl_removal_stats(waiting_list))
})
