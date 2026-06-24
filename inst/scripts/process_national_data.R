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


is_week_band <- function(x) {
  grepl("^>?[0-9]+-[0-9]+$", x) || grepl("^[0-9]+_plus$", x, ignore.case = TRUE)
}

week_band_lower <- function(x) {
  as.numeric(sub("^>?([0-9]+).*$", "\\1", x))
}

normalise_national_basis <- function(basis = c("provider", "commissioner", "comissioner")) {
  basis <- match.arg(tolower(basis), choices = c("provider", "commissioner", "comissioner"))
  if (basis == "comissioner") {
    basis <- "commissioner"
  }
  basis
}

flatten_waiting_list_data <- function(excel_file_name, remove_zeros = FALSE) {
  report_date <- excel_report_date(excel_file_name)
  if (is.null(report_date) || is.na(report_date)) {
    stop("Could not infer report date from file name: ", basename(excel_file_name))
  }

  if (as.Date(report_date) < as.Date("2013-04-01")) {
    message("Skipping file: report_date is earlier than 2013-04-01")
    return(NULL)
  }

  excel_file <- readxl::read_excel(
    excel_file_name,
    col_names = FALSE,
    .name_repair = "minimal"
  )
  header_row <- which(apply(excel_file, 1, function(row) {
    any(trimws(as.character(row)) == "Treatment Function", na.rm = TRUE)
  }))[1]

  if (is.na(header_row)) {
    stop("Could not find the 'Treatment Function' header row in: ", basename(excel_file_name))
  }

  header <- as.character(unlist(excel_file[header_row, ], use.names = FALSE))
  header <- gsub("[[:space:]]+", "_", trimws(header))
  keep_cols <- !is.na(header) & nzchar(header)

  report_data <- excel_file[(header_row + 1):nrow(excel_file), keep_cols, drop = FALSE]
  names(report_data) <- make.unique(header[keep_cols], sep = "_")

  id_cols_end <- which(names(report_data) == "Treatment_Function")[1]
  if (is.na(id_cols_end)) {
    stop("Could not find 'Treatment_Function' after cleaning column names in: ", basename(excel_file_name))
  }

  id_cols <- names(report_data)[1:id_cols_end]
  candidate_week_cols <- names(report_data)[(id_cols_end + 1):ncol(report_data)]
  week_cols <- candidate_week_cols[vapply(candidate_week_cols, is_week_band, logical(1))]
  if (length(week_cols) == 0) {
    stop("No weekly waiting-time columns found in: ", basename(excel_file_name))
  }

  report_data <- report_data[, c(id_cols, week_cols), drop = FALSE]

  report_long <- report_data %>%
    tidyr::pivot_longer(
      cols = dplyr::all_of(week_cols),
      names_to = "week_band",
      values_to = "n"
    ) %>%
    dplyr::mutate(
      report_date = as.Date(report_date),
      weeks_waiting = week_band_lower(.data$week_band),
      open_ended = grepl("plus", .data$week_band, ignore.case = TRUE),
      arrived_before = .data$report_date - (.data$weeks_waiting * 7),
      arrived_since = .data$arrived_before - 6,
      n = as.numeric(.data$n)
    ) %>%
    dplyr::relocate("arrived_since", .before = "arrived_before")

  if (remove_zeros) {
    report_long <- report_long %>% dplyr::filter(.data$n != 0)
  }

  return(report_long)
}

