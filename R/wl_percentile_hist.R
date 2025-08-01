#' Calculate the Date and Weeks Corresponding to a Given Percentile in Waiting List History
#'
#' @param wl_hist A data frame containing waiting list history with columns: n (number of patients), arrival_since, arrival_before, and report_date.
#' @param percentage Numeric value indicating the percentile to calculate (default is 92).
#'
#' @return A list with:
#'   \item{date_percentile}{The estimated date corresponding to the given percentile.}
#'   \item{weeks_percentile}{The number of weeks from the report date to the percentile date.}
#' @export
#'
#' @examples
#' # get_percentile_date(wl_hist, percentage = 92)
wl_percentile_hist <- function(wl_hist, percentage = 92) {
    wl_hist_ <- wl_hist %>%
        mutate(across(c(arrival_since, arrival_before), as.Date)) %>%
        arrange(desc(arrival_since))
    
    total_patients <- sum(wl_hist_$n, na.rm = TRUE)
    p_cut <- (percentage / 100) * total_patients

    wl_hist_ <- wl_hist_ %>% mutate(cum_n = cumsum(n))
    row_p <- wl_hist_ %>% filter(cum_n >= p_cut) %>% slice(1)

    needed_in_row <- p_cut - (row_p$cum_n - row_p$n)
    prop_in_bin <- needed_in_row / row_p$n

    date_p <- row_p$arrival_since + lubridate::days(round(prop_in_bin * 7))
    weeks_p <- round(as.numeric(difftime(row_p$report_date, date_p, units = "weeks")))

    return(list(percentage = percentage, date = date_p, weeks = weeks_p))
}
