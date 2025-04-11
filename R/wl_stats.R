#' @title Calculate some stats about the waiting list
#'
#' @description A summary of all the key stats associated with a waiting list
#'
#' @param waiting_list data.frame. A df of referral dates and removals
#' @param target_wait numeric. The required waiting time
#' @param start_date date. The start date to calculate from
#' @param end_date date. The end date to calculate to
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
#'   \item{load_too_big}{Logical. Whether the load is greater than or equal to 1,
#'     indicating whether the waiting list is unstable and expected to grow.}
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
#'   \item{mean_wait}{Numeric. Mean waiting time in weeks.}
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
#'     \code{2 × mean_wait / target_wait}. Values greater than 1 suggest the
#'     system is unlikely to meet its waiting time targets.}
#' }
#'
#' @export
#'
#'
#' @examples
#'
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' waiting_list_stats <- wl_stats(waiting_list)
#'
wl_stats <- function(waiting_list,
                     target_wait = 4,
                     start_date = NULL,
                     end_date = NULL) {

  # Error handle
  if (!methods::is(waiting_list, "data.frame")) {
    stop("waiting list should be supplied as a data.frame")
  }


  if (nrow(waiting_list) == 0) {
    stop("No data rows in waiting list")
  }

  if (missing(waiting_list)) {
    stop("No waiting list supplied")
  }


  # get indices and set target wait if possible and get dates
  referral_index <- calc_index(waiting_list, type = "referral")
  removal_index <- calc_index(waiting_list, type = "removal")

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


  referral_stats <- wl_referral_stats(
    waiting_list,
    start_date,
    end_date,
    referral_index
  )
  queue_sizes <- wl_queue_size(
    waiting_list,
    start_date,
    end_date,
    referral_index,
    removal_index
  )
  removal_stats <- wl_removal_stats(
    waiting_list,
    start_date,
    end_date,
    referral_index,
    removal_index
  )

  # load
  q_load <-
    calc_queue_load(referral_stats$demand_weekly
                    , removal_stats$capacity_weekly)

  # load too big
  q_load_too_big <- (q_load >= 1.)

  # final queue_size
  q_size <- utils::tail(queue_sizes, n = 1)[, 2]

  # target queue size
  q_target <-
    calc_target_queue_size(referral_stats$demand_weekly, target_wait)

  # queue too big
  q_too_big <- (q_size > 2 * q_target)

  # mean wait
  waiting_patients <-
    waiting_list[which((waiting_list[, removal_index] >
                          end_date | is.na(waiting_list[, removal_index]) &
                          waiting_list[, referral_index] <= end_date)), ]
  wait_times <-
    as.numeric(end_date) - as.numeric(waiting_patients[, referral_index])
  mean_wait <- mean(wait_times)

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
  pressure <- calc_waiting_list_pressure(mean_wait, target_wait)

  waiting_stats <- data.frame(
    "mean_demand" = referral_stats$demand_weekly,
    "mean_capacity" = removal_stats$capacity_weekly,
    "load" = q_load,
    "load_too_big" = q_load_too_big,
    "count_demand" = referral_stats$demand_count,
    "queue_size" = q_size,
    "target_queue_size" = q_target,
    "queue_too_big" = q_too_big,
    "mean_wait" = mean_wait,
    "cv_arrival" = referral_stats$demand_cov,
    "cv_removal" = removal_stats$capacity_cov,
    "target_capacity" = target_cap,
    "relief_capacity" = relief_cap,
    "pressure" = pressure
  )

  return(waiting_stats)

}
