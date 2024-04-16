#' @title Target Capacity
#'
#' @description
#' Applies Kingman/Marchal's Formula :
#'
#'      capacity = demand + (cvd**2 + cvc**2) / waiting_time
#'
#'  where
#'      cvd           = coefficent of variation of time between arrivals
#'      cvd           = coefficient of variation of sevice times
#'      waiting_time  = target_wait / factor
#'
#' @param demand Numeric value of rate of demand in same units as target wait - e.g. if target wait is weeks, then demand in units of patients/week.
#' @param target_wait Numeric value of number of weeks that has been set as the target within which the patient should be seen.
#' @param factor the amount we divide the target by in the waiting list e.g. if target is 52 weeks the mean wait should be 13 for a factor of 4
#' @param cv_demand coefficient of variation of time between arrivals
#' @param cv_capacity coefficient of variation between removals due to operations completed
#'
#' @return A numeric value of target capacity required to achieve a target waiting time.
#' @export
#'
#' @examples
#'
#' demand = 4 # weeks
#' target = 52 # weeks
#'
#' target_capacity(demand, target_wait) # number of operations per week to have mean wait of 52/4
#'
#'
#' TODO:
#' Include a couple of standard deviations for errors in the mean demand

target_capacity <- function(demand, target_wait, factor = 4, cv_demand = 1, cv_capacity = 1) {
    check_class(demand, target_wait, factor, cv_demand, cv_capacity)
    target_cap <- demand + ( (cv_demand**2 + cv_capacity**2) / 2 ) * ( factor / target_wait )
    return (target_cap)
  }
