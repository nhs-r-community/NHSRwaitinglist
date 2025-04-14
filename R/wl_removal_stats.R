#' @title Calculate some stats about removals
#'
#' @description Calculate some stats about removals
#'
#' @param waiting_list data.frame. A df of referral dates and removals
#' @param start_date date. The start date to calculate from
#' @param end_date date. The end date to calculate to
#' @param referral_index int. Index of the referral column in waiting_list.
#' @param removal_index int. Index of the removal column in waiting_list.
#'
#' @return A data.frame with the following summary statistics on
#'   removals/capacity:
#'
#' \describe{
#'   \item{capacity_weekly}{Numeric. Mean number of removals from the waiting
#'     list per week.}
#'   \item{capacity_daily}{Numeric. Mean number of removals from the waiting
#'     list per day.}
#'   \item{capacity_cov}{Numeric. Coefficient of variation in the time between
#'     removals from the waiting list.}
#'   \item{removal_count}{Numeric. Total number of removals from the waiting
#'     list over the full time period.}
#' }
#'
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' removal_stats <- wl_removal_stats(waiting_list)
#'
wl_removal_stats <- function(waiting_list,
                             start_date = NULL,
                             end_date = NULL,
                             referral_index = 1,
                             removal_index = 2) {

  if (nrow(waiting_list) == 0) {
    stop("Waiting list contains no rows")
  }

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

  removal_dates <- waiting_list[, removal_index]
  removal_dates <- sort(removal_dates[!is.na(removal_dates)])

  queue_sizes <- wl_queue_size(waiting_list)
  zero_dates <- queue_sizes[which(queue_sizes[, 2] == 0), 1]

  zeros_df <- data.frame(
    "dates" = zero_dates,
    "non_zero_queue" = rep(FALSE, length(zero_dates))
  )
  removals_df <- data.frame(
    "dates" = removal_dates,
    "non_zero_queue" = rep(TRUE, length(removal_dates))
  )
  removals_and_zeros <- rbind(zeros_df, removals_df)
  removals_and_zeros <- removals_and_zeros[order(
    removals_and_zeros[, 1],
    removals_and_zeros[, 2]
  ), ]

  rownames(removals_and_zeros) <- NULL
  removals_and_zeros$lag_dates <- dplyr::lag(removals_and_zeros$dates)
  if (is.na(removals_and_zeros[1, ]$lag_dates)) {
    removals_and_zeros[1, ]$lag_dates <- start_date
  }

  removals_and_zeros$diff <-
    as.numeric(removals_and_zeros[, 1]) - as.numeric(removals_and_zeros[, 3])
  differences <- removals_and_zeros[which(removals_and_zeros[, 2] == TRUE), 4]
  mean_removal <- as.numeric(mean(differences, na.rm = TRUE))
  sd_removal <- if (length(differences) <= 1) {
    0.
  } else {
    stats::sd(differences, na.rm = TRUE)
  }
  cv_removal <- sd_removal / mean_removal
  num_removals <- length(differences)
  capacity <- 1 / mean_removal
  capacity_weekly <- 7 / mean_removal

  removal_stats <- data.frame(
    "capacity_weekly" = capacity_weekly,
    "capacity_daily" = capacity,
    "capacity_cov" = cv_removal,
    "removal_count" = num_removals
  )

  return(removal_stats)
}
