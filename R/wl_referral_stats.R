#' @title Calculate some stats about referrals
#'
#' @description Calculate some stats about referrals
#'
#' @param waiting_list dataframe. A df of referral dates and removals
#' @param start_date date. The start date to calculate from
#' @param end_date date. The end date to calculate to
#'
#' @return dataframe. A df containing number of referrals, mean demand,
#'   and the coefficient of variation of referrals
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' referral_stats <- wl_referral_stats(waiting_list)
#'
#' # TODO : referral <- arrival
#' # debug and test
#' # simplify notation
#' # add detail to params above
#' # arrival mean and variance
wl_referral_stats <- function(waiting_list,
                              start_date = NULL,
                              end_date = NULL) {
  if (!is.null(start_date)) {
    start_date <- as.Date(start_date)
  } else {
    start_date <- min(waiting_list[, 1])
  }
  if (!is.null(end_date)) {
    end_date <- as.Date(end_date)
  } else {
    end_date <- max(waiting_list[, 1])
  }

  arrival_dates <- c(
    as.Date(start_date),
    waiting_list[
      which(start_date <= waiting_list[, 1] &
              waiting_list[, 1] <= end_date), 1
    ],
    as.Date(end_date)
  )

  inter_arrival_times <- diff(arrival_dates, lags = -1)
  mean_arrival <- as.numeric(mean(inter_arrival_times))
  sd_arrival <- sd(inter_arrival_times)
  cv_arrival <- sd_arrival / mean_arrival
  num_arrivals <- length(inter_arrival_times)
  demand <- 1 / mean_arrival
  demand_weekly <- 7 * demand


  referral_stats <- data.frame(
    "demand.weekly" = demand_weekly,
    "demand.daily" = demand,
    "demand.cov" = cv_arrival,
    "demand.count" = num_arrivals
  )

  return(referral_stats)
}
