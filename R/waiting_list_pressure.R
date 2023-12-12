#' @title Calculate the waiting list pressure
#'
#' @description For a waiting list with target waiting time, the pressure on the waiting list is twice
#'  the mean delay divided by the waiting list target.
#'  The pressure of any given waiting list should be less than 1.
#'  If the pressure is greater than 1 then the waiting list is most likely going to miss its target.
#'  The waiting list pressure is calculated as follows:
#'  pressure = 2 x mean_wait / target_wait
#'
#' @param target_mean_wait Numeric value of target mean waiting time to achieve a given target wait
#' @param target_wait Numeric value of the number of weeks that has been set as the target within which the patient should be seen
#'
#' @return Numeric value of wait_pressure which is the waiting list pressure
#' @export
#'
#' @examples
#' waiting_list_pressure(63,52)
#'
waiting_list_pressure <- function(target_mean_wait, target_wait) {
  wait_pressure <- 2 * target_mean_wait / target_wait
  return(wait_pressure)
}
