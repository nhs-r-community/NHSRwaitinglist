# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches null values and reports error", {
#   em <- "relief_capacity(): no error message when function is run with no inputs."
#   expect_error(relief_capacity(), em)
# })
#
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches mismatched input lengths", {
#   em <- "relief_capacity(): no error message when functions inputs are of different length."
#   expect_error(
#     relief_capacity(
#       c(30, 33, 35 )
#       , c(1200, 800, 250)
#       , c(390,200)
#       , c(26, 30, 15)
#       )
#     , em)
# })
#
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("it returns an error if either input aren't numeric", {
#   in1 <- Sys.Date()
#   in2 <- 1200
#   in3 <- 390
#   in4 <- 26
#
#   em <- "relief_capacity(): all inputs must be numeric."
#   expect_error(relief_capacity(in1, in2, in3, in4), em)
# })
#'

test_that("it returns an expected result with fixed single values, against arithmetic", {
  em <- "relief_capacity(): arithmetic error with single value inputs."
  expect_equal(relief_capacity(30, 1200, 390, 26), 30 + (1200 - 390)/26)
})

test_that("it returns an expected result with fixed single values", {
  em <- "relief_capacity(): arithmetic error with single value inputs."
  expect_equal(relief_capacity(30, 1200, 390, 26), 61.153846)
})

test_that("it returns an expected result with vector of fixed values", {
  em <- "relief_capacity(): arithmetic error with vector of input values."
  expect_equal(
    relief_capacity(
      c(30, 33, 35 ),
      c(1200, 800, 250),
      c(390,200,100),
      c(26, 30, 15)
      )
    , c(61.153846, 53, 45)
    )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0,30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- in1 * (15 * runif(1,0 ,1.5))
  in3 <- in1 * (5 * runif(1,1 ,1.5))
  in4 <- in1 * (runif(1,0.5,1.5))

  em <- "relief_capacity(): output vector length != input vector length."
  expect_length(relief_capacity(in1, in2, in3, in4), length(in1))
})


