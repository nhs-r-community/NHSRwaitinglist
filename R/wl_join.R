#' @title Join two waiting list
#'
#' @description Take two waiting list and sorting in date order

#'
#' @param wl_1 a waiting list: dataframe consisting addition and removal dates
#' @param wl_2 a waiting list: dataframe consisting addition and removal dates
#' @param referral_index the column index where referrals are listed
#'
#' @return A data.frame representing the combined waiting list, created by
#'   joining \code{wl_1} and \code{wl_2}. The result is sorted by the referral
#'   date column specified by \code{referral_index}. The column structure is
#'   preserved from the input data frames.
#'
#' @export
#'
#' @examples
#'
#' referrals <- c.Date("2024-01-01","2024-01-04","2024-01-10","2024-01-16")
#' removals <- c.Date("2024-01-08",NA,NA,NA)
#' wl_1 <- data.frame("referral" = referrals ,"removal" = removals )
#'
#' referrals <- c.Date("2024-01-04","2024-01-05","2024-01-16","2024-01-25")
#' removals <- c.Date("2024-01-09",NA,"2024-01-19",NA)
#' wl_2 <- data.frame("referral" = referrals ,"removal" = removals )
#' wl_join(wl_1,wl_2)
#'
wl_join <- function(wl_1, wl_2, referral_index = 1) {
  check_wl(wl_1, referral_index)
  check_wl(wl_2, referral_index)

  # combine and sort to update list
  updated_list <- rbind(wl_1, wl_2)
  updated_list <- updated_list[order(updated_list[, referral_index]), ]
  rownames(updated_list) <- NULL
  return(updated_list)
}
