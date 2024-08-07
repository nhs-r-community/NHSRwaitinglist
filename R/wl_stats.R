#' @title Calculate some stats about the waiting list
#'
#' @description A summary of all the key stats associated with a waiting list
#'
#' @param waiting_list dataframe. A df of referral dates and removals
#' @param target_wait numeric. The required waiting time
#' @param start_date date. The start date to calculate from
#' @param end_date date. The end date to calculate to
#'
#' @return dataframe. A df of important waiting list statistics
#' @export
#'
#' @examples
#'
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' waiting_list_stats <- wl_stats(waiting_list)
#'
#' # TO DO!!
#' # Check target_capacity weekly daily
#' # Error if dates are in the wrong order
#' # Calculate the number of missed operations
#' # Start date and end date calculations not working well
#' #
#' # MAKE CONSISTENT NOTATION
#' # default start and end date if empty
#' # make units of output weekly operations not daily
#' # mean removal too big
#' # Z score in capacity calculations
#' # mean demand and mean capacity not interrarraival and departures plesae.
wl_stats <- function(waiting_list,
                     target_wait = 4,
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

  # arrival mean and variance
  # arrival_dates <- c(as.Date(start_date),
  #                    waiting_list[
  #                                  which( start_date <= waiting_list[,1]
  #                                         & waiting_list[,1] <= end_date
  #                                         ),1
  #                                  ],
  #                    as.Date(end_date))
  #
  # inter_arrival_times <- diff(arrival_dates,lags=-1)
  # mean_arrival <- as.numeric(mean(inter_arrival_times))
  # sd_arrival <- sd(inter_arrival_times)
  # cv_arrival <- sd_arrival/mean_arrival
  # num_arrivals <- length(inter_arrival_times)
  # demand <- 1/mean_arrival
  # demand_weekly <- 7*demand

  referral_stats <- wl_referral_stats(waiting_list, start_date, end_date)

  # # removal mean and variance
  # removal_dates <- c(as.Date(start_date),waiting_list[,2],as.Date(end_date))
  # removal_dates <- sort(removal_dates[!is.na(removal_dates)])
  #
  queue_sizes <- wl_queue_size(waiting_list)
  # zero_dates <- queue_sizes[which(queue_sizes[,2]==0),1]
  #
  # zeros_df <- data.frame("dates"=zero_dates,
  #                        "non_zero_queue"=rep(FALSE,length(zero_dates))
  #                        )
  # removals_df <- data.frame("dates"=removal_dates,
  #                           "non_zero_queue"=rep(TRUE,length(removal_dates))
  #                           )
  # removals_and_zeros <- rbind(zeros_df,removals_df)
  # removals_and_zeros <- removals_and_zeros[order(removals_and_zeros[,1],
  #                                                removals_and_zeros[,2]),
  #                                          ]
  # rownames(removals_and_zeros) <- NULL
  # removals_and_zeros$lag_dates <- dplyr::lag(removals_and_zeros$dates)
  # removals_and_zeros$diff <-
  #   as.numeric(removals_and_zeros[,1]) - as.numeric(removals_and_zeros[,3])
  #
  # differences <- removals_and_zeros[which(removals_and_zeros[,2] == TRUE),4]
  # mean_removal <- as.numeric(mean(differences,na.rm=TRUE))
  # sd_removal <- sd(differences,na.rm=TRUE)
  # cv_removal <- sd_removal/mean_removal
  # num_removals <- length(differences)
  # capacity <- 1/mean_removal
  # capacity_weekly <- 7/mean_removal


  removal_stats <- wl_removal_stats(waiting_list, start_date, end_date)

  # load
  q_load <-
    calc_queue_load(referral_stats$demand.weekly, removal_stats$capacity.weekly)

  # load too big
  q_load_too_big <- (q_load >= 1.)

  # final queue_size
  q_size <- utils::tail(queue_sizes, n = 1)[, 2]

  # target queue size
  q_target <- calc_target_queue_size(referral_stats$demand.weekly, target_wait)

  # queue too big
  q_too_big <- (q_size > 2 * q_target)

  # mean wait
  waiting_patients <-
    waiting_list[which((waiting_list[, 2] > end_date |
                          is.na(waiting_list[, 2]) &
                            waiting_list[, 1] <= end_date)), ]
  wait_times <- as.numeric(end_date) - as.numeric(waiting_patients[, 1])
  mean_wait <- mean(wait_times)

  # target capacity
  if (!q_too_big) {
    target_cap <- calc_target_capacity(
                                       referral_stats$demand.weekly,
                                       target_wait,
                                       4,
                                       referral_stats$demand.cov,
                                       removal_stats$capacity.cov)
    # target_cap_weekly <- target_cap_daily * 7
  } else {
    target_cap <- NA
  }

  # relief capacity
  if (q_too_big) {
    relief_cap <-
      calc_relief_capacity(referral_stats$demand.weekly, q_size, q_target)
  } else {
    relief_cap <- NA
  }

  # pressure
  # pressure <- calc_waiting_list_pressure(mean_wait, target_wait)
  # TODO: talk to Neil about using *2 (in this function),
  # or *4 in the formula below

  waiting_stats <- data.frame(
    "mean.demand" = referral_stats$demand.weekly,
    "mean.capacity" = removal_stats$capacity.weekly,
    "load" = q_load,
    "load too big" = q_load_too_big,
    "queue_size" = q_size,
    "target_queue_size" = q_target,
    "queue too big" = q_too_big,
    "mean_wait" = mean_wait,
    "cv_arrival" = referral_stats$demand.cov,
    "cv_removal" = removal_stats$capacity.cov,
    "target capacity" = target_cap,
    "relief capacity" = relief_cap,
    "pressure" = mean_wait * 4 / target_wait
  )

  return(waiting_stats)
}
