#' @title Average Waiting Time
#'
#' @description This calculates the target mean wait given the two inputs of
#'   target_wait and a numerical value for factor. The average wait is actually
#'   the target mean wait and is calculated as follows: target_wait / factor. If
#'   we want to have a chance between 1.8%-0.2% of making a waiting time target,
#'   then the average patient should have a waiting time between a quarter and a
#'   sixth of the target. Therefore: The mean wait should sit somewhere between
#'   target_wait/factor=6 < Average Waiting Time < target_wait/factor=4.
#'
#' @param target_wait Numeric value of the number of weeks that has been set as
#'   the target within which the patient should be seen.
#' @param factor  Numeric factor used in average wait calculation - to get a
#'   quarter of the target use factor=4 and one sixth of the target use factor =
#'   6 etc. Defaults to 4.
#'
#' @return Numeric value of target mean waiting time to achieve a given target
#'   wait.
#'
#' @export
#'
#' @examples
#' # If the target wait is 52 weeks then the target mean wait with a factor of 4
#' # would be 13 weeks and with a factor of 6 it would be 8.67 weeks.
#' average_wait(52, 4)
average_wait <- function(target_wait, factor = 4) {
  check_class(target_wait, factor)
  target_mean_wait <- target_wait / factor
  return(target_mean_wait)
}
