#' @title F variation
#'
#' @description
#' Calculated the variation parameter F. This can be used with the target capacity calcultion
#'
#' F = ( capacity variance / capacity ) * ( demamd / capacity )^2
#'
#' @param variance_prodeures Numeric value of variance in the number of proceedures per week
#' @param demand Numeric value of rate of demand in same units as target wait - e.g. if target wait is weeks, then demand in units of patients/week.
#' @param capacity Numeric value of the number of patients that can be served (removals) from the waiting list each week.
#'
#' @return variance parameter F
#' @export
#'
#' @examples
#'
#' # If the demand is 30 capacity is 27 and the variance in capacity is 144
#' # F = (144/27) * (30/27)^2 = 6.58
#'
#' target_capacity(144,27,30)
#'

F_variation <- function(variance_prodeures, capacity, demand){
  F = variance_prodeures * ( demand**2 ) / (capacity**3)
  return(F)
}