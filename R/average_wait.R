#' @title Title
#'
#' @description
#' A short description...
#'
#' @param target_wait
#' @param factor
#'
#' @return
#' @export
#'
#' @examples
#'
#'
average_wait <- function(target_wait, factor = 4) {
  target_mean_wait <- target_wait / factor
  return(target_mean_wait)
}
