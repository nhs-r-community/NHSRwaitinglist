# Test 1: Valid scheduling without unscheduled flag (unscheduled = FALSE)
test_that("schedules referrals correctly  when unscheduled = FALSE", {
  referrals <- as.Date(c("2024-01-01", "2024-01-04", "2024-01-10"))
  removals <- c(NA, NA, NA)
  waiting_list <- data.frame("referral" = referrals
                             , "removal" = removals)
  schedule <- as.Date(c("2024-01-03", "2024-01-05"))

  result <- wl_schedule(waiting_list, schedule, unscheduled = FALSE)

  expect_s3_class(result, "data.frame")
  expect_equal(sum(!is.na(result$removal)), 2)  # Two scheduled
  expect_equal(nrow(result), 3)  # Same number of rows

})

# Test 2: Handling unscheduled flag set to TRUE
test_that("eturns scheduled and unscheduled lists when unscheduled = TRUE", {

  referrals <- as.Date(c("2024-01-01", "2024-01-04", "2024-01-10"))
  removals <- c(NA, NA, NA)
  waiting_list <- data.frame("referral" = referrals
                             , "removal" = removals)
  schedule <- as.Date(c("2024-01-03", "2024-01-05"))

  result <- wl_schedule(waiting_list, schedule, unscheduled = TRUE)

  expect_length(result, 2)
  expect_s3_class(result[[1]], "data.frame")  # Updated waiting list
  expect_s3_class(result[[2]], "data.frame")  # Scheduled list
  expect_equal(sum(result[[2]]$scheduled), 2)  # Two scheduled
})

# Test 3: Empty waiting list
test_that("wl_schedule handles empty waiting list correctly", {
  waiting_list <- data.frame("referral" = as.Date(character(0))
                             , "removal" = as.Date(character(0)))
  schedule <- as.Date(c("2024-01-03", "2024-01-05"))


  expect_error(wl_schedule(waiting_list, schedule))

})

# Test 4: Invalid input for the schedule (non-date values)
test_that("wl_schedule throws error for invalid schedule input", {
  referrals <- as.Date(c("2024-01-01", "2024-01-04"))
  removals <- c(NA, NA)
  waiting_list <- data.frame("referral" = referrals, "removal" = removals)
  invalid_schedule <- c("invalid", "date")

  expect_error(wl_schedule(waiting_list, invalid_schedule)
               , "must be in an unambiguous Date format e.g., 'YYYY-MM-DD'")
})

# Test 5: Patients scheduled appropriately
test_that("wl_schedule handles when no scheduled dates match referral dates", {
  referrals <- as.Date(c("2024-01-01", "2024-01-04"))
  removals <- c(NA, NA)
  waiting_list <- data.frame("referral" = referrals, "removal" = removals)
  schedule <- as.Date(c("2024-02-01", "2024-03-01"))

  result <- wl_schedule(waiting_list, schedule)

  expect_equal(sum(!is.na(result$removal)), 2)
  #expect_s3_class(result$referral, "Date")
  #expect_s3_class(result$removal, "Date")
})

test_that("wl_schedule errors with incorrect arg classes", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)
  schedule <- c.Date("2024-01-03", "2024-01-05", "2024-01-18")


  wl_msg <- "`waiting_list` must be of class <data.frame>"

  expect_error(wl_schedule(waiting_list = 1), wl_msg)
  expect_error(wl_schedule(waiting_list = "cat"), wl_msg)
  expect_error(wl_schedule(list(), additions), wl_msg)

  sch_msg <- "`schedule` must be of class <Date/character>"

  expect_error(wl_schedule(waiting_list, schedule = 1), sch_msg)
  expect_error(wl_schedule(waiting_list, schedule = list()), sch_msg)
  expect_error(wl_schedule(waiting_list, schedule = data.frame()), sch_msg)

  ref_msg <- "`referral_index` must be of class <numeric/character/logical>"

  expect_error(wl_schedule(waiting_list, schedule, referral_index = list()),
               ref_msg)
  expect_error(wl_schedule(waiting_list, schedule, referral_index = NULL),
               ref_msg)
  expect_error(wl_schedule(waiting_list, schedule, referral_index = sum),
               ref_msg)

  rem_msg <- "`removal_index` must be of class <numeric/character/logical>"

  expect_error(wl_schedule(waiting_list, schedule, removal_index = list()),
               rem_msg)
  expect_error(wl_schedule(waiting_list, schedule, removal_index = NULL),
               rem_msg)
  expect_error(wl_schedule(waiting_list, schedule, removal_index = sum),
               rem_msg)

  unsch_msg <- "`unscheduled` must be of class <logical>"

  expect_error(wl_schedule(waiting_list, schedule, unscheduled = list()),
               unsch_msg)
  expect_error(wl_schedule(waiting_list, schedule, unscheduled = NULL),
               unsch_msg)
  expect_error(wl_schedule(waiting_list, schedule, unscheduled = sum),
               unsch_msg)
})

test_that("wl_schedule errors for invalid indexes to `waiting_list", {
  schedule <- Sys.Date()
  bad_lgl <- c(rep(FALSE, 9), TRUE)

  not_found <- "Column `referral_index` not found in `waiting_list`"

  expect_error(wl_schedule(iris, schedule, "bad index"), not_found)
  expect_error(wl_schedule(iris, schedule, referral_index = 10), not_found)
  expect_error(wl_schedule(iris, schedule, referral_index = bad_lgl), not_found)

  expect_error(wl_schedule(iris, schedule, "bad index"),
               r"(`referral_index` with value "bad index")")
  expect_error(wl_schedule(iris, schedule, referral_index = 10),
               r"(`referral_index` with value "10")")

  not_found <- "`removal_index` not found in `waiting_list`"

  expect_error(wl_schedule(iris, schedule, removal_index = "bad index"),
               not_found)
  expect_error(wl_schedule(iris, schedule, removal_index = 10), not_found)
  expect_error(wl_schedule(iris, schedule, removal_index = bad_lgl), not_found)

  expect_error(wl_schedule(iris, schedule, removal_index = "bad index"),
               r"(`removal_index` with value "bad index")")
  expect_error(wl_schedule(iris, schedule, removal_index = 10),
               r"(`removal_index` with value "10")")
})

test_that("wl_schedule errors for 0 row data frames", {
  empty_msg <- "`waiting_list` has 0 rows of data"

  expect_error(wl_schedule(mtcars[0, ]), empty_msg)
  expect_error(wl_schedule(iris[0, ]), empty_msg)
})
