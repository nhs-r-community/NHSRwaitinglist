library(readxl)

# List Excel files in the specified directory
excel_files <- list.files("raw_data/national_rtt/provider/incomplete/", pattern = "\\.xlsx?$", full.names = TRUE)

# Check if any Excel files are found
if (length(excel_files) == 0) {
    stop("No Excel files found in 'raw_data/national_rtt/provider/incomplete/'")
}

# Inform which file is being read
message("Reading file: ", excel_files[1])

# Read the first Excel file (assumed to be the Incomplete Provider Excel file)
incomplete_data <- read_excel(excel_files[1])

# Remove the first 11 rows (assumed to be metadata/header)
incomplete_data <- incomplete_data[-c(1:11), ]

# Set column names using the first row, replacing spaces with underscores
colnames(incomplete_data) <- gsub(" ", "_", as.character(unlist(incomplete_data[1, ])))

# Remove the row used for column names
incomplete_data <- incomplete_data[-1, ]

# Remove columns 6 to 110 (assumed to be date columns)
incomplete_data <- incomplete_data[, -c(6:110)]

# View the cleaned data
View(incomplete_data)

# Source all R scripts in the 'R' directory
r_scripts <- list.files("R", pattern = "\\.R$", full.names = TRUE)
sapply(r_scripts, source)

# TODO: make this name/date extraction a function
# Extract the date string from the filename (assumes format like ...-MmmYY-...)
filename <- basename(excel_files[1])
date_str <- substr(
  sub("^Incomplete-Provider-", "", filename),
  1, 5
)
# Use the month_year_to_last_day function from utils_dates.R
report_date <- month_year_to_last_day(date_str)
cat("Report date (last day of month):", report_date, "\n")
# Then you need to make the excel file into row format from the weeks so that you can make your histogram.

hed <- head(incomplete_data)

View(hed)

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

flat_hed <- flatten_waiting_list_data(hed,report_date)

View(flat_hed)


flat_incomplete_data <- flatten_waiting_list_data(incomplete_data, report_date)

View(flat_incomplete_data)
######


# TODO: Make this into a script to process national RTT data
# Check if the national data file exists; if not, extract it from all Excel files 
# and save as RDS
if (!file.exists("data/all_national_data.rds")) {
    file_paths <- list.files(
        path = "raw_data/national_rtt/provider/new_periods",
        pattern = "^New-Periods-Provider-.*\\.xlsx$",
        full.names = TRUE
    )

    all_national_data <- data.frame()

    for (file_path in file_paths) {
        # Extract the date from the filename
        provider_date <- substr(
            sub(
                "^raw_data/national_rtt/provider/new_periods/New-Periods-Provider-", 
                "", 
                file_path
            ),
            1, 5
        )
        # Read the Excel file and clean up the data
        national_data <- read_excel(file_path)
        national_data <- national_data[-(1:11), ]
        colnames(national_data) <- gsub(
            " ", "_", as.character(unlist(national_data[1, ]))
        )
        national_data <- national_data[-1, ]

        # Add date columns and convert relevant columns to numeric
        report_date <- month_year_to_last_day(provider_date)
        national_data$report_date <- report_date
        national_data$arrival_before <- report_date
        national_data$arrival_since <- first_day_of_month(report_date)
        national_data$Number_of_new_RTT_clock_starts_during_the_month <- as.numeric(
            national_data$Number_of_new_RTT_clock_starts_during_the_month
        )

        # Append to the combined data frame
        all_national_data <- rbind(all_national_data, national_data)
    }

    # Save the processed data for future use
    saveRDS(all_national_data, file = "data/all_national_data.rds")
} else {
    # Load the processed data if it already exists
    all_national_data <- readRDS("data/all_national_data.rds")
}

View(all_national_data)
