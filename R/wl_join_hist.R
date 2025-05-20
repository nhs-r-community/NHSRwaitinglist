#' Join Two Waiting Lists in Histogram Format
#'
#' Combines two waiting lists provided in histogram format into a single
#' histogram. Optionally, preserves common category columns between the two
#' dataframes.
#'
#' @param wl_hist_1 data.frame. A waiting list in histogram format.
#' @param wl_hist_2 data.frame. A waiting list in histogram format.
#' @param keep_categories logical. If TRUE, retains only the common category
#'   columns when aggregating. Default is FALSE.
#'
#' @return data.frame. A combined waiting list in histogram format.
#'
#' @details
#' This function ensures both input dataframes are in the correct histogram
#' format, aggregates them (optionally by common categories), and returns the
#' combined result in histogram format.
#'
#' @seealso \code{\link{format_histogram}}, \code{\link{aggregate_histogram}}
#'
#' @export

wl_join_hist <- function(wl_hist_1, wl_hist_2, categories = FALSE){

  # Ensure both waiting lists are in the correct histogram format
  wl_hist_1 <- format_histogram(wl_hist_1)
  wl_hist_2 <- format_histogram(wl_hist_2)

  # Determine group columns if categories is TRUE
  if (categories) {
    group_columns <- intersect(names(wl_hist_1), names(wl_hist_2))
    group_columns <- setdiff(group_columns, c("arrival_since", "arrival_before"))
  } else {
    group_columns <- NULL
  }

  # merges two waiting lists
  joined_wl <- rbind(
    aggregate_histogram(wl_hist_1, group_columns = group_columns),
    aggregate_histogram(wl_hist_2, group_columns = group_columns)
  )

  joined_wl <- format_histogram(joined_wl, group_columns = group_columns)

  return(joined_wl)

}
