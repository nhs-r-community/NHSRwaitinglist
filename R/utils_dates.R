# TODO: 

# helper function
first_day_of_month <- function(date) {
  date <- as.Date(date)
  as.Date(format(date, "%Y-%m-01"))
}

# Convert "MmmYY" (e.g., "Apr24") to last day of month "YYYY-MM-DD"
# TODO: Add these date functions to the package somewhere!
month_year_to_last_day <- function(mmyy) {
  # Parse month and year
  month_str <- substr(mmyy, 1, 3)
  year_str <- substr(mmyy, 4, 5)
  # Convert to numeric year (assume 2000+)
  year_num <- as.integer(paste0("20", year_str))
  # Match month abbreviation to month number
  month_num <- match(month_str, month.abb)
  if (is.na(month_num)) stop("Invalid month abbreviation")
  # First day of month
  first_day <- as.Date(sprintf("%04d-%02d-01", year_num, month_num))
  # Last day of month
  last_day <- as.Date(format(seq(first_day, length = 2, by = "1 month")[2] - 1, "%Y-%m-%d"))
  return(as.character(last_day))
}