#' @title Waiting List Statistics
#'
#' @name wl_stats
#'
#' @description A summary of all the key statistics associated with a waiting list
#'
#' @param waiting_list dataframe consisting addition and removal dates
#' @param target_wait the required waiting time
#'
#' @return summary of key waiting list statistics
#' @export
#'
#' @examples
#'
#' TO DO!!

#' MAKE CONSISTENT NOTATION
#' default start and end date if empty

library(tidyverse)

wl_stats <- function(waiting_list, target_wait, start_date, end_date) {
  end_date <- as.Date(end_date)
  start_date <- as.Date(start_date)
  arrival_dates <- c(as.Date(start_date),waiting_list[,1],as.Date(end_date))
  inter_arrival_times <- diff(arrival_dates,lags=-1)

  # arrival mean and variance
  mean_arrival <- as.numeric(mean(inter_arrival_times))
  sd_arrival <- sd(inter_arrival_times)
  cv_arrival <- sd_arrival/mean_arrival

  # removal mean and variance
  removal_dates <- c(as.Date(start_date),waiting_list[,2],as.Date(end_date))
  removal_dates <- sort(removal_dates[!is.na(removal_dates)])

  queue_sizes <- wl_queue_size(waiting_list)
  zero_dates <- queue_sizes[which(queue_sizes[,2]==0),1]
  removals_zeros <- sort(c(zero_dates,removal_dates))
  removals_zeros <- removals_zeros[!duplicated(removals_zeros)]
  rows <- data.frame(removals_zeros,lag(removals_zeros))
  rows$diff <- rows[,1]-rows[,2]
  differences <- rows[which(rows[,1] %in% removal_dates),3]
  mean_removal <- as.numeric(mean(differences,na.rm=TRUE))
  sd_removal <- sd(differences,na.rm=TRUE)
  cv_removal <- sd_removal/mean_removal
  demand <- 1/mean_removal

  # laod
  q_load <- queue_load(mean_arrival,mean_removal)

  # load too big
  q_load_too_big = (q_load >= 1.)

  # final queue_size
  q_size <- tail(queue_sizes,n=1)[,2]

  # target queue size
  q_target <- target_queue_size(mean_arrival,target_wait)

  # queue too big
  q_too_big <- ( q_size > 2*q_target )

  # mean wait
  waiting_patients = waiting_list[which( (waiting_list[,2] > end_date | is.na(waiting_list[,2]) & waiting_list[,1] <= end_date )) ,]
  wait_times <- as.numeric(end_date) - as.numeric(waiting_patients[,1])
  mean_wait <- mean(wait_times)

  # target capacity
  target_cap <- target_capacity(demand, target_wait, 4, cv_arrival, cv_removal)

  # pressure
  pressure <- waiting_list_pressure(mean_wait, target_wait)

  waiting_stats <- data.frame(
    "mean_arrival" = mean_arrival,
    "mean_removal" = mean_removal,
    "load" = q_load,
    "load too big" = q_load_too_big,
    "queue_size" = q_size,
    "target_queue_size" = q_target,
    "queue too big" = q_too_big,
    "mean_wait" = mean_wait,
    "cv_arrival" = cv_arrival,
    "cv_removal" =  cv_removal,
    "target capacity" = target_cap,
    "pressure" =  mean_wait * 4 / target_wait
  )

  return (waiting_stats)
}
