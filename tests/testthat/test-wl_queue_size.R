# Test for valid output when provided with required parameters
test_that("wl_queue_size returns a data frame with dates and queue sizes", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_queue_size(waiting_list, start_date = "2024-01-01"
                          , end_date = "2024-01-31")

  expect_s3_class(result, "data.frame")
  expect_true("dates" %in% colnames(result))
  expect_true("queue_size" %in% colnames(result))
})

# Test for handling missing start_date and end_date
test_that("wl_queue_size uses min referral date for start_date if NULL", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04"))
  removals <- c(as.Date("2024-01-08"), NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_queue_size(waiting_list, start_date = NULL
                          , end_date = "2024-01-31")
  expect_equal(result$dates[1], as.Date("2024-01-01"))
})

test_that("wl_queue_size uses max referral date for end_date if NULL", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04"))
  removals <- c(as.Date("2024-01-08"), NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_queue_size(waiting_list, start_date = "2024-01-01"
                          , end_date = NULL)
  expect_equal(result$dates[length(result$dates)], as.Date("2024-01-04"))
})

# Test if the queue size is computed correctly
test_that("wl_queue_size computes correct queue size over the period", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_queue_size(waiting_list, start_date = "2024-01-01"
                          , end_date = "2024-01-31")
  expect_equal(result$queue_size[1], 1)  # On 2024-01-01, one patient
  expect_equal(result$queue_size[4], 2)  # On 2024-01-04, two patients
})

# Test for handling case when there are no removals
test_that("wl_queue_size handles no removals correctly", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"))
  removals <- c(NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_queue_size(waiting_list, start_date = "2024-01-01"
                          , end_date = "2024-01-10")
  expect_true(
    all(
      result$queue_size == c(1, 1, 1, 2, 2, 2, 2, 2, 2, 3)
    )
  )  # No removals, just increasing queue size
})

# Test for handling case with multiple departures within the period
test_that("wl_queue_size accounts for removals correctly", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), as.Date("2024-01-15"), NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  result <- wl_queue_size(waiting_list, start_date = "2024-01-01"
                          , end_date = "2024-01-31")
  expect_equal(result$queue_size[7], 2)  # After first removal, queue size 2
  expect_equal(result$queue_size[15], 1) # After second removal, queue size 1
})

# Test for correct handling of empty waiting list
test_that("wl_queue_size handles empty waiting list", {
  waiting_list <- data.frame(referral = as.Date(character(0))
                             , removal = as.Date(character(0)))
  expect_error(wl_queue_size(waiting_list, start_date = "2024-01-01"
                             , end_date = "2024-01-31"))
})

test_that("wl_queue_size errors with incorrect arg classes", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)


  wl_msg <- "`waiting_list` must be of class <data.frame>"

  expect_error(wl_queue_size(waiting_list = 1), wl_msg)
  expect_error(wl_queue_size(waiting_list = "cat"), wl_msg)
  expect_error(wl_queue_size(list(), additions), wl_msg)

  start_msg <- "`start_date` must be of class <Date/character>"

  expect_error(wl_queue_size(waiting_list, start_date = 1), start_msg)
  expect_error(wl_queue_size(waiting_list, start_date = list()), start_msg)
  expect_error(wl_queue_size(waiting_list, start_date = data.frame()), start_msg)

  end_msg <- "`end_date` must be of class <Date/character>"

  expect_error(wl_queue_size(waiting_list, end_date = 1), end_msg)
  expect_error(wl_queue_size(waiting_list, end_date = list()), end_msg)
  expect_error(wl_queue_size(waiting_list, end_date = data.frame()), end_msg)

  ref_msg <- "`referral_index` must be of class <numeric/character/logical>"

  expect_error(wl_queue_size(waiting_list, referral_index = list()), ref_msg)
  expect_error(wl_queue_size(waiting_list, referral_index = NULL), ref_msg)
  expect_error(wl_queue_size(waiting_list, referral_index = sum), ref_msg)

  rem_msg <- "`removal_index` must be of class <numeric/character/logical>"

  expect_error(wl_queue_size(waiting_list, removal_index = list()), rem_msg)
  expect_error(wl_queue_size(waiting_list, removal_index = NULL), rem_msg)
  expect_error(wl_queue_size(waiting_list, removal_index = sum), rem_msg)
})
