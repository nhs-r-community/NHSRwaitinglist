#' Calculate the date and waiting time corresponding to a given percentile in waiting list history
#'
#' @param wl_hist A data frame containing waiting list history with columns: \code{n} (number of patients), \code{arrival_since}, \code{arrival_before}, and \code{report_date}.
#' @param percentage Numeric value indicating the percentile to calculate. Must be between 0 and 100.
#'
#' @return A list with the percentile date and weeks to percentile. The list includes both the preferred names \code{date_percentile} and \code{weeks_percentile}, and the legacy aliases \code{date} and \code{weeks} for backward compatibility.
#' @export
#'
#' @examples
#' # get_percentile_date(wl_hist, percentage = 92)
wl_percentile_hist <- function(wl_hist, percentage = 92) {
    if (!is.data.frame(wl_hist)) {
        stop("`wl_hist` must be a data.frame")
    }

    required_columns <- c("n", "arrival_since", "arrival_before", "report_date")
    missing_columns <- setdiff(required_columns, names(wl_hist))
    if (length(missing_columns) > 0) {
        stop(paste0(
            "`wl_hist` is missing required columns: ",
            paste(missing_columns, collapse = ", ")
        ))
    }

    if (!is.numeric(percentage) || length(percentage) != 1 || is.na(percentage) || percentage < 0 || percentage > 100) {
        stop("`percentage` must be a single numeric value between 0 and 100")
    }

    wl_hist_ <- wl_hist %>%
        mutate(across(dplyr::all_of(c("arrival_since", "arrival_before", "report_date")), as.Date)) %>%
        arrange(desc(.data$arrival_since))

    total_patients <- sum(wl_hist_$n, na.rm = TRUE)
    if (is.na(total_patients) || total_patients <= 0) {
        return(list(
            date_percentile = as.Date(NA),
            weeks_percentile = NA_real_,
            date = as.Date(NA),
            weeks = NA_real_,
            percentage = percentage
        ))
    }

    p_cut <- (percentage / 100) * total_patients

    wl_hist_ <- wl_hist_ %>% mutate(cum_n = cumsum(.data$n))
    row_p <- wl_hist_ %>% dplyr::filter(.data$cum_n >= p_cut) %>% dplyr::slice(1)

    if (nrow(row_p) == 0) {
        row_p <- dplyr::slice_tail(wl_hist_, n = 1)
    }

    needed_in_row <- p_cut - (row_p$cum_n - row_p$n)
    prop_in_bin <- if (row_p$n[1] > 0) {
        needed_in_row / row_p$n
    } else {
        NA_real_
    }

    date_p <- row_p$arrival_since + round(prop_in_bin * 7)
    weeks_p <- round(as.numeric(difftime(row_p$report_date, date_p, units = "weeks")))

    return(list(
        date_percentile = date_p,
        weeks_percentile = weeks_p,
        date = date_p,
        weeks = weeks_p,
        percentage = percentage
    ))
}
