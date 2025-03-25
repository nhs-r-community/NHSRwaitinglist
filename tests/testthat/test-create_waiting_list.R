
# Test for valid inputs and output structure
test_that("create_waiting_list returns a tibble with correct columns", {
  result <- create_waiting_list(10, 50, 21, "2024-01-01")

  em <- "create_waiting_list(): returns wrong class"
  # Check if the result is a tibble
  expect_s3_class(result, "tbl_df")

  em <- 'create_waiting_list(): does not have expected column names: "pat_id"
  , "addition_date", "removal_date", "wait_length", "rott"'
  # Check if the returned tibble has the correct columns
  expected_columns <- c("pat_id", "addition_date", "removal_date"
                        , "wait_length", "rott")
  expect_true(all(expected_columns %in% colnames(result)))
})

# Test for handling negative values for `n` (invalid number of patients)
test_that("create_waiting_list throws error with negative n", {
  expect_error(create_waiting_list(-10, 50, 21, "2024-01-01"))
  expect_error(create_waiting_list(0, 50, 21, "2024-01-01"))
})

# Test for `n` being zero
test_that("create_waiting_list handles zero n", {
  result <- create_waiting_list(1, 50, 21, "2024-01-01")
  expect_equal(nrow(result), 50)
})

# Test for correct behaviour when limit_removals is TRUE
test_that("create_waiting_list suppresses removal dates beyond the period", {
  result <- create_waiting_list(10, 50, 21, "2024-01-01"
                                , limit_removals = TRUE)
  expect_true(
    all(
      is.na(
        result$removal_date[result$removal_date > as.Date("2024-01-01") + 10]
      )
    )
  )
})

# Test for correct behaviour when limit_removals is FALSE
test_that("create_waiting_list does not suppress removal dates", {
  result <- create_waiting_list(10, 50, 21, "2024-01-01"
                                , limit_removals = FALSE)
  expect_true(all(!is.na(result$removal_date)))
})

# Test for correct assignment of the 'rott' flag
test_that("create_waiting_list assigns 'rott' flag correctly", {
  result <- create_waiting_list(10, 50, 21, "2024-01-01", rott = 0.2)
  rott_count <- sum(as.numeric(result$rott == TRUE))
  expect_equal(rott_count, round(500 * 0.2)) # 20% of 500 should be flagged
})

# Test for different values of sd
test_that("create_waiting_list handles different sd values", {
  set.seed(12345)
  result <- create_waiting_list(10, 50, 21, "2024-01-01", sd = 5)

  expect_equal(
    length(
      na.omit(
        result$wait_length
      )
    )
    , 130
  )  # Ensure it returns 130 rows after the seed fixed

  result_no_sd <- create_waiting_list(10, 50, 21, "2024-01-01", sd = 0)
  expect_equal(length(result_no_sd$wait_length), 500)  # Ensure it returns 500
})

# Test if 'dots' are correctly passed and returned in the result
test_that("create_waiting_list passes extra arguments via 'dots'", {
  extra_arg <- list(example_arg = "test_value")
  result <- create_waiting_list(10, 50, 21, "2024-01-01", extra_arg = extra_arg)
  expect_true("example_arg" %in% names(result$extra_arg))
  expect_equal(result$extra_arg$example_arg, "test_value")
})

# Test if the function works with a very large number of referrals
test_that("create_waiting_list handles large numbers", {
  result <- create_waiting_list(10000, 50, 21, "2024-01-01")
  expect_equal(nrow(result), 500000)
})
