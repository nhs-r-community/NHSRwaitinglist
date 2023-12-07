#' @title Calculate the queue load
#'
#' @description
#' The queue load is the number of arrivals that occur for every patient leaving the queue (given that the
#' waiting list did not empty).
#' It could also be described as the rate of service at the queue.
#' The queue load is calculated by dividing the demand by the capacity:
#' queue_load = demand / capacity
#'
#' @param demand The number of patients referred per week for a procedure.
#' @param capacity The number of patients that can be served (removals) from the waiting list each week.
#'
#' @return load which is the ratio between demand and capacity
#' @export
#'
#' @examples if 30 patients are added to the waiting list each week (demand) and 27 removed (capacity)
#' this results in a queue load of 1.11 (30/27)
#' queue_load(30,27)
#'
#'
queue_load <- function(demand, capacity) {
  load <- demand / capacity
  return (load)
}