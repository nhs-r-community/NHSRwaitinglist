#' @title Target Queue Size
#'
#' @description
#' Uses Little's Law to calculate the target queue size to achieve a target mean 
#' waiting time as a function of observed demand,  target wait and a factor used 
#' in the target mean waiting time calculation.
#' 
#' Target Queue Size = Demand * Target Wait / 4.
#'
#' The average wait should sit somewhere between 
#' target_wait/factor=6 < Average Waiting Time < target_wait/factor=4
#' The factor defaults to 4.
#' 
#' Only applicable when Capacity > Demand.
#'
#' @param demand
#' @param target_wait
#' @param factor
#'
#' @return target queue length
#' @export
#'
#' @examples
#' If demand  is 30 patients per week and the target wait is 52 weeks, then the 
#' Target queue size = 30 * 52/4 = 390 patients.
#'
#' target_queue_size(30,52,4)
#' 
target_queue_size <- function(demand, target_wait, factor = 4) {
  mean_wait <- average_wait(target_wait, factor)
  target_queue_length <- demand * mean_wait
  return(target_queue_length)
}
