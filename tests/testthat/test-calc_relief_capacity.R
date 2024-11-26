test_that("wrong input class causes an error", {
  msg_fragment <- "must be of class"
  expect_error(calc_relief_capacity("x", 2, 3, 4), msg_fragment)
  expect_error(calc_relief_capacity(1, "x", 3, 4), msg_fragment)
  expect_error(calc_relief_capacity(1, 2, "x", 4), msg_fragment)
  expect_error(calc_relief_capacity(1, 2, 3, "x"), msg_fragment)
})

test_that("it returns expected result with fixed single values vs arithmetic", {
  em <- "calc_relief_capacity(): arithmetic error with single value inputs."
  expect_equal(calc_relief_capacity(30, 1200, 390, 26), 30 + (1200 - 390) / 26)
})

test_that("it returns an expected result with fixed single values", {
  em <- "calc_relief_capacity(): arithmetic error with single value inputs."
  expect_equal(calc_relief_capacity(30, 1200, 390, 26), 61.153846)
})

test_that("it returns an expected result with vector of fixed values", {
  em <- "calc_relief_capacity(): arithmetic error with vector of input values."
  expect_equal(
    calc_relief_capacity(
      c(30, 33, 35),
      c(1200, 800, 250),
      c(390, 200, 100),
      c(26, 30, 15)
    ),
    c(61.153846, 53, 45)
  )
})


test_that("it returns the same length output as provided on input", {
  n <- round(runif(1, 0, 30))
  in1 <- rnorm(n = n, 50, 20)
  in2 <- in1 * (15 * runif(1, 0, 1.5))
  in3 <- in1 * (5 * runif(1, 1, 1.5))
  in4 <- in1 * (runif(1, 0.5, 1.5))

  em <- "calc_relief_capacity(): output vector length != input vector length."
  expect_length(calc_relief_capacity(in1, in2, in3, in4), length(in1))
})
