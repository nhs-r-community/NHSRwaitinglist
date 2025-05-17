#' @title Queue size calculator
#'
#' @description Calculates queue sizes from a waiting list

#'
#' @param waiting_list data.frame consisting addition and removal dates
#' @param start_date Date or character (in format 'YYYY-MM-DD'); start of
#'   calculation period
#' @param end_date Date or character (in format 'YYYY-MM-DD'); end of
#'   calculation period
#' @param referral_index the index of referrals in waiting_list
#' @param removal_index the index of removals in waiting_list
#'
#' @return A data.frame containing the size of the waiting list for each day in
#'   the specified date range. If \code{start_date} and/or \code{end_date} are
#'   \code{NULL}, the function uses the earliest and latest referral dates in
#'   the input data.frame. The returned data.frame has the following columns:
#'
#' \describe{
#'   \item{dates}{Date. Each date within the computed range, starting from the
#'     first referral.}
#'   \item{queue_size}{Numeric. Number of patients on the waiting list
#'     on that date.}
#' }
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' wl_queue_size(waiting_list)
wl_queue_size <- function(waiting_list,
                          start_date = NULL,
                          end_date = NULL) {

  q_size <- sum(wl_h[,3])

  return(q_size)
}
