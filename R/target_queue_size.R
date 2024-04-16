#' @title Target Queue Size
#'
#' @description
#' Uses Little's Law to calculate the target queue size to achieve a target waiting time as a function of observed demand, target wait and a variability factor used in the target mean waiting time calculation.
#'
#' Target Queue Size = Demand * Target Wait / 4.
#'
#' The average wait should sit somewhere between
#' target_wait/factor=6 < Average Waiting Time < target_wait/factor=4
#' The factor defaults to 4.
#'
#' Only applicable when Capacity > Demand.
#'
#' @param demand Numeric value of rate of demand in same units as target wait - e.g. if target wait is weeks, then demand in units of patients/week.
#' @param target_wait Numeric value of number of weeks that has been set as the target within which the patient should be seen.
#' @param factor Numeric factor used in average wait calculation - to get a quarter of the target use factor=4 and one sixth of the target use factor = 6 etc. Defaults to 4.
#'
#' @return Numeric target queue length.
#' @export
#'
#'
#' @examples
#' # If demand  is 30 patients per week and the target wait is 52 weeks, then the
#' # Target queue size = 30 * 52/4 = 390 patients.
#'
#' target_queue_size(30, 52, 4)
#'
target_queue_size <- function(demand, target_wait, factor = 4) {
  check_class(demand, target_wait, factor)
  mean_wait <- average_wait(target_wait, factor)
  target_queue_length <- demand * mean_wait
  return(target_queue_length)
}
