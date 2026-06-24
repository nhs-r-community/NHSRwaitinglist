#' Create a simulated histogram in the format used by the package
#'
#' @param num_intervals integer. Number of time intervals to create.
#' @param end_date Date. The date that the waiting list should end.
#' @param rate numeric. The rate defining the exponential.
#' @param queue_size numeric. Total queue size used to scale the histogram.
#' @param time_interval Character or numeric. Controls the spacing between rows.
#' @param random logical. If TRUE, draws interval counts from an exponential process.
#'
#' @return A data.frame of a simulated waiting list in histogram format.
#'
#' @export
#'
sim_exponential_histogram <- function(
  num_intervals = 52,
  end_date = Sys.Date(),
  rate = 0.1,
  queue_size = 1000,
  time_interval = "weeks",
  random = FALSE
) {
  # Adjust end_date back if it's today's date.
  if (as.Date(end_date) == Sys.Date()) {
    if (is.numeric(time_interval)) {
      end_date <- Sys.Date() - time_interval
    } else if (tolower(time_interval) == "months") {
      end_date <- seq.Date(Sys.Date(), by = "-1 month", length.out = 2)[2]
    } else {
      end_date <- Sys.Date() - 7
    }
  }

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
    n_values_raw <- ceiling(stats::rexp(queue_size, rate = rate))
    n_values <- tabulate(n_values_raw + 1, nbins = num_intervals)
  } else {
    # calculate values using the exponential function
    n_values <- ceiling(queue_size * exp(-rate * seq(0, num_intervals - 1)) * (1 - exp(-rate)))
  }

  # Ensure n_values length matches dates
  n_values <- utils::head(n_values, length(dates))

  # Create the data frame
  df <- data.frame(
    arrival_since = dates,
    n = n_values
  )
  df <- format_histogram(df, end_date = end_date)

  return(df)
}
