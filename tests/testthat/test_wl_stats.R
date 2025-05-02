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
               , "`waiting_list` must be of class <data.frame>")
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

# Test 6: Test with incorrect class of arguments
test_that("wl_stats errors with incorrect arg classes", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)


  wl_msg <- "`waiting_list` must be of class <data.frame>"

  expect_error(wl_stats(waiting_list = 1), wl_msg)
  expect_error(wl_stats(waiting_list = "cat"), wl_msg)
  expect_error(wl_stats(list(), additions), wl_msg)

  target_msg <- "`target_wait` must be of class <numeric>"

  expect_error(wl_stats(waiting_list, target_wait = "4"), target_msg)
  expect_error(wl_stats(waiting_list, target_wait = list()), target_msg)
  expect_error(wl_stats(waiting_list, target_wait = data.frame()), target_msg)

  start_msg <- "`start_date` must be of class <Date/character>"

  expect_error(wl_stats(waiting_list, start_date = 1), start_msg)
  expect_error(wl_stats(waiting_list, start_date = list()), start_msg)
  expect_error(wl_stats(waiting_list, start_date = data.frame()), start_msg)

  end_msg <- "`end_date` must be of class <Date/character>"

  expect_error(wl_stats(waiting_list, end_date = 1), end_msg)
  expect_error(wl_stats(waiting_list, end_date = list()), end_msg)
  expect_error(wl_stats(waiting_list, end_date = data.frame()), end_msg)
})

