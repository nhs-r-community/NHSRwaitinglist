test_that("wrong input class causes an error", {
  msg_fragment <- "must be of class"
  expect_error(calc_queue_load(1, "x"), msg_fragment)
  expect_error(calc_queue_load("x", 1), msg_fragment)
})

test_that("it returns expected result with fixed single values vs arithmetic", {
  em <- "calc_queue_load(): arithmetic error with single value inputs."
  expect_equal(calc_queue_load(30, 27), 30 / 27)
})

test_that("it returns an expected result with fixed single values", {
  em <- "calc_queue_load(): arithmetic error with single value inputs."
  expect_equal(calc_queue_load(30, 27), 1.11111111)
})


test_that("it returns an expected result with vector of fixed values", {
  em <- "calc_queue_load(): arithmetic error with vector of values as inputs."
  expect_equal(
    calc_queue_load(
      c(35, 30, 52),
      c(27, 25, 42)
    ),
    c(1.2962963, 1.2, 1.23809524)
  )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0, 30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- rnorm(n = n, 30, 5)
  em <- "target_queue_size(): output vector length != input vector length."
  expect_length(calc_queue_load(in1, in2), length(in1))
})
