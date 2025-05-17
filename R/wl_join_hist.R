#' Join two waiting lists provided as histograms
#'
#' @param wl_hist_1 dataframe. A waiting list in histogram format
#' @param wl_hist_2 dataframe. A waiting list in histogram format
#'
#' @returns dataframe. A combined waiting list in histogram format
#' @export
#'
wl_join_hist <- function(wl_hist_1, wl_hist_2){

  # merges two waiting lists, and moves any data not on a Monday date onto the previous Monday

  joined_wl <- rbind(
    aggregate_histogram(wl_hist_1),
    aggregate_histogram(wl_hist_2)
    )

  # standardise the waiting list so that all counts are allocated to Mondays
  # do this by moving data forwards to the prior Monday date
  standardised_wl <- joined_wl |>
    dplyr::mutate(
      waiting_since = lubridate::floor_date(waiting_since, unit = "week", week_start = 1)
    ) |>

    # sum the new total for each histogram bin (if any data was not already on Mondays)
    aggregate_histogram()

}