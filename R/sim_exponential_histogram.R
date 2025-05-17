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
sim_exponential_histogram <- function(weeks = 52, end_date = Sys.Date(), rate = 0.1){

  # generate the weekly dates ending on the specified date
  dates <- seq.Date(end_date, by = "-1 week", length.out = weeks)

  # generate exponential values for each date
  n_values <- rexp(weeks, rate = rate) |>
    round() |>
    sort(decreasing = TRUE)

  # Create the data frame
  df <- data.frame(
    waiting_since = dates,
    n = n_values
  )

  return(df)

}