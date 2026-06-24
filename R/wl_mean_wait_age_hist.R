#' Calculate Mean Waiting Age from Waiting List History
#'
#' Calculates the mean waiting age for a histogram snapshot: the average time waited so far
#' by patients who are still on the waiting list at the report date.
#'
#' @param wl_hist A data frame containing waiting list history with columns:
#'   \\describe{
#'     \\item{arrival_since}{Date, start of the arrival interval}
#'     \\item{arrival_before}{Date, end of the arrival interval}
#'     \\item{report_date}{Date, snapshot date of the histogram}
#'     \\item{n}{Numeric, count of cases}
#'   }
#'
#' @return Numeric value of the mean waiting age in days.
#' @export
#'
wl_mean_wait_age_hist <- function(wl_hist) {
  mean_age <- wl_hist %>%
    mutate(
      wait_days = as.numeric(as.Date(.data$report_date) - as.Date(.data$arrival_before)) +
        as.numeric(as.Date(.data$arrival_before) + 1 - as.Date(.data$arrival_since)) / 2
    ) %>%
    summarise(
      mean_wait = sum(.data$wait_days * .data$n) / sum(.data$n)
    ) %>%
    pull(.data$mean_wait)

  return(mean_age)
}
