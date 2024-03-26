#' @title Queue size calculator
#'
#' @description Calculateds queue sizes from a waiting list

#'
#' @param waiting_list dataframe consisting addition and removal dates
#' @param start_date start of calculation period
#' @param end_date end of calculation period
#'
#' @return a list of dates and queue sizes
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01","2024-01-04","2024-01-10","2024-01-16")
#' removals <- c.Date("2024-01-08",NA,NA,NA)
#' waiting_list <- data.frame("referral" = referrals ,"removal" = removals )
#' wl_queue_size(waiting_list)


wl_queue_size <- function(waiting_list, start_date = NULL, end_date = NULL) {
  wl <- waiting_list

  if ( is.null(start_date) ) {
    start_date = min(wl[,1])
  }
  if ( is.null(end_date) ) {
    end_date = max(wl[,1])
  }

  wl[wl$referral<start_date,1] <-start_date
  arrival_counts <- data.frame(table(wl[,1]))

  dates <- seq(as.Date(start_date), as.Date(end_date), by="day")
  queues <- data.frame(dates,rep(0,length(dates)))

  queues[which(queues[,1] %in% arrival_counts[,1]),2] <- arrival_counts[,2]
  queues$cummulative_arrivals <- cumsum(queues[,2])

  departure_counts <- data.frame(table(wl[ which( (start_date <= wl[,2]) & (wl[,2] <= end_date)),2]))
  queues$departures <- rep(0,length(dates))
  queues[which(queues[,1] %in% departure_counts[,1]),4] <- departure_counts[,2]
  queues$cummulative_departures <- cumsum(queues[,4])

  queues$queue_size <- queues$cummulative_arrivals - queues$cummulative_departures

  return (queues[,c(1,6)])

}