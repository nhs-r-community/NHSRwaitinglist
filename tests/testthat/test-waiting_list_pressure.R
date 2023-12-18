# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches null values and reports error", {
#   em <- "waiting_list_pressure(): no error message when function is run with no inputs."
#   expect_error(waiting_list_pressure(), em)
# })
#
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches mismatched input lengths", {
#   em <- "waiting_list_pressure(): no error message when functions inputs are of different length."
#   expect_error(waiting_list_pressure(c(22,25,26), c(10, 12)), em)
# })
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("it returns an error if either input aren't numeric", {
#   in1 <- Sys.Date()
#   in2 <- 1
#
#   em <- "waiting_list_pressure(): all inputs must be numeric."
#   expect_error(waiting_list_pressure(in1, in2), em)
# })

test_that("it returns an expected result with fixed single values, against arithmetic", {
  em <- "waiting_list_pressure(): arithmetic error with single value inputs."
  expect_equal(waiting_list_pressure(63, 52), 2 * 63 / 52)
})

test_that("it returns an expected result with fixed single values", {
  em <- "waiting_list_pressure(): arithmetic error with single value inputs."
  expect_equal(waiting_list_pressure(63, 52), 2.42307692)
})

test_that("it returns an expected result with vector of fixed values", {
  em <- "waiting_list_pressure(): arithmetic error with vector of input values."
  expect_equal(
    waiting_list_pressure(
      c(63, 42, 55 ),
      c(52, 24, 50)
      )
    , c(2.42307692, 3.5, 2.2)
    )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0,30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- in1 * (1.2 + runif(1,0,1.5))
  em <- "waiting_list_pressure(): output vector length != input vector length."
  expect_length(waiting_list_pressure(in1, in2), length(in1))
})


