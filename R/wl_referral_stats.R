#' @title insert waiting list additions
#'
#' @description adds new referrals (removal date is set NA)

#'
#' @param waiting_list a data frame of referral dates and removals
#' @param additions a list of referral dates
#'
#' @return an updated waiting list
#' @export
#'
#' @examples
#' # referrals <- c.Date("2024-01-01","2024-01-04","2024-01-10","2024-01-16")
#' # removals <- c.Date("2024-01-08",NA,NA,NA)
#' # waiting_list <- data.frame("referral" = referrals ,"removal" = removals )
#' # additions <- c.Date("2024-01-03","2024-01-05","2024-01-18")
#' # wl_insert(waiting_list, additions)


# TODO : referral <- arrival
# debug and test
# simplify notation
# update params above

# arrival mean and variance

wl_referral_stats <- function(waiting_list,
                            start_date = NULL,
                            end_date = NULL){

  if ( !is.null(start_date) ) {
    start_date <- as.Date(start_date)
  } else {
    start_date <- min(waiting_list[,1])
  }
  if ( !is.null(end_date) ) {
    end_date <- as.Date(end_date)
  } else {
    end_date <- max(waiting_list[,1])
  }

  arrival_dates <- c(as.Date(start_date),
                     waiting_list[
                       which( start_date <= waiting_list[,1]
                              & waiting_list[,1] <= end_date
                       ),1
                     ],
                     as.Date(end_date))

  inter_arrival_times <- diff(arrival_dates,lags=-1)
  mean_arrival <- as.numeric(mean(inter_arrival_times))
  sd_arrival <- sd(inter_arrival_times)
  cv_arrival <- sd_arrival/mean_arrival
  num_arrivals <- length(inter_arrival_times)
  demand <- 1/mean_arrival
  demand_weekly <- 7*demand


  referral_stats <- data.frame(
                                "demand.weekly" = demand_weekly,
                                "demand.daily" = demand,
                                "demand.cov" = cv_arrival,
                                "demand.count" = num_arrivals
                              )

  return (referral_stats)
}
