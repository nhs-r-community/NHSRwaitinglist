# Test 1: Valid scheduling without unscheduled flag (unscheduled = FALSE)
test_that("wl_schedule schedules referrals correctly
          when unscheduled = FALSE", {
  referrals <- as.Date(c("2024-01-01", "2024-01-04", "2024-01-10"))
  removals <- c(NA, NA, NA)
  waiting_list <- data.frame("referral" = referrals, "removal" = removals)
  schedule <- as.Date(c("2024-01-03", "2024-01-05"))

  result <- wl_schedule(waiting_list, schedule, unscheduled = FALSE)

  expect_s3_class(result, "data.frame")
  expect_equal(sum(!is.na(result$removal)), 2)  # Two scheduled
  expect_equal(nrow(result), 3)  # Same number of rows
})

# Test 2: Handling unscheduled flag set to TRUE
test_that("wl_schedule returns scheduled and unscheduled lists
          when unscheduled = TRUE", {
  referrals <- as.Date(c("2024-01-01", "2024-01-04", "2024-01-10"))
  removals <- c(NA, NA, NA)
  waiting_list <- data.frame("referral" = referrals, "removal" = removals)
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
  , "Schedule vector is not formatted as dates")
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
