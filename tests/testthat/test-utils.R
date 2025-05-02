# check_class -------------------------------------------------------------

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

test_that("check_class errors correctly with multiple expected classes", {
  date_classes <- c("Date", "character")
  date_msg <- "must be of class <Date/character>"

  expect_error(check_class(x = 1, y = "x", .expected_class = date_classes),
               date_msg)
  expect_error(check_class(x = 1, y = 2, .expected_class = date_classes),
               date_msg)
  expect_error(
    check_class(
      x = as.Date(1), y = "x", z = list(), a = data.frame(),
      .expected_class = date_classes
    ),
    date_msg
  )

  idx_classes <- c("numeric", "character", "logical")
  idx_msg <- "must be of class <numeric/character/logical>"
  expect_error(check_class(x = NULL, y = 1, .expected_class = idx_classes),
               idx_msg)
  expect_error(check_class(x = NULL, y = list(), .expected_class = idx_classes),
               idx_msg)
  expect_error(
    check_class(x = "x", y = 1, z = list(), a = data.frame(),
                .expected_class = idx_classes),
    idx_msg
  )

  # expect to be able to check for NULL, to allow NULL from default value
  df_classes <- c("NULL", "data.frame")
  # but not in error message because user is not expected to supply NULL

  df_msg <- "must be of class <data.frame>"
  expect_error(check_class(x = data.frame(), y = 1,
                           .expected_class = df_classes),
               df_msg)
  expect_error(check_class(x = data.frame(), y = 1,
                           .expected_class = df_classes),
               df_msg)

  expect_error(check_class(x = 1, y = 2, .expected_class = df_classes),
               df_msg)
  expect_error(
    check_class(x = NULL, y = 1, z = list(), a = data.frame(),
                .expected_class = df_classes),
    df_msg
  )
})

# check_date --------------------------------------------------------------

test_that("check_date doesn't error with correct input", {
  # Date formats
  date_1 <- as.Date(1)
  date_2 <- Sys.Date()
  expect_no_error(check_date(date_1))
  expect_no_error(check_date(date_2))
  expect_no_error(check_date(date_1, date_2)) # multiple inputs
  expect_no_error(check_date(c(date_1, date_2))) # length > 1 input

  # Unambigious character formats
  expect_no_error(check_date("2000-01-01")) # YYYY-MM-DD
  expect_no_error(check_date("28-02-2000")) # DD-MM-YYYY
  expect_no_error(check_date("2000-01-01", "28-02-2000")) # multiple inputs
  expect_no_error(check_date(c("2000-01-01", "28-02-2000"))) # length > 1 input

  # NULL
  expect_no_error(check_date(NULL, .allow_null = TRUE))

  # mixed
  expect_no_error(check_date(date_1, "2000-01-01"))
  expect_no_error(check_date(NULL, date_1, .allow_null = TRUE))
  expect_no_error(check_date(NULL, date_1, "2000-01-01", .allow_null = TRUE))
})

test_that("check_date errors with incorrect class", {
  class_msg <- "must be of class <Date/character>"
  expect_error(check_date(1), class_msg)
  expect_error(check_date(1L), class_msg)
  expect_error(check_date(TRUE), class_msg)
  expect_error(check_date(list()), class_msg)
  expect_error(check_date(data.frame()), class_msg)

  expect_error(check_date(1, Sys.Date()), class_msg)
  expect_error(check_date(c(1, Sys.Date())), class_msg)

  # date_1 is coerced to numeric with NULL
  expect_error(check_date(c(NULL, date_1), .allow_null = TRUE), class_msg)
})

test_that("check_date errors with ambigious character format", {
  format_msg <- "must be in an unambiguous Date format e.g., 'YYYY-MM-DD'"

  expect_error(check_date("not a date"), format_msg)
  expect_error(check_date("2000-30-30"), format_msg)
  expect_error(check_date("-2000-01-01"), format_msg)
  expect_error(check_date("2.000-01-01"), format_msg)

  expect_error(check_date("not a date", "also not a date"), format_msg)
  expect_error(check_date(c("not a date", "also not a date")), format_msg)

  # date_1 is coerced to numeric `1` with NULL, then to character `"1"`
  expect_error(check_date(c(NULL, date_1, "2000-01-01"), .allow_null = TRUE),
               format_msg)
})