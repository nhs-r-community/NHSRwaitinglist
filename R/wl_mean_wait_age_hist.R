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
wl_mean_wait_age_hist <- function(wl_hist, end_date) {
    mean_age <- wl_hist %>%
        mutate(
            wait_days = as.numeric(end_date - ((as.numeric(arrival_since) + as.numeric(arrival_before)) / 2))
        ) %>%
        summarise(
            mean_wait = sum(wait_days * n) / sum(n)
        ) %>%
        pull(mean_wait)

    return(mean_age)
}