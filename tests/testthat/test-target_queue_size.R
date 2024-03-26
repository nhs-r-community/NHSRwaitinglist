# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches null values and reports error", {
#   em <- "target_queue_size(): no error message when function is run with no inputs."
#   expect_error(target_queue_size(), em)
# })
#
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches mismatched input lengths", {
#   em <- "target_queue_size(): no error message when functions inputs are of different length."
#   expect_error(target_queue_size(c(22,25,26), c(10, 12)), em)
# })
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("it returns an error if either input aren't numeric", {
#   in1 <- Sys.Date()
#   in2 <- 1
#
#   em <- "target_queue_size(): all inputs must be numeric."
#   expect_error(target_queue_size(in1, in2), em)
# })


test_that("it returns an expected result with fixed single values", {
  em <- "target_queue_size(): arithmetic error with single value inputs."
  expect_equal(target_queue_size(30, 52), 390)
  expect_equal(target_queue_size(30, 50), 375)
  expect_equal(target_queue_size(30, 50, 6), 250)
})

test_that("it returns an expected result with vector of fixed values", {
  em <- "target_queue_size(): arithmetic error with vector of values as inputs."
  expect_equal(
    target_queue_size(
      c(30, 30, 30 ),
      c(52, 50, 50),
      c(4,4,6)
    )
    , c(390, 375, 250)
  )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0,30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- in1 * (1.2 + runif(1,0,1.5))
  em <- "target_queue_size(): output vector length != input vector length."
  expect_length(target_queue_size(in1, in2), length(in1))
})


