test_that("wrong input class causes an error", {
  msg_fragment <- "must be of class"
  expect_error(calc_target_mean_wait(1, "x"), msg_fragment)
  expect_error(calc_target_mean_wait("x", 1), msg_fragment)
})

test_that("it returns expected result with fixed single values vs arithmetic", {
  em <- "calc_target_mean_wait(): arithmetic error with single value inputs."
  expect_equal(calc_target_mean_wait(52, 4), 52 / 4)
})

test_that("it returns an expected result with fixed single values", {
  em <- "calc_target_mean_wait(): arithmetic error with single value inputs."
  expect_equal(calc_target_mean_wait(52, 4), 13)
})



test_that("it returns an expected result with vector of fixed values", {
  em <- "calc_target_mean_wait():
  aritmetic error with vector of values as inputs."
  expect_equal(
    calc_target_mean_wait(
      c(35, 30, 52),
      c(4, 4, 6)
    ),
    c(8.75, 7.5, 8.6666667)
  )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0, 30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- rnorm(n = n, 4, 2)
  em <- "calc_target_mean_wait(): output vector length != input vector length."
  expect_length(calc_target_mean_wait(in1, in2), length(in1))
})
