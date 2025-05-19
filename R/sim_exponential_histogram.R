#' Create a weekly histogram in the format used by the package
#'
#' @param weeks integer. Number of weeks of waiting list to create
#' @param end_date data. The date that the waiting list should end
#' @param rate numeric. The rate defining the exponential
#'
#' @returns a dataframe of a simulated waiting list in histogram format
#'
#' @export
#'
sim_exponential_histogram <- function(num_intervals = 52, 
  end_date = Sys.Date(), 
  rate = 0.1, 
  queue_size = 1000,
  time_interval = "weeks",
  random = FALSE
  ){

  # Determine the sequence by time_interval
  if (is.numeric(time_interval)) {
  # Numeric: treat as days
  dates <- seq.Date(end_date, by = paste0("-", time_interval, " days"), length.out = num_intervals)
  } else if (tolower(time_interval) == "months") {
  dates <- seq.Date(end_date, by = "-1 month", length.out = num_intervals)
  } else {
  # Default to weeks
  dates <- seq.Date(end_date, by = "-1 week", length.out = num_intervals)
  }

  if (random) {
  # generate exponential values for each date
  n_values <- rexp(queue_size, rate = rate) |>
    round() |>
    sort(decreasing = TRUE)
  } else {
  # calculate values using the exponential function
  n_values <- round(queue_size * exp(-rate * seq(0, num_intervals - 1)))
  }

  # Ensure n_values length matches dates
  n_values <- head(n_values, length(dates))

  # Create the data frame
  df <- data.frame(
    arrival_since = dates,
    n = n_values
  )

  return(df)
}