#' Format Histogram Data for Waiting List Metrics
#'
#' This function formats a histogram data frame by ensuring the presence and correct formatting of
#' `arrival_since` and `arrival_before` columns. If `arrival_before` does not exist, it is generated
#' for each group as the previous `arrival_since` date (or the current date for the first row in each group).
#'
#' @param histogram A data frame containing at least an `arrival_since` column (as character or Date).
#' @param group_column A character vector specifying the column(s) to group by when generating `arrival_before`.
#' @param current_date Optional. The reference date to use for the first `arrival_before` in each group.
#'   Defaults to the system date.
#'
#' @return A data frame with `arrival_since` and `arrival_before` columns as Dates, and all original columns.
#'   The columns are reordered so that `arrival_since` and `arrival_before` appear first.
#'
#' @details
#' - If the `arrival_before` column exists, it is converted to Date.
#' - If not, for each group (as defined by `group_column`), `arrival_before` is set to the previous
#'   `arrival_since` (or `current_date` for the first row), minus one day.
#'
#' @importFrom dplyr group_by mutate lag ungroup
#' @importFrom rlang syms
#'
#' @examples
#' \dontrun{
#' df <- data.frame(
#'   group = c("A", "A", "B"),
#'   arrival_since = c("2023-01-01", "2023-02-01", "2023-01-15")
#' )
#' format_histogram(df, group_column = "group")
#' }
#'
#' @export

format_histogram <- function(histogram, group_column, current_date = NULL) {
    if (is.null(current_date)) {
        current_date <- Sys.Date()
    } else {
        current_date <- as.Date(current_date)
    }
    
    histogram$arrival_since <- as.Date(histogram$arrival_since)

    # If 'arrival_before' column exists, convert it to Date.
    # Otherwise, for each group, create 'arrival_before' as the previous 'arrival_since' (or current_date for the first row).
    if ("arrival_before" %in% names(histogram)) {
        histogram$arrival_before <- as.Date(histogram$arrival_before)
    } else {
        group_syms <- rlang::syms(group_column)
        histogram <- histogram[order(histogram[, group_column], -as.numeric(histogram$arrival_since)), ]
        histogram <- dplyr::group_by(histogram, !!!group_syms)
        histogram <- dplyr::mutate(
                histogram,
                arrival_before = dplyr::lag(arrival_since, default = current_date) - 1
            )
        histogram <- dplyr::ungroup(histogram)
    }
    
    # Reorder columns: arrival_since, arrival_before, then the rest
    cols <- names(histogram)
    cols <- c("arrival_since", "arrival_before", setdiff(cols, c("arrival_since", "arrival_before")))
    histogram <- histogram[, cols]
    
    return(as.data.frame(histogram))
}



