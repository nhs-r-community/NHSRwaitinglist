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
  expect_no_error(check_class(iris, data.frame(),
                              .expected_class = "data.frame"))

  expect_no_error(check_class(x = as.Date(1), .expected_class = "Date"))
  expect_no_error(check_class(as.Date(1), Sys.Date(), .expected_class = "Date"))

  expect_no_error(check_class(x = NULL, .expected_class = "NULL"))
  expect_no_error(check_class(x = NULL, y = NULL, .expected_class = "NULL"))

  expect_no_error(check_class(x = 1L, .expected_class = "integer"))
  expect_no_error(check_class(x = 1L, y = 2L, .expected_class = "integer"))
})

testthat::test_that("check_class prints error for single input", {
  testthat::local_edition(3)

  expect_error(check_class(x = "x", .expected_class = "numeric"),
               "must be of class <numeric>")
  expect_error(check_class(x = list(), .expected_class = "numeric"),
               "must be of class <numeric>")
  expect_error(check_class(x = data.frame(), .expected_class = "numeric"),
               "must be of class <numeric>")
  expect_error(check_class(x = matrix(), .expected_class = "numeric"),
               "must be of class <numeric>")

  expect_error(check_class(x = 1, .expected_class = "character"),
               "must be of class <character>")
  expect_error(check_class(x = list(), .expected_class = "character"),
               "must be of class <character>")
  expect_error(check_class(x = data.frame(), .expected_class = "character"),
               "must be of class <character>")
  expect_error(check_class(x = matrix(), .expected_class = "character"),
               "must be of class <character>")

  expect_error(check_class(x = 1, .expected_class = "logical"),
               "must be of class <logical>")
  expect_error(check_class(x = list(), .expected_class = "logical"),
               "must be of class <logical>")
  expect_error(check_class(x = data.frame(), .expected_class = "logical"),
               "must be of class <logical>")
  expect_error(check_class(x = matrix(), .expected_class = "logical"),
               "must be of class <logical>")

  expect_error(check_class(x = 1, .expected_class = "data.frame"),
               "must be of class <data.frame>")
  expect_error(check_class(x = list(), .expected_class = "data.frame"),
               "must be of class <data.frame>")
  expect_error(check_class(x = numeric(), .expected_class = "data.frame"),
               "must be of class <data.frame>")
  expect_error(check_class(x = matrix(), .expected_class = "data.frame"),
               "must be of class <data.frame>")

  expect_error(check_class(x = 1, .expected_class = "Date"),
               "must be of class <Date>")
  expect_error(check_class(x = list(), .expected_class = "Date"),
               "must be of class <Date>")
  expect_error(check_class(x = data.frame(), .expected_class = "Date"),
               "must be of class <Date>")
  expect_error(check_class(x = matrix(), .expected_class = "Date"),
               "must be of class <Date>")

  expect_error(check_class(x = 1, .expected_class = "NULL"),
               "must be of class <NULL>")
  expect_error(check_class(x = list(), .expected_class = "NULL"),
               "must be of class <NULL>")
  expect_error(check_class(x = data.frame(), .expected_class = "NULL"),
               "must be of class <NULL>")
  expect_error(check_class(x = matrix(), .expected_class = "NULL"),
               "must be of class <NULL>")

  expect_error(check_class(x = "x", .expected_class = "integer"),
               "must be of class <integer>")
  expect_error(check_class(x = list(), .expected_class = "integer"),
               "must be of class <integer>")
  expect_error(check_class(x = data.frame(), .expected_class = "integer"),
               "must be of class <integer>")
  expect_error(check_class(x = matrix(), .expected_class = "integer"),
               "must be of class <integer>")
})

testthat::test_that("check_class prints error for multiple input", {
  testthat::local_edition(3)

  expect_error(check_class(x = 1, y = "x", .expected_class = "numeric"),
               "must be of class <numeric>")
  expect_error(check_class(x = "x", y = "y", .expected_class = "numeric"),
               "must be of class <numeric>")
  expect_error(check_class(
    x = 1, y = "x", z = list(), a = data.frame(),
    .expected_class = "numeric"
  ), "must be of class <numeric>")

  expect_error(check_class(x = "x", y = 1, .expected_class = "character"),
               "must be of class <character>")
  expect_error(check_class(x = 1, y = 2, .expected_class = "character"),
               "must be of class <character>")
  expect_error(check_class(
    x = "x", y = 1, z = list(), a = data.frame(),
    .expected_class = "character"
  ), "must be of class <character>")

  expect_error(check_class(x = TRUE, y = 1, .expected_class = "logical"),
               "must be of class <logical>")
  expect_error(check_class(x = 1, y = 2, .expected_class = "logical"),
               "must be of class <logical>")
  expect_error(check_class(
    x = TRUE, y = 1, z = list(), a = data.frame(),
    .expected_class = "logical"
  ), "must be of class <logical>")

  expect_error(
    check_class(x = data.frame(), y = 1, .expected_class = "data.frame"),
    "must be of class <data.frame>"
  )
  expect_error(check_class(x = 1, y = 2, .expected_class = "data.frame"),
               "must be of class <data.frame>")
  expect_error(
    check_class(x = "x", y = 1, z = list(), a = data.frame(),
                .expected_class = "data.frame"),
    "must be of class <data.frame>"
  )

  expect_error(check_class(x = as.Date(1), y = 1, .expected_class = "Date"),
               "must be of class <Date>")
  expect_error(check_class(x = 1, y = 2, .expected_class = "Date"),
               "must be of class <Date>")
  expect_error(check_class(
    x = as.Date(1), y = 1, z = list(), a = data.frame(),
    .expected_class = "Date"
  ), "must be of class <Date>")

  expect_error(check_class(x = NULL, y = 1, .expected_class = "NULL"),
               "must be of class <NULL>")
  expect_error(check_class(x = 1, y = 2, .expected_class = "NULL"),
               "must be of class <NULL>")
  expect_error(check_class(
    x = NULL, y = 1, z = list(), a = data.frame(),
    .expected_class = "NULL"
  ), "must be of class <NULL>")

  expect_error(check_class(x = 1L, y = "x", .expected_class = "integer"),
               "must be of class <integer>")
  expect_error(check_class(x = "x", y = "y", .expected_class = "integer"),
               "must be of class <integer>")
  expect_error(check_class(
    x = 1L, y = "x", z = list(), a = data.frame(),
    .expected_class = "integer"
  ), "must be of class <integer>")
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
})

