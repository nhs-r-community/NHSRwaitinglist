#' Calculate Mean Wait Time from Waiting List History
#'
#' Calculates the mean wait time (in days) for a waiting list history data frame,
#' with reference to a specified end date.
#'
#' @param wl_hist A data frame containing waiting list history, with columns:
#'   \describe{
#'     \item{arrival_since}{Numeric, days since arrival}
#'     \item{arrival_before}{Numeric, days before arrival}
#'     \item{n}{Numeric, count of cases}
#'   }
#' @param end_date A Date object representing the reference end date.
#'
#' @return Numeric value of the mean wait time (in days).
#' @export
#' 
wl_mean_wait_age_hist <- function(wl_hist) {

      mean_age <- wl_hist %>%
        mutate(
            report_arrival_diff = as.numeric(as.Date(report_date) - as.Date(arrival_before)),
            half_arrival_diff = as.numeric(as.Date(arrival_before)+1 - as.Date(arrival_since))/2 ,
            wait_days = report_arrival_diff + half_arrival_diff
        ) %>%
        summarise(
            mean_wait = sum(wait_days * n) / sum(n)
        ) %>%
        pull(mean_wait)

    return(mean_age)
}