test_that("wrong input class causes an error", {
  msg_fragment <- "must be of class"
  expect_error(calc_target_queue_size("x", 2, 3), msg_fragment)
  expect_error(calc_target_queue_size(1, "x", 3), msg_fragment)
  expect_error(calc_target_queue_size(1, 2, "x"), msg_fragment)
})

test_that("it returns an expected result with fixed single values", {
  em <- "calc_target_queue_size(): arithmetic error with single value inputs."
  expect_equal(calc_target_queue_size(30, 52), 390)
  expect_equal(calc_target_queue_size(30, 50), 375)
  expect_equal(calc_target_queue_size(30, 50, 6), 250)
})

test_that("it returns an expected result with vector of fixed values", {
  em <- "calc_target_queue_size(): arithmetic error with vector of values as inputs."
  expect_equal(
    calc_target_queue_size(
      c(30, 30, 30),
      c(52, 50, 50),
      c(4, 4, 6)
    ),
    c(390, 375, 250)
  )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0, 30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- in1 * (1.2 + runif(1, 0, 1.5))
  em <- "calc_target_queue_size(): output vector length != input vector length."
  expect_length(calc_target_queue_size(in1, in2), length(in1))
})
