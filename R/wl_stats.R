


wl_stats <- function(waiting_list, start_date, end_date) {
  arrival_dates <- c(as.Date(start_date),waiting_list[,1],as.Date(end_date))
  inter_arrival_times <- diff(dates,lags=-1)
  mean_arrival <- mean(inter_arrival_times)
  sd_arrival <- sd(inter_arrival_times)
}

