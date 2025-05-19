#' @title Calculate some stats about referrals
#'
#' @description Calculate some stats about referrals
#'
#' @param waiting_list data.frame. A df of referral dates and removals
#' @param start_date Date or character (in format 'YYYY-MM-DD'); The start date
#'   to calculate from
#' @param end_date Date or character (in format 'YYYY-MM-DD'); The end date to
#'   calculate to
#' @param referral_index the column index of referrals
#'
#' @return A data.frame with the following summary statistics on
#'   referrals/demand:
#'
#' \describe{
#'   \item{demand_weekly}{Numeric. Mean number of additions to the waiting list
#'     per week.}
#'   \item{demand_daily}{Numeric. Mean number of additions to the waiting list
#'     per day.}
#'   \item{demand_cov}{Numeric. Coefficient of variation in the time between
#'     additions to the waiting list.}
#'   \item{demand_count}{Numeric. Total demand over the full time period.}
#' }
#'
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' referral_stats <- wl_referral_stats(waiting_list)
#'
wl_referral_stats_hist <- function(wl_hist,
                              start_date = NULL,
                              end_date = NULL) {


  df_referrals <-  wl_hist[which.max(wl_hist$arrival_before),]

  df_referrals$days <- as.numeric( df_referrals$arrival_since[1]+1 - df_referrals$arrival_before[1])

  referral_stats <- data.frame(
    "demand_weekly" = (df_referrals$n[1] / df_referrals$days[1] ) * 7,
    "demand_daily" = (df_referrals$n[1] / df_referrals$days[1] ),
    "demand_cov" = 1,
    "demand_count" = df_referrals$n[1]
  )

  return(referral_stats)
}