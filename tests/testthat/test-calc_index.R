
wl_test <- tibble::tribble(
  ~pat_id, ~addition_date, ~removal_date,      ~wait_length, ~rott,
  1L,   "2025-03-18",  "2025-03-20",  2.30207068523591, FALSE,
  2L,   "2025-03-18",  "2025-03-23",  5.40635514242535, FALSE)

wl_test2 <- tibble::tribble(
  ~pat_id, ~addition_date, ~removal_date,      ~wait_length, ~rott,
  3L,   "2025-03-18",  "2025-03-19", 0.780050907284021, FALSE,
  4L,   "2025-03-18",  "2025-03-19",  1.04119118489325, FALSE,
  5L,   "2025-03-19",  "2025-03-22",  2.68020559288561, FALSE,
  6L,   "2025-03-19",  "2025-03-23",  4.09979836998468, FALSE,
  7L,   "2025-03-19",  "2025-03-25",  5.61751428212891, FALSE)

wl_test3 <- tibble::tribble(
  ~pat_id,  ~removal_date, ~addition_date,      ~wait_length, ~rott,
  8L,   "2025-03-19", "2025-03-19",   0.258584674447775, FALSE,
  9L,   "2025-03-20", "2025-03-20",   0.130485113710165, FALSE,
  10L,   "2025-03-22", "2025-03-20",  2.40855464339256, FALSE
)



test_that("calc_index calculates correct index", {

  # expect warning/error if miswired
  expect_warning(calc_index(wl_test2, type = "removals")) # replace 0.5 with the actual expected value

  # Test default
  result <- calc_index(wl_test)
  expect_equal(result, 1)  # replace 0.5 with the actual expected value


  result <- calc_index(wl_test2, colname = "waiting_list")
  expect_vector(result)
  expect_equal(result, as.vector(as.numeric()))

  # Test with specified non-default column
  result <-  calc_index(wl_test2, colname = "removal_date")
  expect_equal(result, 3)  # replace 0.5 with the actual expected value

  # Test with specified non-default column, giving the type
  result <- calc_index(wl_test3, colname = "removal_date", type=withdrawal)
  expect_equal(result, 2)  # replace 0.5 with the actual expected value


})
