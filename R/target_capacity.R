#' @title Target Capacity
#'
#' @description
#' Calculates the target capacity to achieve a given target waiting time as a 
#' function of observed demand, target waiting time and a variability of demand 
#' parameter F.
#' 
#' F defaults to 1.
#' 
#' Target Capacity = Demand + 2 * ( 1 + 4 * F ) / Target Wait
#'
#' @param demand
#' @param target_wait
#'
#' @return target capacity to achieve a target waiting time
#' @export
#'
#' @examples
#' 
#' If the target wait is 52 weeks, demand is 30 patients per week and F = 3 then
#' Target capacity = 30 + 2*(1+4*3)/52 = 30.5 patients per week.
#' 
#' target_capacity(30,52,3)
#'
target_capacity <- function(demand, target_wait, F = 1) {
  target_cap <- demand +  2 * ( 1 + 4 * F ) / target_wait
  return(target_cap)
}
