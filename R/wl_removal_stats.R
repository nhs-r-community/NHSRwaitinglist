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

wl_removal_stats <- function(waiting_list,
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

  removal_dates <- c(as.Date(start_date),waiting_list[,2],as.Date(end_date))
  removal_dates <- sort(removal_dates[!is.na(removal_dates)])

  queue_sizes <- wl_queue_size(waiting_list)
  zero_dates <- queue_sizes[which(queue_sizes[,2]==0),1]

  zeros_df <- data.frame("dates"=zero_dates,
                         "non_zero_queue"=rep(FALSE,length(zero_dates))
                         )
  removals_df <- data.frame("dates"=removal_dates,
                            "non_zero_queue"=rep(TRUE,length(removal_dates))
                            )
  removals_and_zeros <- rbind(zeros_df,removals_df)
  removals_and_zeros <- removals_and_zeros[order(removals_and_zeros[,1],
                                                 removals_and_zeros[,2]),
                                           ]
  rownames(removals_and_zeros) <- NULL
  removals_and_zeros$lag_dates <- dplyr::lag(removals_and_zeros$dates)
  removals_and_zeros$diff <- as.numeric(removals_and_zeros[,1]) - as.numeric(removals_and_zeros[,3])

  differences <- removals_and_zeros[which(removals_and_zeros[,2] == TRUE),4]
  mean_removal <- as.numeric(mean(differences,na.rm=TRUE))
  sd_removal <- sd(differences,na.rm=TRUE)
  cv_removal <- sd_removal/mean_removal
  num_removals <- length(differences)
  capacity <- 1/mean_removal
  capacity_weekly <- 7/mean_removal

removal_stats <- data.frame(
  "capacity.weekly" = capacity_weekly,
  "capcity.daily" = capacity,
  "capacity.cov" = cv_removal,
  "removal.count" = num_removals
)

  return (removal_stats)
}
