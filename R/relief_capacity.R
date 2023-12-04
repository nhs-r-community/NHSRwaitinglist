#' @title Title
#'
#' @description
#' A short description...
#'
#' @param demand
#' @param queue_size
#' @param target_queue_size
#' @param weeks_to_target
#'
#' @return
#' @export
#'
#' @examples
#'
#'
relief_capacity <- function(demand, queue_size, target_queue_size, weeks_to_target) {
  rel_cap <- demand + (queue_size  -  target_queue_size) / weeks_to_target
  return(rel_cap)
}
