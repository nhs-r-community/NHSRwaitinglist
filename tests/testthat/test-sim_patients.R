# Test for correct number of rows generated
test_that("sim_patients generates the correct number of rows", {
  result <- sim_patients(n_rows = 10)
  expect_equal(nrow(result), 10)
})

# Test for output structure (correct columns)
test_that("sim_patients returns the correct columns", {
  result <- sim_patients(n_rows = 10)
  expected_columns <- c("Referral", "Removal", "Withdrawal", "Priority"
                        , "Target_wait", "Name",
                        "Birth_date", "NHS_number", "Specialty_code",
                        "Specialty", "OPCS",
                        "Procedure", "Consultant")
  expect_true(all(expected_columns %in% colnames(result)))
})

# Test for handling missing start_date (default to current date)
test_that("sim_patients handles missing start_date by using Sys.Date()", {
  result <- sim_patients(n_rows = 5)
  expect_s3_class(result$Birth_date, "Date")  # Check if birth_date is assigned
})

# Test if priority values are within the expected range (1-4)
test_that("sim_patients assigns valid priority values", {
  result <- sim_patients(n_rows = 10)
  expect_true(all(result$Priority %in% c(1, 2, 3, 4)))
})

# # Test if 'Target_wait' is calculated based on priority
# test_that("sim_patients calculates 'Target_wait' based on priority", {
#   result <- sim_patients(n_rows = 10)
#   target_wait_values <- sapply(result$Priority, calc_priority_to_target)
#   expect_equal(result$Target_wait, target_wait_values)
# })

# Test if 'Referral', 'Removal', and 'Withdrawal' are NA initially
test_that("sim_patients initializes 'Referral', 'Removal'
          , and 'Withdrawal' as NA", {
            result <- sim_patients(n_rows = 10)
            expect_true(all(is.na(result$Referral)))
            expect_true(all(is.na(result$Removal)))
            expect_true(all(is.na(result$Withdrawal)))
          })

# Test if 'NHS_number' is within a valid range
test_that("sim_patients assigns valid NHS numbers", {
  result <- sim_patients(n_rows = 10)
  expect_true(all(result$NHS_number >= 1, result$NHS_number <= 1e+8))
})

# Test if the randomNames package is used to generate unique names
test_that("sim_patients generates random names for patients", {
  result <- sim_patients(n_rows = 10)
  expect_equal(length(unique(result$Name)), 10)  # Ensure names are unique
})

# Test for handling edge case with 0 rows
test_that("sim_patients fails gracefully when given zero rows", {
  #result <- sim_patients(n_rows = 0)
  #expect_equal(nrow(result), 0)
  err <- "NOTE: Please supply a positive integer for the argument n_rows."
  expect_error(sim_patients(n_rows = 0), err)
})
