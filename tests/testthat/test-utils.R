test_that("check_class doesn't throw an error with appropriate input", {
  expect_no_error(check_class(x = 1, .expected_class = "numeric"))
  expect_no_error(check_class(x = 1, y = 2, .expected_class = "numeric"))
  expect_no_error(check_class(x = 1L, .expected_class = "numeric"))

  expect_no_error(check_class(x = "x", .expected_class = "character"))
  expect_no_error(check_class(x = "x", y = "y", .expected_class = "character"))

  expect_no_error(check_class(x = TRUE, .expected_class = "logical"))
  expect_no_error(check_class(x = TRUE, y = FALSE, .expected_class = "logical"))

  expect_no_error(check_class(x = iris, .expected_class = "data.frame"))
  expect_no_error(check_class(iris, data.frame(), .expected_class = "data.frame"))

  expect_no_error(check_class(x = as.Date(1), .expected_class = "Date"))
  expect_no_error(check_class(as.Date(1), Sys.Date(), .expected_class = "Date"))

  expect_no_error(check_class(x = NULL, .expected_class = "NULL"))
  expect_no_error(check_class(x = NULL, y = NULL, .expected_class = "NULL"))

  expect_no_error(check_class(x = 1L, .expected_class = "integer"))
  expect_no_error(check_class(x = 1L, y = 2L, .expected_class = "integer"))
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

      check_class(x = 1, .expected_class = "logical")
      check_class(x = list(), .expected_class = "logical")
      check_class(x = data.frame(), .expected_class = "logical")
      check_class(x = matrix(), .expected_class = "logical")

      check_class(x = 1, .expected_class = "data.frame")
      check_class(x = list(), .expected_class = "data.frame")
      check_class(x = numeric(), .expected_class = "data.frame")
      check_class(x = matrix(), .expected_class = "data.frame")

      check_class(x = 1, .expected_class = "Date")
      check_class(x = list(), .expected_class = "Date")
      check_class(x = data.frame(), .expected_class = "Date")
      check_class(x = matrix(), .expected_class = "Date")

      check_class(x = 1, .expected_class = "NULL")
      check_class(x = list(), .expected_class = "NULL")
      check_class(x = data.frame(), .expected_class = "NULL")
      check_class(x = matrix(), .expected_class = "NULL")

      check_class(x = "x", .expected_class = "integer")
      check_class(x = list(), .expected_class = "integer")
      check_class(x = data.frame(), .expected_class = "integer")
      check_class(x = matrix(), .expected_class = "integer")
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

      check_class(x = TRUE, y = 1, .expected_class = "logical")
      check_class(x = 1, y = 2, .expected_class = "logical")
      check_class(
        x = TRUE, y = 1, z = list(), a = data.frame(),
        .expected_class = "logical"
      )

      check_class(x = data.frame(), y = 1, .expected_class = "data.frame")
      check_class(x = 1, y = 2, .expected_class = "data.frame")
      check_class(
        x = "x", y = 1, z = list(), a = data.frame(),
        .expected_class = "data.frame"
      )

      check_class(x = as.Date(1), y = 1, .expected_class = "Date")
      check_class(x = 1, y = 2, .expected_class = "Date")
      check_class(
        x = as.Date(1), y = 1, z = list(), a = data.frame(),
        .expected_class = "Date"
      )

      check_class(x = NULL, y = 1, .expected_class = "NULL")
      check_class(x = 1, y = 2, .expected_class = "NULL")
      check_class(
        x = NULL, y = 1, z = list(), a = data.frame(),
        .expected_class = "NULL"
      )

      check_class(x = 1L, y = "x", .expected_class = "integer")
      check_class(x = "x", y = "y", .expected_class = "integer")
      check_class(
        x = 1L, y = "x", z = list(), a = data.frame(),
        .expected_class = "integer"
      )
    },
    error = TRUE
  )
})

test_that("check_class works with multiple expected classes", {
  # For date args
  date_classes <- c("character", "Date")
  expect_no_error(check_class("1900-01-01", .expected_class = date_classes))
  expect_no_error(check_class(as.Date(1), .expected_class = date_classes))

  # For index args
  idx_classes <- c("numeric", "character", "logical")
  expect_no_error(check_class(x = 1, .expected_class = idx_classes))
  expect_no_error(check_class(x = 1L, .expected_class = idx_classes))
  expect_no_error(check_class(x = "referrals", .expected_class = idx_classes))
  expect_no_error(check_class(x = TRUE, .expected_class = idx_classes))

  # Including NULL default arg
  df_classes <- c("NULL", "data.frame")
  expect_no_error(check_class(x = NULL, .expected_class = df_classes))
  expect_no_error(check_class(x = iris, .expected_class = df_classes))
})

cli::test_that_cli("check_class prints error with multiple expected classes", {
  testthat::local_edition(3)
  testthat::expect_snapshot(
    {
      date_classes <- c("character", "Date")
      check_class(x = 1, y = "x", .expected_class = date_classes)
      check_class(x = 1, y = 2, .expected_class = date_classes)
      check_class(
        x = as.Date(1), y = "x", z = list(), a = data.frame(),
        .expected_class = dates_classes
      )


      idx_classes <- c("numeric", "character", "logical")
      check_class(x = NULL, y = 1, .expected_class = idx_classes)
      check_class(x = NULL, y = list(), .expected_class = idx_classes)
      check_class(
        x = "x", y = 1, z = list(), a = data.frame(),
        .expected_class = idx_classes
      )

      check_class(x = TRUE, y = 1, .expected_class = "logical")
      check_class(x = 1, y = 2, .expected_class = "logical")
      check_class(
        x = TRUE, y = 1, z = list(), a = data.frame(),
        .expected_class = "logical"
      )

      df_classes <- c("NULL", "data.frame")
      check_class(x = data.frame(), y = 1, .expected_class = df_classes)
      check_class(x = 1, y = 2, .expected_class = df_classes)
      check_class(
        x = NULL, y = 1, z = list(), a = data.frame(),
        .expected_class = df_classes
      )
    },
    error = TRUE
  )
})
