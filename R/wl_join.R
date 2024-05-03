#' @title Join two waiting list
#'
#' @description Take two waiting list and sorting in date order

#'
#' @param wl_1 a waiting list: dataframe consisting addition and removal dates
#' @param wl_2 a waiting list: dataframe consisting addition and removal dates
#' @param referral_index the column index where referrals are listed
#'
#' @return updated_list a new waiting list
#' @export
#'
#' @examples
#'
#' # referrals <- c.Date("2024-01-01","2024-01-04","2024-01-10","2024-01-16")
#' # removals <- c.Date("2024-01-08",NA,NA,NA)
#' # wl_1 <- data.frame("referral" = referrals ,"removal" = removals )
#'
#' # referrals <- c.Date("2024-01-04","2024-01-05","2024-01-16","2024-01-25")
#' # removals <- c.Date("2024-01-09",NA,"2024-01-19",NA)
#' # wl_2 <- data.frame("referral" = referrals ,"removal" = removals )
#' # wl_join(wl_1,wl_2)
wl_join <- function(wl_1, wl_2, referral_index = 1) {
  # combine and sort to update list
  updated_list <- rbind(wl_1, wl_2)
  updated_list <- updated_list[order(updated_list[, referral_index]), ]
  return(updated_list)
}
