test_that("wrong input class causes an error", {
  msg_fragment <- "must be of class"
  expect_error(calc_target_capacity("x", 2, 3, 4, 5), msg_fragment)
  expect_error(calc_target_capacity(1, "x", 3, 4, 5), msg_fragment)
  expect_error(calc_target_capacity(1, 2, "x", 4, 5), msg_fragment)
  expect_error(calc_target_capacity(1, 2, 3, "x", 5), msg_fragment)
  expect_error(calc_target_capacity(1, 2, 3, 4, "x"), msg_fragment)
})

test_that("it returns expected result with fixed single values vs arithmetic", {
  em <- "calc_target_capacity(): arithmetic error with single value inputs."
  expect_equal(
    calc_target_capacity(30, 52, 3, 1.1, 1.2),
    30 + (((1.1^2 + 1.2^2) / 2) * (3 / 52))
  )
})

test_that("it returns an expected result with fixed single values", {
  em <- "calc_target_capacity(): arithmetic error with single value inputs."
  expect_equal(calc_target_capacity(30, 52, 3, 1.1, 1.2), 30.076442)
})

# commented out tests as a result of function no longer being vectorised.  Confirm with Neil
# test_that("it returns an expected result with vector of fixed values", {
#   em <- "calc_target_capacity(): arithmetic error with vector of input values."
#   expect_equal(
#     calc_target_capacity(
#       c(30, 42, 35),
#       c(52, 65, 50),
#       c(3, 2, 1),
#       c(1.1, 1.2, 1.3),
#       c(1.4, 1.5, 1.6)
#     ),
#     c(30.0914423, 42.0567692, 35.0425)
#   )
# })


# commented out tests as a result of function no longer being vectorised.  Confirm with Neil
# test_that("it returns the same length output as provided on input", {
#   n <- round(runif(1, 0, 30))
#   in1 <- rnorm(n = n, 50, 20)
#   in2 <- in1 * runif(1, 0.5, 1.5)
#   em <- "calc_target_capacity(): output vector length != input vector length."
#   expect_length(calc_target_capacity(in1, in2), length(in1))
# })
