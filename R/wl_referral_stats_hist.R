#' @title Calculate some stats about referrals from histogram data
#'
#' @description Calculate referral statistics from a histogram containing multiple report dates.
#'
#' @param wl_hist data.frame. A histogram with columns: arrival_since, arrival_before,
#'   n, and report_date.
#' @param start_date Date or character (in format 'YYYY-MM-DD'); The start date
#'   to calculate from.
#' @param end_date Date or character (in format 'YYYY-MM-DD'); The end date to
#'   calculate to.
#' @param time_interval Character or numeric. Passed through to format_histogram() when
#'   deriving the histogram end date.
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
#' referrals <- as.Date(c("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16"))
#' removals <- as.Date(c("2024-01-08", NA, NA, NA))
#' hist_waiting_list <- data.frame(
#'   arrival_since = as.Date(c("2024-01-01", "2024-01-08")),
#'   arrival_before = as.Date(c("2024-01-07", "2024-01-14")),
#'   n = c(100, 120),
#'   report_date = as.Date(c("2024-01-31", "2024-02-29"))
#' )
#' referral_stats <- wl_referral_stats_hist(hist_waiting_list)
#'
wl_referral_stats_hist <- function(wl_hist,
                                   start_date = NULL,
                                   end_date = NULL,
                                   time_interval = "weeks") {
  wl_hist <- format_histogram(wl_hist,
    end_date = end_date,
    time_interval = time_interval
  )

  df_referrals <- wl_hist[which.max(wl_hist$arrival_before), ]

  df_referrals$days <- as.numeric(df_referrals$arrival_before[1] + 1 - df_referrals$arrival_since[1])

  referral_stats <- data.frame(
    "demand_weekly" = (df_referrals$n[1] / df_referrals$days[1]) * 7,
    "demand_daily" = (df_referrals$n[1] / df_referrals$days[1]),
    "demand_cov" = 1,
    "demand_count" = df_referrals$n[1]
  )

  return(referral_stats)
}
