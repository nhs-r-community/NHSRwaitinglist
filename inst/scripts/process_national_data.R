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

# TODO: comments above too much? THE FUNCTIONALITY BELOW DOES MORE
# TODO: Create decent dummy data for this
library(tidyr)
library(dplyr)
library(readxl)
source("R/utils_dates.R")

# TODO: EXTEND THIS BEYOND INCOMPLETES
excel_report_date <- function(filename) {
    date_str <- substr(
        sub("^Incomplete-Provider-", "", basename(filename)),
        1, 5
    )
    # Use the month_year_to_last_day function from utils_dates.R
    report_date <- month_year_to_last_day(date_str)
    return(report_date)
}

flatten_waiting_list_data <- function(excel_file_name, remove_zeros = FALSE) {
    # Derive report_date from the excel_report_date function using excel_file_name
    report_date <- excel_report_date(excel_file_name)
    # Skip processing if report_date is earlier than 2013-04-01
    if (as.Date(report_date) < as.Date("2013-04-01")) {
        message("Skipping file: report_date is earlier than 2013-04-01")
        return(NULL)
    }
    
    # Remove the first 11 rows (assumed to be metadata/header)
    excel_file <- read_excel(excel_file_name)
    excel_file <- excel_file[-c(1:11), ]
    
    # Set column names using the first row, replacing spaces with underscores
    colnames(excel_file) <- gsub(" ", "_", as.character(unlist(excel_file[1, ])))
    

    # Remove the row used for column names
    excel_file <- excel_file[-1, ]

    
    # Now process as report_data
    report_data <- excel_file

    # Identify the columns to keep and the columns to pivot
    # Identify id columns as all columns up to and including "Treatment_Function"
    id_cols_end <- which(colnames(report_data) == "Treatment_Function")
    id_cols <- colnames(report_data)[1:id_cols_end]

    # Find the position of the first column containing "_plus"
    col_plus <- which(grepl("_plus", colnames(report_data)))[1]

    # Keep only columns up to "52_plus"
    report_data <- report_data[, c(id_cols, colnames(report_data)[(length(id_cols)+1):col_plus])]

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

load_national_new_periods <- function(reload = FALSE, start_date = as.Date("1900-01-01"), end_date = as.Date("2100-12-31")) {
    rds_file <- "data/all_national_new_periods.rds"
    if (!file.exists(rds_file) || reload) {
        file_paths <- list.files(
            path = "raw_data/national_rtt/provider/new_periods",
            pattern = "^New-Periods-Provider-.*\\.xlsx$",
            full.names = TRUE
        )

        all_national_data <- data.frame()

        for (file_path in file_paths) {
            # Extract the date from the filename
            # TODO: this below should be a function
            provider_date <- substr(
                sub(
                    "^raw_data/national_rtt/provider/new_periods/New-Periods-Provider-", 
                    "", 
                    file_path
                ),
                1, 5
            )
            report_date <- month_year_to_last_day(provider_date)

            # Only process if report_date is within start_date and end_date
            if (as.Date(report_date) < as.Date(start_date) || as.Date(report_date) > as.Date(end_date)) {
                next
            }

            # Read the Excel file and clean up the data
            national_data <- read_excel(file_path)
            national_data <- national_data[-(1:11), ]
            colnames(national_data) <- gsub(
                " ", "_", as.character(unlist(national_data[1, ]))
            )
            national_data <- national_data[-1, ]

            # Add date columns and convert relevant columns to numeric
            national_data$Number_of_new_RTT_clock_starts_during_the_month <- as.numeric(national_data$Number_of_new_RTT_clock_starts_during_the_month)
            names(national_data)[names(national_data) == "Number_of_new_RTT_clock_starts_during_the_month"] <- "n"

            national_data$report_date <- report_date
            national_data$arrival_since <- first_day_of_month(report_date)
            national_data$arrival_before <- report_date

            # Append to the combined data frame
            all_national_data <- rbind(all_national_data, national_data)
        }

        # Save the processed data for future use
        saveRDS(all_national_data, file = rds_file)
    } else {
        # Load the processed data if it already exists
        all_national_data <- readRDS(rds_file)
        # Optionally filter by date if loaded from RDS
        if (!is.null(all_national_data$report_date)) {
            all_national_data <- all_national_data %>%
            filter(as.Date(report_date) >= as.Date(start_date) & as.Date(report_date) <= as.Date(end_date))
        }
    }
    return(all_national_data)
}

load_national_incomplete <- function(reload = FALSE, start_date = as.Date("1900-01-01"), end_date = as.Date("2100-12-31")) {
    rds_file <- "data/all_national_incomplete.rds"
    if (!file.exists(rds_file) || reload) {
        # TODO: be more precise here!
        r_scripts <- list.files("R", pattern = "\\.R$", full.names = TRUE)
        sapply(r_scripts, source)

        # List Excel files in the specified directory
        excel_files <- list.files("raw_data/national_rtt/provider/incomplete/", pattern = "\\.xlsx?$", full.names = TRUE)

        # Check if any Excel files are found
        if (length(excel_files) == 0) {
            stop("No Excel files found in 'raw_data/national_rtt/provider/incomplete/'")
        }

        flat_dfs <- list()
        for (i in seq_along(excel_files)) {
            report_date <- excel_report_date(excel_files[i])
            # Only process if report_date is within start_date and end_date
            if (is.null(report_date) || as.Date(report_date) < as.Date(start_date) || as.Date(report_date) > as.Date(end_date)) {
                next
            }
            cat("Processing file", i, "of", length(excel_files), ":", excel_files[i], "\n")
            flat_dfs[[i]] <- flatten_waiting_list_data(excel_files[i])
        }

        # Filter out NULLs from flat_dfs
        flat_dfs_nonnull <- Filter(Negate(is.null), flat_dfs)
        # Bind the non-NULL data frames into one
        flat_df <- bind_rows(flat_dfs_nonnull)

        saveRDS(flat_df, file = rds_file)
    } else {
        flat_df <- readRDS(rds_file)
        # Optionally filter by date if loaded from RDS
        if (!is.null(flat_df$report_date)) {
            flat_df <- flat_df %>%
                filter(as.Date(report_date) >= as.Date(start_date) & as.Date(report_date) <= as.Date(end_date))
        }
    }
    return(flat_df)
}


# TODO: Delete this scatch area when done 
########## SCRATCH AREA ###########

# Source all R scripts in the 'R' directory


# Load the existing all_national_data from RDS file
all_national_data <- readRDS("data/all_national_data.rds")

# HERE: Maybe keep as separate files and have one file merging with a flag for removal/referal etc...

View(head(flat_df))
View(head(all_national_data))

print(colnames(flat_df))
print(colnames(all_national_data))

excel_files[9]
flatten_waiting_list_data(excel_files[9])
excel_file_name <- excel_files[9]
View(report_data)
