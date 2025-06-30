wl1 <- data.frame(referrals = c("2024-01-01", "2024-02-03")
                  , removals = c("2024-03-01", "2024-05-05"))

wl2 <- data.frame(referrals = c("2024-01-02", "2024-03-03")
                  , removals = c("2024-05-21", "2024-07-15"))

wl3 <-
  data.frame(

    stringsAsFactors = FALSE,
    referrals = c("2024-01-01", "2024-03-01", "2024-02-01", "2024-03-03"),
    removals = c("2024-01-03", "2024-05-05", "2024-05-21", "2024-07-15")
  )

wl3_sorted <-
  data.frame(
    stringsAsFactors = FALSE,
    referrals = c("2024-01-01", "2024-01-02", "2024-02-03", "2024-03-03"),
    removals = c("2024-03-01", "2024-05-21", "2024-05-05", "2024-07-15")
  )

test_that("it joins two waiting list data.frames correctly", {
  em <- "wl_join(): list with inserts returns wrong class"
  expect_s3_class(wl_join(wl1, wl2), "data.frame")
})

test_that("it joins two waiting list data.frames correctly", {
  em <- "wl_join(): joined lists not of expected length (columns)."
  expect_length(wl_join(wl1, wl2), 2)
})

test_that("it joins two waiting list data.frames correctly", {
  em <- "wl_join(): joined lists not of expected length (rows)."
  expect_equal(nrow(wl_join(wl1, wl2)), 4)
})

test_that("it joins two waiting list data.frames correctly", {
  em <- "wl_join(): list is sorted, so doesnt match unsorted list."
  expect_false(isTRUE(all.equal(wl_join(wl1, wl2), wl3)))
})

test_that("it joins two waiting list data.frames correctly", {
  em <- "wl_join(): expected result for test data including sorting."
  expect_identical(wl_join(wl1, wl2), wl3_sorted)
})

test_that("wl_join errors with incorrect arg classes", {
  wl1_msg <- "`wl_1` must be of class <data.frame>"

  expect_error(wl_join(1, wl2), wl1_msg)
  expect_error(wl_join("cat", wl2), wl1_msg)

  wl2_msg <- "`wl_2` must be of class <data.frame>"

  expect_error(wl_join(wl1, 2), wl2_msg)
  expect_error(wl_join(wl1, "dog"), wl2_msg)

  wl_msg <- "`wl_1` must be of class <data.frame>"

  expect_error(wl_join(1, 2), wl_msg)
  expect_error(wl_join("cat", "dog"), wl_msg)

  idx_msg <- "`referral_index` must be of class <numeric/character/logical>"

  expect_error(wl_join(wl1, wl2, referral_index = list(), idx_msg))
  expect_error(wl_join(wl1, wl2, referral_index = NULL, idx_msg))
  expect_error(wl_join(wl1, wl2, referral_index = as.Date(1)), idx_msg)
})
