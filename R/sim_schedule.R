#' @title Generator a list of dates to schedule
#'
#' @description Generates a list if dates in a given range
#'
#' @param n_rows Number of rows/patients to generate
#' @param start_date Start date (needed to generate patient ages)
#' @param daily_capacity Number of paitents per day
#'
#' @return dataframe. Empty waiting list.
#' @export sim_schedule
#'

sim_schedule <- function(
  n_rows = 10,
  start_date = NULL,
  daily_capacity = 1
) {
  if (is.null(start_date)) {
    start_date <- Sys.Date()
  }

  schedule <-
    as.Date(
      as.numeric(start_date) +
        ceiling(seq(0, n_rows - 1, 1 / daily_capacity)),
      origin = "1970-01-01"
    )

  return(schedule)
}
