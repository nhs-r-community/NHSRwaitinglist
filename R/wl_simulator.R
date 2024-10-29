#' @title Simple simulator to create a waiting list
#'
#' @description Creates a simulated waiting list comprising referral dates,
#' and removal dates
#'
#' @param start_date date. The start date for the simulation
#' @param end_date date. The end date for the simulation
#' @param demand numeric. Weekly demand (ie. typical referrals per week)
#' @param capacity numeric. Weekly capacity (ie. typical removals per week)
#' @param waiting_list integer. The number of patients on the waiting list
#'   contains the referral dates
#'
#' @return dataframe. A df of simulated referrals and removals
#'
#' @import dplyr
#' @export
#'
#' @examples
#'
#' over_capacity_simulation <-
#'   wl_simulator("2024-01-01", "2024-03-31", 100, 110)
#' under_capacity_simulation <-
#'   wl_simulator("2024-01-01", "2024-03-31", 100, 90)
#'
#' # TODO
#' # error messages (e.g. start_date > end_date)
wl_simulator <- function(
    start_date=NULL,
    end_date=NULL,
    demand=10,
    capacity=11,
    waiting_list = NULL,
    withdrawal_prob = NA,
    detailed_sim = FALSE) {

  # Fix Start and End Dates
  if (is.null(start_date)){
    start_date = Sys.Date()
  }
  if (is.null(end_date)){
    end_date = start_date + 31
  }
  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)
  number_of_days <- as.numeric(end_date) - as.numeric(start_date)

  total_demand <- demand * number_of_days / 7
  daily_capacity <- capacity / 7

  # allowing for fluctuations in predicted demand give a arrival list
  realized_demand <- stats::rpois(1, total_demand)
  referral <-
    sample(
      seq(as.Date(start_date), as.Date(end_date), by = "day"),
      realized_demand, replace = TRUE)

  referral <- referral[order(referral)]
  removal <- rep(as.Date(NA), length(referral))

  if (!detailed_sim){
    if (is.na(withdrawal_prob)){
      wl_simulated <- data.frame("Referral" = referral,
                                 "Removal" = removal)
    } else {
      withdrawal <- referral + rgeom(length(referral),prob = withdrawal_prob)+1
      withdrawal[withdrawal>end_date] <- NA
      wl_simulated <- data.frame("Referral" = referral,
                                 "Removal" = removal,
                                 "Withdrawal" = withdrawal)
    }

    if (!is.null(waiting_list)) {
      wl_simulated <- wl_join(waiting_list, wl_simulated)
    }
  }
  if(detailed_sim){
    if (is.na(withdrawal_prob)){
      withdrawal_prob <-0.1
    }
    withdrawal <- referral + rgeom(length(referral),prob = withdrawal_prob)+1
    withdrawal[withdrawal>end_date] <- NA
    wl_simulated <- sim_patients(length(referral),start_date)
    wl_simulated$Referral <- referral
    wl_simulated$Withdrawal <- withdrawal
  }

  # create an operating schedule
  schedule <-
    as.Date(
      as.numeric(start_date) +
        ceiling(seq(0, number_of_days - 1, 1 / daily_capacity)),
      origin = "1970-01-01")

  wl_simulated <- wl_schedule(wl_simulated, schedule)

  return(wl_simulated)
}
