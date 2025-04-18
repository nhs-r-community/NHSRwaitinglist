wl1 <- data.frame(referral = c.Date("2024-01-01", "2024-02-03")
                  , removal = c.Date("2024-03-01", "2024-05-05"))

additions <- c.Date("2024-01-02", "2024-03-03")

expected_out <-
  data.frame(
    stringsAsFactors = FALSE,
    row.names = as.integer(c("1", "3", "2", "4")),
    referral = c.Date("2024-01-01",
                      "2024-01-02",
                      "2024-02-03",
                      "2024-03-03"),
    removal = c.Date("2024-03-01",
                     NA,
                     "2024-05-05",
                     NA)
  )


test_that("inserting to list returns right output", {
  em <- "wl_insert(): list with inserts returns wrong class"
  expect_s3_class(wl_insert(wl1, additions), "data.frame")
})

test_that("inserting to list returns right output", {
  em <- "wl_insert(): list with inserts returns wrong number of columns"
  expect_length(wl_insert(wl1, additions), 2)
})


test_that("inserting to list returns right output", {
  em <- "wl_insert(): list with inserts returns wrong number of columns"
  expect_length(wl_insert(wl1, additions), 2)
})

test_that("inserting to list returns right output", {
  em <- "wl_insert(): joined lists not of expected length (rows)."
  expect_equal(nrow(wl_insert(wl1, additions)), 4)
})

test_that("inserting to list returns right output", {
  em <- "wl_insert(): expected result for test data including sorting."
  expect_identical(wl_insert(wl1, additions), expected_out)
})

test_that("the column receiving additions is defined by the index", {
  referral_index <- 2
  other_index <- 1

  test_output <- wl_insert(wl1,
                           additions,
                           referral_index = referral_index)

  # no NAs added at chosen index
  expect_equal(
    sum(is.na(test_output[[referral_index]])),
    sum(is.na(wl1[[referral_index]]))
  )

  # NAs added elsewhere
  expect_gt(
    sum(is.na(test_output[[other_index]])),
    sum(is.na(wl1[[other_index]]))
  )
})

test_that("valid indexes of different types work", {
  # numeric
  expect_identical(wl_insert(wl1,
                             additions,
                             referral_index = 1),
                   expected_out)
  # character
  expect_identical(wl_insert(wl1,
                             additions,
                             referral_index = "referral"),
                   expected_out)
  # logical
  expect_identical(wl_insert(wl1,
                             additions,
                             referral_index = c(TRUE, FALSE)),
                   expected_out)
})
