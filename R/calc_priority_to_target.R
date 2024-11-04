#' @title Calculates target days from priority code
#'
#' @description Internal Helper function number of days from prioirty code
#'
#' @param priority number 1,2,3 or 4
#'
#' @return number of days
#'

calc_priority_to_target <- function(priority){
  if (priority == 1){
    return(7)
  } else if (priority == 2) {
    return(28)
  } else if (priority == 3) {
    return(84)
  } else {
    return(365)
  }
}