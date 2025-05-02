test_that("wl_referral_stats errors with incorrect arg classes", {
  referrals <- c(as.Date("2024-01-01"), as.Date("2024-01-04")
                 , as.Date("2024-01-10"), as.Date("2024-01-16"))
  removals <- c(as.Date("2024-01-08"), NA, NA, NA)
  waiting_list <- data.frame(referral = referrals, removal = removals)

  wl_msg <- "`waiting_list` must be of class <data.frame>"

  expect_error(wl_referral_stats(waiting_list = 1), wl_msg)
  expect_error(wl_referral_stats(waiting_list = "cat"), wl_msg)
  expect_error(wl_referral_stats(list(), additions), wl_msg)

  start_msg <- "`start_date` must be of class <Date/character>"

  expect_error(wl_referral_stats(waiting_list, start_date = 1), start_msg)
  expect_error(wl_referral_stats(waiting_list, start_date = list()), start_msg)
  expect_error(wl_referral_stats(waiting_list, start_date = data.frame()),
               start_msg)

  end_msg <- "`end_date` must be of class <Date/character>"

  expect_error(wl_referral_stats(waiting_list, end_date = 1), end_msg)
  expect_error(wl_referral_stats(waiting_list, end_date = list()), end_msg)
  expect_error(wl_referral_stats(waiting_list, end_date = data.frame()),
               end_msg)

  ref_msg <- "`referral_index` must be of class <numeric/character/logical>"

  expect_error(wl_referral_stats(waiting_list, referral_index = list()),
               ref_msg)
  expect_error(wl_referral_stats(waiting_list, referral_index = NULL), ref_msg)
  expect_error(wl_referral_stats(waiting_list, referral_index = sum), ref_msg)
})
