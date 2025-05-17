#' Calculates the number of people in a queue
#'
#' @param wl_hist dataframe. A waiting list in histogram format
#'
#' @returns integer. The size of the queue or waiting list
#' @export
#'
wl_queue_size_hist <- function(wl_hist){

  aggregated_histogram <- aggregate_histogram(wl_hist)

  queue_size <- aggregated_histogram |>
    dplyr::pull(n) |>
    sum()

}
