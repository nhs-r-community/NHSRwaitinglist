# Test for valid output when provided with required parameters
test_that("wl_simulator returns a data frame with correct columns", {
  result <- wl_simulator("2024-01-01", "2024-03-31", 100, 110)
  expect_s3_class(result, "data.frame")
  expect_true(all(c("Referral", "Removal") %in% colnames(result)))
})

# Test for handling missing `start_date` and `end_date`
test_that("wl_simulator defaults start_date to Sys.Date() when not provided", {
  result <- wl_simulator(demand = 100, capacity = 110)
  expect_equal(result$Referral[1], as.Date(Sys.Date()))
})

# Test for handling demand and capacity parameters
test_that("wl_simulator calculates demand and capacity correctly", {
  set.seed(1234)
  result <- wl_simulator("2024-01-01", "2024-03-31", demand = 100
                         , capacity = 110)
  expect_equal(nrow(result), 1242)  # Should simulate around 100 referrals
})

# Test for withdrawal simulation when `withdrawal_prob` is provided
test_that("wl_simulator handles withdrawal_prob correctly", {
  result <- wl_simulator("2024-01-01", "2024-03-31", demand = 100
                         , capacity = 110, withdrawal_prob = 0.1)
  expect_true("Withdrawal" %in% colnames(result))
  expect_gt(length(na.omit(result$Referral))
            , length(na.omit(result$Withdrawal)))
})

# Test for simulation with `detailed_sim = TRUE`
test_that("wl_simulator works with detailed_sim = TRUE", {
  result <- wl_simulator("2024-01-01", "2024-03-31", demand = 100
                         , capacity = 110, detailed_sim = TRUE)
  expect_true("Withdrawal" %in% colnames(result))  # Withdrawal column exists
})

# Test for behavior when `waiting_list` is provided
test_that("wl_simulator incorporates waiting_list correctly", {
  result <- wl_simulator("2024-01-01", "2024-03-31"
                         , demand = 100, capacity = 110, waiting_list = 50)
  expect_true(nrow(result) >= 50)  # Ensure waiting_list is incorporated
})

# Test for handling edge case with zero demand
test_that("wl_simulator handles zero demand gracefully", {
  result <- wl_simulator("2024-01-01", "2024-03-31", demand = 0, capacity = 110)
  expect_equal(nrow(result), 0)  # No referrals should be simulated
})

# Test for behavior with missing `withdrawal_prob`
test_that("wl_simulator works when withdrawal_prob is missing", {
  result <- wl_simulator("2024-01-01", "2024-03-31"
                         , demand = 100, capacity = 110)
  expect_false("Withdrawal" %in% colnames(result))  # No withdrawal column
})
