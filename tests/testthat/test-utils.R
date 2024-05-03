test_that("check_class doesn't throw an error with appropriate input", {
  expect_no_error(check_class(x = 1, .expected_class = "numeric"))
  expect_no_error(check_class(x = 1, y = 2, .expected_class = "numeric"))

  expect_no_error(check_class(x = "x", .expected_class = "character"))
  expect_no_error(check_class(x = "x", y = "y", .expected_class = "character"))
})

cli::test_that_cli("check_class prints error for single input", {
  testthat::local_edition(3)
  testthat::expect_snapshot(
    {
      check_class(x = "x", .expected_class = "numeric")
      check_class(x = list(), .expected_class = "numeric")
      check_class(x = data.frame(), .expected_class = "numeric")
      check_class(x = matrix(), .expected_class = "numeric")

      check_class(x = 1, .expected_class = "character")
      check_class(x = list(), .expected_class = "character")
      check_class(x = data.frame(), .expected_class = "character")
      check_class(x = matrix(), .expected_class = "character")
    },
    error = TRUE
  )
})

cli::test_that_cli("check_class prints error for multiple input", {
  testthat::local_edition(3)
  testthat::expect_snapshot(
    {
      check_class(x = 1, y = "x", .expected_class = "numeric")
      check_class(x = "x", y = "y", .expected_class = "numeric")
      check_class(
        x = 1, y = "x", z = list(), a = data.frame(),
        .expected_class = "numeric"
      )

      check_class(x = "x", y = 1, .expected_class = "character")
      check_class(x = 1, y = 2, .expected_class = "character")
      check_class(
        x = "x", y = 1, z = list(), a = data.frame(),
        .expected_class = "character"
      )
    },
    error = TRUE
  )
})
