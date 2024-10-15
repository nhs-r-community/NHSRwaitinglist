#' @title target_capacity_from_target_probability
#'
#' @description calculates a target capacity from a target probability#'
#'
#' @param demand dataframe. A df of referral dates and removals
#' @param target_prob numeric. The required waiting time
#' @param target_wait date. The start date to calculate from
#'
#' @return numeric
#' @export
#'
calc_target_capacity_from_target_probability <- function(demand,target_prob,target_wait){
  cap = Lambert((demand*target_wait/target_prob) * exp(demand*target_wait) ) / target_wait
  return(cap)
}