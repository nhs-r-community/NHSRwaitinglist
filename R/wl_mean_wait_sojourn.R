#' Calculate Mean Sojourn Time Between Referral and Removal
#'
#' This function calculates the mean sojourn time (number of days between 'Referral' and 'Removal' dates)
#' in a waiting list data frame. It ignores rows with missing 'Referral' or 'Removal' values.
#'
#' @param waiting_list A data frame containing at least 'Referral' and 'Removal' date columns.
#'
#' @return A numeric value representing the mean sojourn time in days.
#' @export
#'
#' @examples
#' # waiting_list should have columns 'Referral' and 'Removal' as Date objects
#' wl_mean_wait_sojourn(waiting_list)


wl_mean_wait_sojourn <- function(waiting_list) {
    mean_sojourn <- waiting_list %>%
        filter(!is.na(Referral) & !is.na(Removal)) %>%
        mutate(diff_days = as.numeric(Removal - Referral)) %>%
        summarise(mean_diff = mean(diff_days)) %>%
        pull(mean_diff)
    return(mean_sojourn)
}