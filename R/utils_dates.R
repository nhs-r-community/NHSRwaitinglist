# TODO: 

# helper function
first_day_of_month <- function(date) {
  date <- as.Date(date)
  as.Date(format(date, "%Y-%m-01"))
}

# Convert "MmmYY" (e.g., "Apr24") to last day of month "YYYY-MM-DD"
# TODO: Add these date functions to the package somewhere!
month_year_to_last_day <- function(mmmyy) {
  # Parse month and year
  month_str <- substr(mmmyy, 1, 3)
  year_str <- substr(mmmyy, 4, 5)
  # Convert to numeric year (assume 2000+)
  year_num <- as.integer(paste0("20", year_str))
  # Match month abbreviation to month number
  month_num <- match(month_str, month.abb)
  if (is.na(month_num)) return(NULL)
  # First day of month
  first_day <- as.Date(sprintf("%04d-%02d-01", year_num, month_num))
  # Last day of month
  last_day <- seq(first_day, length = 2, by = "1 month")[2] - 1
  last_day <- as.Date(format(last_day, "%Y-%m-%d"))
  as.character(last_day)
}
# Extracts month-year token from NHS filenames 
excel_report_date <- function(filename) {
  file_base <- basename(filename)
  if (startsWith(file_base, "Incomplete-Provider-")) {
    date_str <- substr(
      sub("^Incomplete-Provider-", "", file_base),
      1, 5
    )
    # Use the month_year_to_last_day function from utils_dates.R
    report_date <- month_year_to_last_day(date_str)
    return(report_date)
  } else if (startsWith(file_base, "NonAdmitted")) {
    date_str <- substr(
      sub("^NonAdmitted-Adjusted-Provider-", "", file_base),
      1, 5
    )
    report_date <- month_year_to_last_day(date_str)
    # If report_date is NULL, try NonAdmitted-Provider-
    if (is.null(report_date) || is.na(report_date)) {
      date_str <- substr(
        sub("^NonAdmitted-Provider-", "", file_base),
        1, 5
      )
      report_date <- month_year_to_last_day(date_str)
    }
    return(report_date)
  } else if (startsWith(file_base, "Admitted")) {
    date_str <- substr(
      sub("^Admitted-Adjusted-Provider-", "", file_base),
      1, 5
    )
    report_date <- month_year_to_last_day(date_str)
    # If report_date is NULL, try Admitted-Provider-
    if (is.null(report_date) || is.na(report_date)) {
      date_str <- substr(
        sub("^Admitted-Provider-", "", file_base),
        1, 5
      )
      report_date <- month_year_to_last_day(date_str)
    }
    return(report_date)
  }
  # Add more else if conditions here for other filename patterns
}