test_that("check_date errors with ambigious character format", {
  format_msg <- "must be in an unambiguous Date format e.g., 'YYYY-MM-DD'"

  expect_error(check_date("not a date"), format_msg)
  expect_error(check_date("2000-30-30"), format_msg)
  expect_error(check_date("-2000-01-01"), format_msg)
  expect_error(check_date("2.000-01-01"), format_msg)

  expect_error(check_date("not a date", "also not a date"), format_msg)
  expect_error(check_date(c("not a date", "also not a date")), format_msg)
})

# check_wl -------------------------------------------------------------

test_that("check_wl errors correctly by waiting list class", {
  # no error for data frames
  expect_no_error(check_wl(iris))
  expect_no_error(check_wl(mtcars))

  # error for non-data frames
  df_msg <- "must be of class <data.frame>"

  expect_error(check_wl(1), df_msg)
  expect_error(check_wl(1), "`1` with class <numeric>")

  expect_error(check_wl(TRUE), df_msg)
  expect_error(check_wl(TRUE), "`TRUE` with class <logical>")

  expect_error(check_wl(letters), df_msg)
  expect_error(check_wl(letters), "`letters` with class <character>")
})

test_that("check_wl handles 0 row data frames correctly", {
  empty_df <- iris[0, ]
  msg <- "`empty_df` has 0 rows of data"

  expect_error(check_wl(empty_df), msg) # default
  expect_error(check_wl(empty_df, .empty_wl = "error"), msg)

  expect_warning(check_wl(empty_df, .empty_wl = "warn"), msg)

  expect_no_error(check_wl(empty_df, .empty_wl = "allow"))
})

test_that("check_wl errors on incorrect index class", {
  idx_msg <-  "must be of class <numeric/character/logical>"

  date <- Sys.Date()
  expect_error(check_wl(iris, date), idx_msg)
  expect_error(check_wl(iris, date), "`date` with class <Date>")

  # multiple indices
  fct_l <- as.factor(letters)
  fct_u <- as.factor(LETTERS)
  expect_error(check_wl(iris, fct_l, fct_u), idx_msg)
  expect_error(check_wl(iris, fct_l, fct_u), "`fct_l` with class <factor>")
  expect_error(check_wl(iris, fct_l, fct_u), "`fct_u` with class <factor>")
})

test_that("check_wl errors clearly on NA index", {
  na_msg <- r"(Column indices must not be "NA")"

  expect_error(check_wl(iris, NA), na_msg)
  expect_error(check_wl(iris, NA_real_), na_msg)
  expect_error(check_wl(iris, NA_character_), na_msg)
  expect_error(check_wl(iris, NA_integer_), na_msg)
  expect_error(check_wl(iris, idx_1 = NA, idx_2 = NA), na_msg)

  # You provided:
  expect_error(check_wl(iris, idx_1 = NA, idx_2 = NA),
               r"(`idx_1` with value "NA")")
  expect_error(check_wl(iris, idx_1 = NA, idx_2 = NA),
               r"(`idx_2` with value "NA")")
})

test_that("check_wl errors if index column not found in waiting list", {
  found_msg <- "not found in `iris`"

  num_idx <- 10
  expect_error(check_wl(iris, num_idx), found_msg)
  expect_error(check_wl(iris, num_idx), r"(`num_idx` with value "10")")

  chr_idx <- "not a col"
  expect_error(check_wl(iris, chr_idx), found_msg)
  expect_error(check_wl(iris, chr_idx), r"(`chr_idx` with value "not a col")")

  lgl_idx <- c(TRUE, FALSE)
  expect_error(check_wl(iris, lgl_idx), found_msg)
  expect_error(check_wl(iris, lgl_idx), r"(`lgl_idx` with value "TRUE, FALSE")")

  multi_num <- c(1, 2, 3)
  expect_error(check_wl(iris, multi_num), found_msg)
  expect_error(check_wl(iris, multi_num), r"(`multi_num` with value "1, 2, 3")")

  multi_chr <- c("a", "b", "c")
  expect_error(check_wl(iris, multi_chr), found_msg)
  expect_error(check_wl(iris, multi_chr), r"(`multi_chr` with value "a, b, c")")
})
