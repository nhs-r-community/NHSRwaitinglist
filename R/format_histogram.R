#' Format Histogram Data for Waiting List Metrics
#'
#' This function formats a histogram data frame by ensuring the presence and correct formatting of
#' `arrival_since` and `arrival_before` columns. If `arrival_before` does not exist, it is generated
#' for each group as the previous `arrival_since` date (or the end date for the first row in each group).
#'
#' @param histogram A data frame containing at least an `arrival_since` column (as character or Date).
#' @param group_column A character vector specifying the column(s) to group by when generating `arrival_before`.
#' @param end_date Optional. The reference date to use for the first `arrival_before` in each group.
#'   Defaults to the system date.
#'
#' @return A data frame with `arrival_since` and `arrival_before` columns as Dates, and all original columns.
#'   The columns are reordered so that `arrival_since` and `arrival_before` appear first.
#'
#' @details
#' - If the `arrival_before` column exists, it is converted to Date.
#' - If not, for each group (as defined by `group_column`), `arrival_before` is set to the previous
#'   `arrival_since` (or `end_date` for the first row), minus one day.
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
format_histogram <- function(histogram, group_columns = NULL, end_date = NULL, time_interval = "weeks") {

    # Set end_date based on time_interval and arrival_since if not provided
    if (is.null(end_date)) {
        max_date <- max(as.Date(histogram$arrival_since), na.rm = TRUE)
        if (is.null(time_interval)) {
            end_date <- Sys.Date()
        } else if (identical(time_interval, "weeks")) {
            end_date <- max_date + 7
        } else if (identical(time_interval, "months")) {
            # Get last day of the month for max_date
            end_date <- as.Date(format(max_date, "%Y-%m-01")) + 
                as.difftime(1, units = "months") - 1
        } else if (is.numeric(time_interval)) {
            end_date <- max_date + (as.numeric(time_interval) - 1)
        } else {
            end_date <- Sys.Date()
        }
    } else {
        end_date <- as.Date(end_date)
    }

    # Convert the 'arrival_since' column in the 'histogram' data frame to Date type
    histogram$arrival_since <- as.Date(histogram$arrival_since)

    # If 'arrival_before' column exists, convert it to Date.
    # Otherwise, for each group, create 'arrival_before' as the previous 'arrival_since' (or end_date for the first row).
    if ("arrival_before" %in% names(histogram)) {
        histogram$arrival_before <- as.Date(histogram$arrival_before)
    } else {
        if (is.null(group_columns)) {
            # No grouping: just use lag on the whole data frame
            histogram <- histogram[order(-as.numeric(histogram$arrival_since)), ]
            histogram$arrival_before <- dplyr::lag(histogram$arrival_since, default = end_date) - 1
        } else {
            group_syms <- rlang::syms(group_columns)
            histogram <- histogram[order(histogram[, group_columns], -as.numeric(histogram$arrival_since)), ]
            histogram <- dplyr::group_by(histogram, !!!group_syms)
            histogram <- dplyr::mutate(
                histogram,
                arrival_before = dplyr::lag(arrival_since, default = end_date) - 1
            )
            histogram <- dplyr::ungroup(histogram)
        }
    }

    # Reorder columns: arrival_since, arrival_before, then the rest
    cols <- names(histogram)
    cols <- c("arrival_since", "arrival_before", setdiff(cols, c("arrival_since", "arrival_before")))
    histogram <- histogram[, cols]

    # Improved sorting: always sort by group_columns(s) (if present) and arrival_since (descending)
    if (!is.null(group_columns)) {
        group_columns <- setdiff(group_columns, c("arrival_since", "arrival_before", "n"))
        ordering <- do.call(order, c(histogram[group_columns], list(-as.numeric(histogram$arrival_since))))
        histogram <- histogram[ordering, ]
    } else {
        histogram <- histogram[order(-as.numeric(histogram$arrival_since)), ]
    }

    return(as.data.frame(histogram))
}
