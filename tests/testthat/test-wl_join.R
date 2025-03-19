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
  em <- "wl_join(): joined lists not of expected length (columns)."
  expect_length(NHSRwaitinglist::wl_join(wl1, wl2), 2)
})

test_that("it joins two waiting list data.frames correctly", {
  em <- "wl_join(): joined lists not of expected length (rows)."
  expect_equal(nrow(NHSRwaitinglist::wl_join(wl1, wl2)), 4)
})

test_that("it joins two waiting list data.frames correctly", {
  em <- "wl_join(): list is sorted, so doesnt match unsorted list."
  expect_false(isTRUE(all.equal(NHSRwaitinglist::wl_join(wl1, wl2), wl3)))
})

test_that("it joins two waiting list data.frames correctly", {
  em <- "wl_join(): expected result for test data including sorting."
  expect_identical(NHSRwaitinglist::wl_join(wl1, wl2), wl3_sorted)
})
