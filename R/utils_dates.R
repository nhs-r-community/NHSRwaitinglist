first_day_of_month <- function(date) {
  date <- as.Date(date)
  as.Date(format(date, "%Y-%m-01"))
}

month_year_to_last_day <- function(mmmyy) {
  if (length(mmmyy) != 1 || is.na(mmmyy)) {
    return(NULL)
  }

  token_match <- regexpr(
    "(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[-_ ]?[0-9]{2}",
    mmmyy,
    ignore.case = TRUE
  )
  if (token_match[1] == -1) {
    return(NULL)
  }

  token <- regmatches(mmmyy, token_match)
  token <- gsub("[-_ ]", "", token)
  month_str <- substr(token, 1, 3)
  year_str <- substr(token, 4, 5)
  year_num <- as.integer(paste0("20", year_str))
  month_num <- match(tolower(month_str), tolower(month.abb))

  if (is.na(year_num) || is.na(month_num)) {
    return(NULL)
  }

  first_day <- as.Date(sprintf("%04d-%02d-01", year_num, month_num))
  last_day <- seq(first_day, length = 2, by = "1 month")[2] - 1
  as.character(last_day)
}

excel_report_date <- function(filename) {
  file_base <- basename(filename)

  token_match <- regexpr(
    "(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[-_ ]?[0-9]{2}",
    file_base,
    ignore.case = TRUE
  )
  if (token_match[1] == -1) {
    return(NULL)
  }

  month_year_to_last_day(regmatches(file_base, token_match))
}