load_histogram_dataset <- function(
  dataset = c("incomplete", "admitted", "non_admitted"),
  reload = FALSE,
  start_date = as.Date("1900-01-01"),
  end_date = as.Date("2100-12-31"),
  basis = c("provider", "commissioner", "comissioner")
) {
  dataset <- match.arg(dataset)
  basis <- normalise_national_basis(basis)

  basis_dir <- if (basis == "commissioner") "comissioner" else "provider"
  dataset_dir <- switch(dataset,
    incomplete = "incomplete",
    admitted = "admitted",
    non_admitted = "non-admitted"
  )
  dataset_name <- switch(dataset,
    incomplete = "incomplete",
    admitted = "admitted",
    non_admitted = "non_admitted"
  )
  rds_stub <- if (basis == "provider") dataset_name else paste("commissioner", dataset_name, sep = "_")
  rds_file <- file.path("data", paste0("all_national_", rds_stub, ".rds"))

  if (!file.exists(rds_file) || reload) {
    source_dir <- file.path("raw_data", "national_rtt", basis_dir, dataset_dir)
    excel_files <- list.files(source_dir, pattern = "\\.xlsx?$", full.names = TRUE)

    if (length(excel_files) == 0) {
      stop("No Excel files found in '", source_dir, "'")
    }

    flat_dfs <- vector("list", length(excel_files))
    for (i in seq_along(excel_files)) {
      report_date <- excel_report_date(excel_files[i])
      if (is.null(report_date) || as.Date(report_date) < as.Date(start_date) || as.Date(report_date) > as.Date(end_date)) {
        next
      }
      cat("Processing file", i, "of", length(excel_files), ":", excel_files[i], "\n")
      flat_dfs[[i]] <- flatten_waiting_list_data(excel_files[i])
    }

    flat_dfs_nonnull <- Filter(Negate(is.null), flat_dfs)
    flat_df <- dplyr::bind_rows(flat_dfs_nonnull)

    dir.create(dirname(rds_file), showWarnings = FALSE, recursive = TRUE)
    saveRDS(flat_df, file = rds_file)
  } else {
    flat_df <- readRDS(rds_file)
    if (!is.null(flat_df$report_date)) {
      flat_df <- flat_df %>%
        dplyr::filter(as.Date(.data$report_date) >= as.Date(start_date) & as.Date(.data$report_date) <= as.Date(end_date))
    }
  }

  return(flat_df)
}

load_national_new_periods <- function(reload = FALSE, start_date = as.Date("1900-01-01"), end_date = as.Date("2100-12-31")) {
  rds_file <- "data/all_national_new_periods.rds"
  if (!file.exists(rds_file) || reload) {
    file_paths <- list.files(
      path = "raw_data/national_rtt/provider/new_periods",
      pattern = "^New-Periods-Provider-.*\\.xlsx?$",
      full.names = TRUE
    )

    all_national_data <- data.frame()

    for (file_path in file_paths) {
      report_date <- excel_report_date(file_path)

      # Only process if report_date is within start_date and end_date
      if (is.null(report_date) || as.Date(report_date) < as.Date(start_date) || as.Date(report_date) > as.Date(end_date)) {
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

    dir.create(dirname(rds_file), showWarnings = FALSE, recursive = TRUE)

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

load_national_incomplete <- function(reload = FALSE, start_date = as.Date("1900-01-01"), end_date = as.Date("2100-12-31"), basis = c("provider", "commissioner", "comissioner")) {
  load_histogram_dataset("incomplete", reload, start_date, end_date, basis)
}

load_national_admitted <- function(reload = FALSE, start_date = as.Date("1900-01-01"), end_date = as.Date("2100-12-31"), basis = c("provider", "commissioner", "comissioner")) {
  load_histogram_dataset("admitted", reload, start_date, end_date, basis)
}

load_national_non_admitted <- function(reload = FALSE, start_date = as.Date("1900-01-01"), end_date = as.Date("2100-12-31"), basis = c("provider", "commissioner", "comissioner")) {
  load_histogram_dataset("non_admitted", reload, start_date, end_date, basis)
}

process_national_data <- function(reload = FALSE, start_date = as.Date("1900-01-01"), end_date = as.Date("2100-12-31"), basis = c("provider", "commissioner", "comissioner")) {
  basis <- normalise_national_basis(basis)
  new_periods <- if (basis == "provider") load_national_new_periods(reload, start_date, end_date) else NULL
  incomplete <- load_national_incomplete(reload, start_date, end_date, basis)
  admitted <- load_national_admitted(reload, start_date, end_date, basis)
  non_admitted <- load_national_non_admitted(reload, start_date, end_date, basis)

  return(list(
    new_periods = new_periods,
    incomplete = incomplete,
    admitted = admitted,
    non_admitted = non_admitted
  ))
}

# # TODO: Delete this scatch area when done
# ########## SCRATCH AREA ###########

# # Source all R scripts in the 'R' directory


# # Load the existing all_national_data from RDS file
# all_national_data <- readRDS("data/all_national_incomplete.rds")
# View(head(all_national_data))

# # HERE: Maybe keep as separate files and have one file merging with a flag for removal/referal etc...

# View(head(flat_df))
# View(head(all_national_data))

# print(colnames(flat_df))
# print(colnames(all_national_data))

# excel_files[9]
# flatten_waiting_list_data(excel_files[9])
# excel_file_name <- excel_files[9]
# View(report_data)
