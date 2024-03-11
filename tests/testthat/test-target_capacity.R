test_that("wrong input class causes an error", {
  msg_fragment <- "must be of class"
  expect_error(target_capacity("x", 2, 3), msg_fragment)
  expect_error(target_capacity(1, "x", 3), msg_fragment)
  expect_error(target_capacity(1, 2, "x"), msg_fragment)
})

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
