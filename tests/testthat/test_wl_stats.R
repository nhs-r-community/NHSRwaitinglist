# Test 1: Valid data input with all fields filled
test_that("wl_stats calculates correctly for valid input", {
  referrals <- as.Date(c("2024-01-01", "2024-01-04"
                         , "2024-01-10", "2024-01-16"))
  removals <- as.Date(c("2024-01-08", NA, NA, NA))
  waiting_list <- data.frame("referral" = referrals, "removal" = removals)

  result <- wl_stats(waiting_list, target_wait = 4, start_date = "2024-01-01"
                     , end_date = "2024-01-16")

  # Check that the result is a data frame
  expect_s3_class(result, "data.frame")

  # Check that columns exist in the result
  expect_true("queue_size" %in% colnames(result))
  expect_true("target_queue_size" %in% colnames(result))
  expect_true("queue_too_big" %in% colnames(result))
})

# Test 2: Handle missing removal date
test_that("wl_stats handles missing removal dates", {
  referrals <- as.Date(c("2024-01-01", "2024-01-04", "2024-01-10"))
  removals <- c(NA, NA, NA)
  waiting_list <- data.frame("referral" = referrals, "removal" = removals)

  result <- wl_stats(waiting_list, target_wait = 4)

  # Check that the function can handle missing removals without errors
  expect_s3_class(result, "data.frame")
})

# Test 3: Handle edge case with empty waiting list
test_that("wl_stats handles empty waiting list", {
  waiting_list <- data.frame("referral" = as.Date(character(0))
                             , "removal" = as.Date(character(0)))

  # handles 0 rows in WL
  expect_error(wl_stats(waiting_list, target_wait = 4))
  # handles no wl supplied
  expect_error(wl_stats(target_wait = 4))
})

# Test 4: Ensure proper error for incorrect data type
test_that("wl_stats throws an error for incorrect data type", {
  incorrect_waiting_list <- list("referral" = "not a date"
                                 , "removal" = "not a date")

  expect_error(wl_stats(incorrect_waiting_list)
               , "waiting list should be supplied as a data.frame")
})

# Test 5: Test with specific date range
test_that("wl_stats returns correct stats for a specific date range", {
  referrals <- as.Date(c("2024-01-01", "2024-01-04", "2024-01-10"))
  removals <- as.Date(c("2024-01-08", "2024-01-11", NA))
  waiting_list <- data.frame("referral" = referrals, "removal" = removals)

  result <- wl_stats(waiting_list, target_wait = 4, start_date = "2024-01-01"
                     , end_date = "2024-01-10")

  expect_equal(result$mean_wait, 3)
})
