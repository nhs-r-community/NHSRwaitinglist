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
      # the arrival_since date is the nominal start of the period (i.e Monday, or 1st of month)
      arrival_since = lubridate::floor_date(arrival_since, unit = "week", week_start = 1),

      # the arrival_before date is the nominal end of the period (i.e Sunday, or 31st of month)
      arrival_before = lubridate::floor_date(arrival_before, unit = "week", week_start = 1) + lubridate::days(6)
    ) |>

    # sum the new total for each histogram bin (if any data was not already on Mondays)
    aggregate_histogram()

}