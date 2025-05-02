#' @title Insert new referrals into the waiting list
#'
#' @description Adds new referrals, with other columns set as \code{NA}.
#'
#' @param waiting_list data.frame. A df of referral dates and removals
#' @param additions Character or Date vector. A list of referral dates to add to
#'   the waiting list
#' @param referral_index The index of the column in \code{waiting_list} which
#'   contains the referral dates. Defaults to the first column.
#'
#' @return A \code{data.frame} representing the updated waiting list,
#'   with additional referrals dates in the column specified by
#'   \code{referral_index}. Other columns are filled with \code{NA} in the
#'   new rows. The result is sorted by the referral column.
#'
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' additions <- c.Date("2024-01-03", "2024-01-05", "2024-01-18")
#' longer_waiting_list <- wl_insert(waiting_list, additions)
#'
wl_insert <- function(waiting_list, additions, referral_index = 1) {
  check_class(waiting_list, .expected_class = "data.frame")
  check_date(additions)
  check_class(referral_index,
              .expected_class = c("numeric", "character", "logical"))

  # keep waiting_list structure and fill with NAs
  new_rows <- waiting_list[0, ]
  new_rows[seq_along(additions), ] <- NA

  new_rows[referral_index] <- additions

  # recombine to update list
  updated_list <- rbind(waiting_list, new_rows)
  updated_list <- updated_list[order(updated_list[, referral_index]), ]
  return(updated_list)
}
