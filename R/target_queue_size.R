#' @title Title
#'
#' @description
#' A short description...
#'
#' @param demand
#' @param target_wait
#' @param factor
#'
#' @return
#' @export
#'
#' @examples
#'
#'
target_queue_size <- function(demand, target_wait, factor = 4) {
  mean_wait <- average_wait(target_wait, factor)
  target_queue_length <- demand * mean_wait
  return(target_queue_length)
}
