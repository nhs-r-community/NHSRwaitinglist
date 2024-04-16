#' @title Relief Capacity
#'
#' @description
#' Calculates required relief capacity to achieve target queue size in a given period of time as a function of demand, queue size, target queue size and time period.
#'
#' Relief Capacity is required if Queue Size > 2 * Target Queue Size.
#'
#' Relief Capacity = Current Demand + (Queue Size - Target Queue Size)/Time Steps
#'
#' WARNING!: make sure units match.
#' I.e. if demand is measured per week then time_to_target should be weeks
#' or if demand is per day then time_to_target is per day
#'
#' @param demand Numeric value of rate of demand in same units as target wait - e.g. if target wait is weeks, then demand in units of patients/week.
#' @param queue_size Numeric value of  current number of patients in queue.
#' @param target_queue_size Numeric value of desired number of patients in queue.
#' @param time_to_target Numeric value of desired number of time-steps to reach the target queue size by.
#'
#' @return A numeric value of the required rate of capacity to achieve a target queue size in a given period of time.
#' @export
#'
#' @examples
#' # If demand is 30 patients per week, the current queue size is 1200 and the
#' # target is to achieve a queue size of 390 in 26 weeks, then
#'
#' # Relief Capacity = 30 + (1200 - 390)/26 = 61.15 patients per week.
#'
#' relief_capacity(30, 1200, 390, 26)
#'

relief_capacity <- function(demand, queue_size, target_queue_size, time_to_target=26) {
  check_class(demand, queue_size, target_queue_size, time_to_target)
  rel_cap <- demand + (queue_size  -  target_queue_size) / time_to_target
  return(rel_cap)
}
