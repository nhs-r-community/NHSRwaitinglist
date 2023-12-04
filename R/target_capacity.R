#' @title Title
#'
#' @description
#' A short description...
#'
#' @param demand
#' @param mean_wait
#'
#' @return
#' @export
#'
#' @examples
#'
#'
target_capacity <- function(demand, mean_wait, F = 1) {
  target_cap <- demand +  2 * ( 1 + 4 * F ) / mean_wait
  return(target_cap)
}
