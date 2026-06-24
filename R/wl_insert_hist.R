#' Insert some patients into a waiting list in histogram format
#'
#' Acting on a histogram this is identical to \\code{wl_join_hist()}.
#'
#' @param waiting_list dataframe. A waiting list in histogram format
#' @param additions dataframe. A dataframe of waiting list additions in
#' histogram format
#'
#' @return data.frame. A combined waiting list.
#' @export
#'
wl_insert_hist <- function(waiting_list, additions) {
  # use the join function internally
  wl_join_hist(waiting_list, additions)
}
