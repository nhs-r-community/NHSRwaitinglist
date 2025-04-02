#' @title Calculates target days from priority code
#'
#' @description Internal Helper function number of days from priority code
#'
#' @param priority number 1,2,3 or 4
#'
#' @return number of days
#'
#'
#' @noRd

calc_priority_to_target <- function(priority) {
  if (priority == 1) {
    7
  } else if (priority == 2) {
    28
  } else if (priority == 3) {
    84
  } else {
    365
  }
}
