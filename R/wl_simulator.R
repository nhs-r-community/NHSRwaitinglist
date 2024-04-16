#' @title Simple Simulator
#'
#' @description Simulators

#'
#' @param start_date Start date
#' @param end_date End date
#' @param demand Demand
#' @param capacity Capacity
#'
#' @return updated_list a new waiting list
#' @export
#'
#' @examples
#'
#' #TODO error messages (e.g. start_date > end_date)

wl_simulator <- function(start_date, end_date, demand, capacity, waiting_list=NULL, referral_index = 1) {
  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)
  number_of_days <- as.numeric(end_date)-as.numeric(start_date)

  total_demand <- demand*number_of_days/7
  daily_capacity <- capacity/7

  # allowing for fluctuations in predicted demand give a arrival list
  realized_demand <- rpois(1,total_demand)
  referral <- sample(seq(as.Date(start_date), as.Date(end_date), by="day"), realized_demand, replace=TRUE)

  referral <- referral[order(referral)]
  removal <- rep(as.Date(NA), length(referral))
  wl_simulated <- data.frame(referral,removal)

  if (!is.null(waiting_list) ){
    wl_simulated <- wl_join(waiting_list,wl_simulated,referral_index)
  }

  # create an operating schedule
  schedule <- as.Date(as.numeric(start_date)+ceiling(seq(0,number_of_days-1,1/daily_capacity)),origin="1970-01-01")

  wl_simulated <- wl_schedule(wl_simulated,schedule)

  return (wl_simulated )
}
