#' @title Title
#'
#' @description
#' A short description...
#'
#' @param mean_wait
#' @param target_wait
#'
#' @return
#' @export
#'
#' @examples
#'
#'
waiting_list_pressure <- function(mean_wait, target_wait) {
  wait_pressure <- 2 * mean_wait / target_wait
  return(wait_pressure)
}
