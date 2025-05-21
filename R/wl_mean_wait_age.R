#' Calculate Mean Age of Waiting for Patients on Waiting List
#'
#' This function calculates the time waiting for patients who are still on the waiting list as of a specified end date.
#' Recall that the age of waiting is the mean time waited so far. (Opposed to the mean sojourn time, which is the time waiting until removal from the list.)
#'
#' @param waiting_list A data frame containing patient waiting list data.
#' @param dob_index The column name or index for the date of birth in \code{waiting_list}.
#' @param removal_index The column name or index for the removal date in \code{waiting_list}.
#' @param end_date The date (as Date or numeric) up to which to calculate ages.
#'
#' @return The mean age (numeric) for patients still waiting as of \code{end_date}.
#' @export
wl_mean_wait_age <- function(waiting_list, dob_index, removal_index, end_date) {
    waiting_patients <-
        waiting_list[which((waiting_list[, removal_index] > end_date | is.na(waiting_list[, removal_index])) &
                                                waiting_list[, dob_index] <= end_date), ]
    ages <-
        as.numeric(difftime(end_date, waiting_patients[, dob_index], units = "days")) / 365.25
    mean(ages, na.rm = TRUE)
}