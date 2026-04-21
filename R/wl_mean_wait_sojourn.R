#' Calculate Mean Sojourn Time Between Referral and Removal
#'
#' This function calculates the mean sojourn time (number of days between referral and removal dates)
#' in a waiting list data frame. It ignores rows with missing referral or removal values.
#'
#' @param waiting_list A data frame containing referral and removal date columns.
#'
#' @return A numeric value representing the mean sojourn time in days. Returns \code{NA_real_}
#'   if there are no complete referral/removal pairs.
#' @export
#'
#' @examples
#' waiting_list <- data.frame(
#'   referral = as.Date(c("2024-01-01", "2024-01-08")),
#'   removal = as.Date(c("2024-01-05", NA))
#' )
#' wl_mean_wait_sojourn(waiting_list)


wl_mean_wait_sojourn <- function(waiting_list) {
    referral_index <- calc_index(waiting_list, type = "referral")
    removal_index <- calc_index(waiting_list, type = "removal")

    check_wl(waiting_list, referral_index, removal_index)

    valid_rows <- !is.na(waiting_list[, referral_index]) & !is.na(waiting_list[, removal_index])

    if (!any(valid_rows)) {
        return(NA_real_)
    }

    sojourn_days <- as.numeric(waiting_list[valid_rows, removal_index] - waiting_list[valid_rows, referral_index])
    mean(sojourn_days)
}