#' @title Simple simulator to create a waiting list
#'
#' @description Creates a simulated waiting list comprising referral dates, and removal dates
#'
#' @param start_date date. The start date for the simulation
#' @param end_date date. The end date for the simulation
#' @param demand numeric. Weekly demand (ie. typical referrals per week)
#' @param capacity numeric. Weekly capacity (ie. typical removals per week)
#' @param waiting_list integer. The number of patients on the waiting list
#' @param referral_index integer. The column number in the waiting_list which contains the referral dates
#'
#' @return dataframe. A df of simulated referrals and removals
#' @export
#'
#' @examples
#'
#' over_capacity_simulation <- wl_simulator("2024-01-01", "2024-03-31", 100, 110)
#' under_capacity_simulation <- wl_simulator("2024-01-01", "2024-03-31", 100, 90)
#'
#' #TODO 
#' # error messages (e.g. start_date > end_date)

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
