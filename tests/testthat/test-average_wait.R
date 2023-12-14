# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches null values and reports error", {
#   em <- "target_wait(): no error message when function is run with no inputs."
#   expect_error(target_wait(), em)
# })
#
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches mismatched input lengths", {
#   em <- "target_wait(): no error message when functions inputs are of different length."
#   expect_error(target_wait(c(22,25,26), c(4, 3)), em)
# })
#
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("it returns an error if either input aren't numeric", {
#   in1 <- Sys.Date()
#   in2 <- 4
#
#   em <- "target_wait(): all inputs must be numeric."
#   expect_error(target_wait(in1, in2), em)
# })

test_that("it returns an expected result with fixed single values, against arithmetic", {
  target_wait <-
    em <- "average_wait(): aritmetic error with single value inputs."
  expect_equal(average_wait(52, 4), 52/4)
})

test_that("it returns an expected result with fixed single values", {
  target_wait <-
  em <- "average_wait(): aritmetic error with single value inputs."
  expect_equal(average_wait(52, 4), 13)
})



test_that("it returns an expected result with vector of fixed values", {
  em <- "average_wait(): aritmetic error with vector of values as inputs."
  expect_equal(
    average_wait(
      c(35, 30, 52),
      c(4,4,6)
    )
    , c(8.75, 7.5, 8.6666667)
  )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0,30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- rnorm(n = n, 4, 2)
  em <- "target_queue_size(): output vector length != input vector length."
  expect_length(average_wait(in1, in2), length(in1))
})


