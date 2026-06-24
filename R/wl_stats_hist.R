#' @title Calculate waiting list statistics from histogram data
#'
#' @description A summary of all the key stats associated with a waiting list
#'   using histogram format data with multiple report dates.
#'
#' @param wl_hist data.frame. A histogram with columns: arrival_since, arrival_before,
#'   n, and report_date. Must contain at least 2 unique report_date values.
#' @param target_wait numeric. The required waiting time in weeks.
#' @param start_date Date or character (in format 'YYYY-MM-DD'); The start date
#'   for calculating removal statistics. If NULL, uses earliest report_date.
#' @param end_date Date or character (in format 'YYYY-MM-DD'); The end date for
#'   calculating removal statistics. If NULL, uses latest report_date.
#'
#' @importFrom dplyr filter
#'
#' @return A data.frame of key waiting list summary statistics based on
#'   queueing theory:
#'
#' \describe{
#'   \item{mean_demand}{Numeric. Mean number of additions to the waiting list
#'     per week.}
#'   \item{mean_capacity}{Numeric. Mean number of removals from the waiting list
#'     per week.}
#'   \item{load}{Numeric. Ratio between demand and capacity.}
#'   \item{load_too_big}{Logical. Whether the load is greater than or equal to
#'     1, indicating whether the waiting list is unstable and expected to grow.}
#'   \item{count_demand}{Numeric. Total demand (i.e., number of referrals) over
#'     the full time period.}
#'   \item{queue_size}{Numeric. Number of patients on the waiting list at the
#'     end of the time period.}
#'   \item{target_queue_size}{Numeric. The recommended size of the waiting list
#'     to achieve approximately 98.2% of patients being treated within their
#'     target wait time. This is based on Little’s Law, assuming the system
#'     is in equilibrium, with the average waiting time set to one-quarter of
#'     the \code{target_wait}.}
#'   \item{queue_too_big}{Logical. Whether \code{queue_size} is more than twice
#'     the \code{target_queue_size}. A value of \code{TRUE} indicates the queue
#'     is at risk of missing its targets.}
#'   \item{mean_wait_age}{Numeric. Mean waiting age in days.}
#'   \item{mean_wait}{Numeric. Legacy alias for \code{mean_wait_age}.}
#'   \item{cv_arrival}{Numeric. Coefficient of variation in the time between
#'     additions to the waiting list.}
#'   \item{cv_removal}{Numeric. Coefficient of variation in the time between
#'     removals from the waiting list.}
#'   \item{target_capacity}{Numeric. The weekly treatment capacity required to
#'     maintain the waiting list at its target equilibrium, assuming the target
#'     queue size has been reached.}
#'   \item{relief_capacity}{Numeric. The temporary weekly capacity required to
#'     reduce the waiting list to its \code{target_queue_size} within 26 weeks,
#'     assuming current demand remains steady. Calculated only if
#'     \code{queue_too_big} is \code{TRUE}; otherwise returns \code{NA}.}
#'   \item{pressure}{Numeric. A measure of pressure on the system, defined as
#'     \code{2 × mean_wait_age / target_wait}. Values greater than 1 suggest the
#'     system is unlikely to meet its waiting time targets.}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Histogram with multiple report dates
#' wl_hist <- data.frame(
#'   arrival_since = as.Date(c("2024-01-01", "2024-01-08")),
#'   arrival_before = as.Date(c("2024-01-07", "2024-01-14")),
#'   n = c(100, 120),
#'   report_date = as.Date(c("2024-01-31", "2024-02-29"))
#' )
#' waiting_list_stats <- wl_stats_hist(wl_hist, target_wait = 18)
#' }
#'
wl_stats_hist <- function(wl_hist,
                          target_wait = 4,
                          start_date = NULL,
                          end_date = NULL) {
  # Check we have report_date column
  if (!"report_date" %in% colnames(wl_hist)) {
    stop("Histogram must contain a 'report_date' column")
  }

  # Get unique report dates
  report_dates <- unique(wl_hist$report_date)

  # Check we have at least 2 dates for removal stats
  if (length(report_dates) < 2) {
    stop("Histogram must contain at least 2 report_date values to calculate statistics")
  }

  # Use most recent date for queue size and referral stats
  if (is.null(end_date)) {
    end_date <- max(report_dates, na.rm = TRUE)
  } else {
    end_date <- as.Date(end_date)
  }

  # Filter to most recent snapshot for queue and referral calculations
  wl_hist_latest <- wl_hist |>
    dplyr::filter(.data$report_date == end_date)

  # Calculate referral statistics from latest snapshot
  referral_stats <- wl_referral_stats_hist(wl_hist_latest)

  # Calculate queue size from latest snapshot
  q_size <- wl_queue_size_hist(wl_hist_latest)

  # Calculate removal statistics using all snapshots in date range
  removal_stats <- wl_removal_stats_hist(wl_hist, start_date, end_date)

  # load
  q_load <-
    calc_queue_load(
      referral_stats$demand_weekly,
      removal_stats$capacity_weekly
    )

  # load too big
  q_load_too_big <- (q_load >= 1.)

  # target queue size
  q_target <-
    calc_target_queue_size(referral_stats$demand_weekly, target_wait = target_wait, factor = 2.52)

  # queue too big
  q_too_big <- (q_size > 2 * q_target)

  # mean wait
  mean_wait_age <- wl_mean_wait_age_hist(wl_hist_latest)

  # target capacity
  if (!q_too_big) {
    target_cap <- calc_target_capacity(
      referral_stats$demand_weekly,
      target_wait,
      4,
      referral_stats$demand_cov,
      removal_stats$capacity_cov
    )
    # target_cap_weekly <- target_cap_daily * 7
  } else {
    target_cap <- NA
  }

  # relief capacity
  if (q_too_big) {
    relief_cap <-
      calc_relief_capacity(referral_stats$demand_weekly, q_size, q_target)
  } else {
    relief_cap <- NA
  }

  # pressure
  pressure <- calc_waiting_list_pressure(mean_wait_age, target_wait)

  waiting_stats <- data.frame(
    "mean_demand" = referral_stats$demand_weekly,
    "mean_capacity" = removal_stats$capacity_weekly,
    "load" = q_load,
    "load_too_big" = q_load_too_big,
    "count_demand" = referral_stats$demand_count,
    "queue_size" = q_size,
    "target_queue_size" = q_target,
    "queue_too_big" = q_too_big,
    "mean_wait_age" = mean_wait_age,
    "mean_wait" = mean_wait_age,
    "cv_arrival" = referral_stats$demand_cov,
    "cv_removal" = removal_stats$capacity_cov,
    "target_capacity" = target_cap,
    "relief_capacity" = relief_cap,
    "pressure" = pressure
  )

  return(waiting_stats)
}
