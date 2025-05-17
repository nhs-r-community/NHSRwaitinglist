#' Aggregate a histogram to remove categorical variables and sum to a single
#' waiting list
#'
#' @param histogram a waiting list in histogram format, possibly including
#' counts for different categorical variables
#'
#' @returns a dataframe summarised to a single aggregated waiting list
#'
aggregate_histogram <- function(histogram){

  result <- histogram |>
    dplyr::group_by(waiting_since) |>
    dplyr::summarise(n = sum(n)) |>
    dplyr::ungroup()

  # the result will have only two columns:
  ## waiting_since
  ## n
  return(result)

}