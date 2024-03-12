test_that("wrong input class causes an error", {
  msg_fragment <- "must be of class"
  expect_error(waiting_list_pressure("x", 2), msg_fragment)
  expect_error(waiting_list_pressure(1, "x"), msg_fragment)
})

test_that("it returns expected result with fixed single values vs arithmetic", {
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
      c(63, 42, 55),
      c(52, 24, 50)
    ),
    c(2.42307692, 3.5, 2.2)
  )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0, 30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- in1 * (1.2 + runif(1, 0, 1.5))
  em <- "waiting_list_pressure(): output vector length != input vector length."
  expect_length(waiting_list_pressure(in1, in2), length(in1))
})
