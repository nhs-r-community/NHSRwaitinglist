#' @title Insert new referrals into the waiting list
#'
#' @description adds new referrals (removal date is set as NA)
#'
#' @param waiting_list dataframe. A df of referral dates and removals
#' @param additions character vector. A list of referral dates to add to the
#'   waiting list
#' @param referral_index integer. The column number in the waiting_list which
#'   contains the referral dates
#'
#' @return dataframe. A df of the updated waiting list
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' additions <- c.Date("2024-01-03", "2024-01-05", "2024-01-18")
#' longer_waiting_list <- wl_insert(waiting_list, additions)
#'
#' # TODO: What if more columns
#' # Check column types
wl_insert <- function(waiting_list, additions, referral_index = 1) {

  new_rows <- data.frame(
    "referral" = additions,
    "removal" = rep(as.Date(NA), length(additions))
  )

  # recombine to update list
  updated_list <- rbind(waiting_list, new_rows)
  updated_list <- updated_list[order(updated_list[, referral_index]), ]
  return(updated_list)
}
