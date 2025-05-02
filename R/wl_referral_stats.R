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
wl_referral_stats <- function(waiting_list,
                              start_date = NULL,
                              end_date = NULL,
                              referral_index = 1) {
  check_class(waiting_list, .expected_class = "data.frame")
  check_date(start_date, end_date, .allow_null = TRUE)
  check_class(referral_index,
              .expected_class = c("numeric", "character", "logical"))

  if (!is.null(start_date)) {
    start_date <- as.Date(start_date)
  } else {
    start_date <- min(waiting_list[, referral_index])
  }
  if (!is.null(end_date)) {
    end_date <- as.Date(end_date)
  } else {
    end_date <- max(waiting_list[, referral_index])
  }

  arrival_dates <- c(
    as.Date(start_date),
    waiting_list[
      which(start_date <= waiting_list[, referral_index] &
              waiting_list[, referral_index] <= end_date), referral_index
    ],
    as.Date(end_date)
  )

  inter_arrival_times <- diff(arrival_dates, lags = -1)
  mean_arrival <- as.numeric(mean(inter_arrival_times))
  sd_arrival <- stats::sd(inter_arrival_times)
  cv_arrival <- sd_arrival / mean_arrival
  num_arrivals <- length(inter_arrival_times)
  demand <- 1 / mean_arrival
  demand_weekly <- 7 * demand


  referral_stats <- data.frame(
    "demand_weekly" = demand_weekly,
    "demand_daily" = demand,
    "demand_cov" = cv_arrival,
    "demand_count" = num_arrivals
  )

  return(referral_stats)
}
