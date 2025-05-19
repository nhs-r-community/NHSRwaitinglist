#' Aggregate a histogram to remove categorical variables and sum to a single
#' waiting list
#'
#' @param histogram a waiting list in histogram format, possibly including
#' counts for different categorical variables
#'
#' @returns a dataframe summarised to a single aggregated waiting list
#'
#' @importFrom utils globalVariables


aggregate_histogram <- function(histogram) {

  if ("arrival_before" %in% colnames(histogram)) {
    result <- histogram |>
      dplyr::group_by(arrival_since, arrival_before) |>
      dplyr::summarise(n = sum(n), .groups = "drop")
  } else {
    result <- histogram |>
      dplyr::group_by(arrival_since) |>
      dplyr::summarise(n = sum(n), .groups = "drop")
  }
  # the result will have only two columns:
  ## waiting_since
  ## n
  return(result)

}