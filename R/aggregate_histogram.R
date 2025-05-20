#' Aggregate a histogram to remove categorical variables and sum to a single
#' waiting list
#' 
#' (arrival_since, arrival_before) are the start and end dates of the arrival time
#' interval. The function aggregates the histogram by summing the counts. 
#' (The arrival_since and arrival_before columns are not aggregated.)
#'
#' @param histogram a waiting list in histogram format, possibly including
#' counts for different categorical variables
#'
#' @returns a dataframe summarised to a single aggregated waiting list
#'
#' @importFrom utils globalVariables


aggregate_histogram <- function(histogram, group_columns = NULL) {
  # Always group by arrival_since, and arrival_before if present
  groups <- c("arrival_since")
  if ("arrival_before" %in% colnames(histogram)) {
    groups <- c(groups, "arrival_before")
  }
  # Add any user-supplied grouping variables
  if (!is.null(group_columns)) {
    groups <- c(groups, group_columns)
    # Remove duplicates in case user supplies arrival_since/arrival_before
    groups <- unique(groups)
  }
  result <- histogram |>
    dplyr::group_by(dplyr::across(dplyr::all_of(groups))) |>
    dplyr::summarise(n = sum(n), .groups = "drop")
  return(result)
}