#' @title Target Capacity
#'
#' @description
#' Calculates the target capacity to achieve a given target waiting time as a function of observed demand, target waiting time and a variability of demand parameter F.
#'
#' F defaults to 1.
#'
#' Target Capacity = Demand + 2 * ( 1 + 4 * F ) / Target Wait
#'
#' @param demand Numeric value of rate of demand in same units as target wait - e.g. if target wait is weeks, then demand in units of patients/week.
#' @param target_wait Numeric value of number of weeks that has been set as the target within which the patient should be seen.
#' @param F Holding value, needs definition of F adding.
#'
#' @return A numeric value of target capacity required to achieve a target waiting time.
#' @export
#'
#' @examples
#'
#' # If the target wait is 52 weeks, demand is 30 patients per week and F = 3 then
#' # Target capacity = 30 + 2*(1+4*3)/52 = 30.5 patients per week.
#'
#' target_capacity(30,52,3)
#'
target_capacity <- function(demand, target_wait, F = 1) {
  target_cap <- demand +  2 * ( 1 + 4 * F ) / target_wait
  return(target_cap)
}
