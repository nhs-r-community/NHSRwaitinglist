#' @title Calculate Target Capacity
#'
#' @description Calculates the target capacity to achieve a given target waiting
#' time as a function of observed demand, target waiting time and a variability
#' coefficient F.
#'
#' Target Capacity = Demand + 2 * ( 1 + 4 * F ) / Target Wait F defaults to 1.
#'
#' @param demand Numeric value of rate of demand in same units as target wait -
#'   e.g. if target wait is weeks, then demand in units of patients/week.
#' @param target_wait Numeric value of number of weeks that has been set as the
#'   target within which the patient should be seen.
#' @param F Variability coefficient, F = V/C * (D/C)^2 where C is the current
#'   number of operations per week; V is the current variance in the number of
#'   operations per week; D is the observed demand. Defaults to 1.
#'
#' @return A numeric value of target capacity required to achieve a target
#'   waiting time.
#'
#' @export
#'
#' @examples
#'
#' # If the target wait is 52 weeks, demand is 30 patients per week and F = 3
#' # then Target capacity = 30 + 2 * (1 + 4 * 3)/52 = 30.5 patients per week.
#' target_capacity(30,52,3)
target_capacity <- function(demand, target_wait, F = 1) {
  check_class(demand, target_wait, F)
  target_cap <- demand +  2 * (1 + 4 * F) / target_wait
  return(target_cap)
}
