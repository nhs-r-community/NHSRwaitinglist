# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches null values and reports error", {
#   em <- "queue_load(): no error message when function is run with no inputs."
#   expect_error(queue_load(), em)
# })
#
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("function catches mismatched input lengths", {
#   em <- "queue_load(): no error message when functions inputs are of different length."
#   expect_error(queue_load(c(22,25,26), c(15, 20)), em)
# })
#
# # Anticipated test from the error handling that Matt Dray is drafting
# test_that("it returns an error if either input aren't numeric", {
#   in1 <- Sys.Date()
#   in2 <- 27
#
#   em <- "queue_load(): all inputs must be numeric."
#   expect_error(queue_load(in1, in2), em)
# })

test_that("it returns an expected result with fixed single values, against arithmetic", {
  em <- "queue_load(): arithmetic error with single value inputs."
  expect_equal(queue_load(30, 27), 30/27)
})

test_that("it returns an expected result with fixed single values", {
  em <- "queue_load(): arithmetic error with single value inputs."
  expect_equal(queue_load(30, 27), 1.11111111)
})


test_that("it returns an expected result with vector of fixed values", {
  em <- "queue_load(): arithmetic error with vector of values as inputs."
  expect_equal(
    queue_load(
      c(35, 30, 52),
      c(27,25,42)
    )
    , c( 1.2962963, 1.2, 1.23809524)
  )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0,30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- rnorm(n = n, 30, 5)
  em <- "target_queue_size(): output vector length != input vector length."
  expect_length(queue_load(in1, in2), length(in1))
})


