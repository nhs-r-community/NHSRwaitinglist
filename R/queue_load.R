#' @title Title
#'
#' @description
#' A short description...
#'
#' @param demand
#' @param capacity
#'
#' @return
#' @export
#'
#' @examples
#'
#'
queue_load <- function(demand, capacity) {
  load <- demand / capacity
  return (load)
}
