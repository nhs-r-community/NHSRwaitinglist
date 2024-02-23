# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches null values and reports error", {
#   em <- "target_capacity(): no error message when function is run with no inputs."
#   expect_error(target_capacity(), em)
# })
#
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches mismatched input lengths", {
#   em <- "target_capacity(): no error message when functions inputs are of different length."
#   expect_error(target_capacity(c(22,25,26), c(10, 12)), em)
# })
#
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("it returns an error if either input aren't numeric", {
#   in1 <- Sys.Date()
#   in2 <- 1
#
#   em <- "target_capacity(): all inputs must be numeric."
#   expect_error(target_capacity(in1, in2), em)
# })

test_that("it returns expected result with fixed single values vs arithmetic", {
  em <- "target_capacity(): arithmetic error with single value inputs."
  expect_equal(target_capacity(30, 52, 3), 30 + 2 * (1 + 4 * 3) / 52)
})

test_that("it returns an expected result with fixed single values", {
  em <- "target_capacity(): arithmetic error with single value inputs."
  expect_equal(target_capacity(30, 52, 3), 30.5)
})

test_that("it returns an expected result with vector of fixed values", {
  em <- "target_capacity(): arithmetic error with vector of input values."
  expect_equal(
    target_capacity(
      c(30, 42, 35),
      c(52, 65, 50),
      c(3, 2, 1)
    ),
    c(30.5, 42.276923, 35.2)
  )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0, 30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- in1 * runif(1, 0.5 ,1.5)
  em <- "target_capacity(): output vector length != input vector length."
  expect_length(target_capacity(in1, in2), length(in1))
})
