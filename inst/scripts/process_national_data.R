#' Flatten Waiting List Data
#'
#' This function transforms a wide-format NHS waiting list dataset into a long-format data frame,
#' adding calculated date columns for patient arrival windows. It is designed to process national
#' waiting list data, extracting and reshaping relevant columns, and optionally removing rows with zero counts.
#'
#' @param report_data A data frame containing the waiting list report data in wide format.
#' @param report_date The date of the report (as a Date or character string convertible to Date).
#' @param remove_zeros Logical; if TRUE, rows where the count (`n`) is zero will be removed. Default is FALSE.
#'
#' @return A long-format data frame with the following columns:
#'   \itemize{
#'     \item Area_Team_Code
#'     \item Provider_Code
#'     \item Provider_Name
#'     \item Treatment_Function_Code
#'     \item Treatment_Function
#'     \item n: Number of patients in each week band
#'     \item report_date: The date of the report
#'     \item arrived_since: The earliest date patients in the week band could have arrived
#'     \item arrived_before: The latest date patients in the week band could have arrived
#'   }
#'
#' @details
#' \describe{
#'   \item{Column Selection}{Keeps only identifier columns and week columns up to "52_plus".}
#'   \item{Pivoting}{Converts the data from wide to long format, with one row per week band per group.}
#'   \item{Date Calculation}{Calculates the arrival window for each week band based on the report date.}
#'   \item{Zero Removal}{Optionally removes rows where the count is zero.}
#' }
#'
#' @examples
#' \dontrun{
#' flattened <- flatten_waiting_list_data(report_data, report_date = "2024-03-31", remove_zeros = TRUE)
#' }
#'
#' @importFrom dplyr %>% mutate select filter relocate
#' @importFrom tidyr pivot_longer
#'
#' @export

# TODO: comments above too much? 
library(tidyr)
library(dplyr)
flatten_waiting_list_data <- function(report_data, report_date, remove_zeros = FALSE) {
    # Identify the columns to keep and the columns to pivot
    id_cols <- c("Area_Team_Code", "Provider_Code", "Provider_Name", "Treatment_Function_Code", "Treatment_Function")

    # Find the position of the "52_plus" column
    col_52_plus <- which(colnames(report_data) == "52_plus")

    # Keep only columns up to "52_plus"
    report_data <- report_data[, c(id_cols, colnames(report_data)[(length(id_cols)+1):col_52_plus])]

    # Identify week columns (those after id_cols and up to "52_plus")
    week_cols <- setdiff(colnames(report_data), id_cols)

    # Pivot the data from wide to long format
    report_long <- report_data %>%
        pivot_longer(
            cols = all_of(week_cols),
            names_to = "weeks",
            values_to = "n"
        )

    # Add a report_date column to report_long
    report_long <- report_long %>%
        mutate(report_date = report_date)

    # Create a numeric column extracting the leading one or two digits from 'weeks', ignoring the character ">"
    report_long <- report_long %>%
        mutate(
            weeks_num = as.numeric(sub("^>?([0-9]{1,2}).*", "\\1", weeks))
        )

    # Create arrived_before column as Date: report_date minus weeks_num * 7 days
    report_long <- report_long %>%
        mutate(
            arrived_before = as.Date(report_date) - (weeks_num * 7)
        )

    # Create arrived_since column as Date: arrived_before minus 6 days
    report_long <- report_long %>%
        mutate(
            arrived_since = arrived_before - 6
        )

    # Reorder columns so that arrived_since comes before arrived_before
    report_long <- report_long %>%
        relocate(arrived_since, .before = arrived_before)

    # Remove the 'weeks' and 'weeks_num' columns
    report_long <- report_long %>%
        select(-weeks, -weeks_num)

    # Remove rows where n == 0 if remove_zeros is TRUE
    if (remove_zeros) {
        report_long <- report_long %>% filter(n != 0)
    }

    return(report_long)
}
