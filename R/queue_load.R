#' @title Queue Load
#'
#' @description
#' Calculates the queue load. The queue load is the number of arrivals that occur for every patient leaving the queue (given that the
#' waiting list did not empty).
#' It could also be described as the rate of service at the queue.
#' The queue load is calculated by dividing the demand by the capacity:
#' queue_load = demand / capacity
#'
#' @param demand Numeric value of rate of demand in same units as target wait - e.g. if target wait is weeks, then demand in units of patients/week.
#' @param capacity Numeric value of the number of patients that can be served (removals) from the waiting list each week.
#'
#' @return Numeric value of load which is the ratio between demand and capacity
#' @export
#'
#' @examples
#' # If 30 patients are added to the waiting list each week (demand) and 27 removed (capacity)
#' # this results in a queue load of 1.11 (30/27)
#' queue_load(30,27)
#'
#'
queue_load <- function(demand, capacity) {

  check_class(demand, capacity)
  check_lengths_match(demand, capacity)

  load <- demand / capacity

  return(load)

}