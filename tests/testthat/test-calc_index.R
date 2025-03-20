# Test tables
wl_test <-
  data.frame(
    stringsAsFactors = FALSE,
    pat_id = c(1L, 2L),
    addition_date = c(
      "2025-03-18",
      "2025-03-18"
    ),
    removal_date = c(
      "2025-03-20",
      "2025-03-23"
    ),
    wait_length = c(
      2.30207068523591,
      5.40635514242535
    ),
    rott = c(FALSE, FALSE)
  )

wl_test2 <-
  data.frame(
    stringsAsFactors = FALSE,
    pat_id = c(
      3L,
      4L, 5L, 6L, 7L
    ),
    addition_date = c(
      "2025-03-18",
      "2025-03-18", "2025-03-19",
      "2025-03-19",
      "2025-03-19"
    ),
    removal = c(
      "2025-03-19",
      "2025-03-19", "2025-03-22",
      "2025-03-23",
      "2025-03-25"
    ),
    wait_length = c(
      0.780050907284021,
      1.04119118489325,
      2.68020559288561,
      4.09979836998468,
      5.61751428212891
    ),
    rott = c(
      FALSE, FALSE, FALSE,
      FALSE, FALSE
    )
  )

wl_test3 <-
  data.frame(
    stringsAsFactors = FALSE,
    pat_id = c(
      8L,
      9L, 10L
    ),
    removal = c(
      "2025-03-19",
      "2025-03-20", "2025-03-22"
    ),
    referral = c(
      "2025-03-19",
      "2025-03-20", "2025-03-20"
    ),
    wait_length = c(
      0.258584674447775,
      0.130485113710165,
      2.40855464339256
    ),
    withdrawal = c(FALSE, FALSE, TRUE),
    target = c(18, 18, 18)
  )


test_that("calc_index calculates correct index", {
  # expect warning/error if miswired
  expect_warning(calc_index(wl_test, type = "removals"))

  # Test default
  result <- NHSRwaitinglist:::calc_index(wl_test)
  expect_equal(result, 1)


  result <- NHSRwaitinglist:::calc_index(wl_test, colname = "waiting_list")
  expect_vector(result)
  expect_equal(result, as.vector(as.numeric()))

  # Test with specified non-default column
  # result <- NHSRwaitinglist:::calc_index(wl_test2, colname = "removal_date")
  # expect_equal(result, 3)

  # Test with specified non-default column, giving the type
  result <- calc_index(wl_test2, colname = "removal"
                       , type = "removal_date")
  expect_equal(result, 3)

  # Test guessing
  expect_warning(calc_index(wl_test3, #colname = "ins"
                            , type = "targets")
                 , label = "Waiting list index not found")

  result <- calc_index(wl_test3, #colname = "ins"
                       , type = "referral")
  expect_equal(result, 3)

  result <- calc_index(wl_test3,
                       # colname = "tg"
                       , type = "target")
  expect_equal(result, 6)

  result <- calc_index(wl_test3#, colname = "rott"
                       , type = "withdrawal")
  expect_equal(result, 5)

  result <- calc_index(wl_test3#, colname = "outs"
                       , type = "removal")
  expect_equal(result, 2)

})
