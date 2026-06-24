getwd()
all_data <- readRDS("ent_data/all_ent_data.rds")
View(all_data)
source("R/utils_dates.R")

file_path <- "raw_data/national_rtt/provider/incomplete/Incomplete-Provider-May25-XLSX-9M-32711.xlsx"

incomplete_provider_stats <- function(file_path) {
    if (!file.exists(file_path)) stop("file not found: ", file_path)
    # determine report date (uses excel_report_date() and first_day_of_month() from utils_dates.R)
    report_date <- first_day_of_month(excel_report_date(file_path))
    # read and trim header rows
    incomplete_data <- readxl::read_excel(file_path)
    incomplete_data <- incomplete_data[-c(1:11), , drop = FALSE]
    # set column names from the first remaining row and drop that row
    colnames(incomplete_data) <- gsub(" ", "_", as.character(unlist(incomplete_data[1, ])))
    incomplete_data <- incomplete_data[-1, , drop = FALSE]
    # remove columns from 6 up to the first column that contains "_plus" (if present),
    # otherwise remove from column 6 to the end (if there are at least 6 columns)
    plus_col <- which(grepl("_plus", colnames(incomplete_data), ignore.case = TRUE))[1L]
    if (!is.na(plus_col) && plus_col > 6L) {
        cols_to_remove <- seq.int(6L, plus_col)
        incomplete_data <- incomplete_data[, -cols_to_remove, drop = FALSE]
    } else if (ncol(incomplete_data) >= 6L) {
        incomplete_data <- incomplete_data[, -seq.int(6L, ncol(incomplete_data)), drop = FALSE]
    }
    incomplete_data$report_date <- report_date
    return(incomplete_data)
}

process_incomplete_stats <- function(
    incomplete_dir = "raw_data/national_rtt/provider/incomplete/",
    out_file = file.path("data", "all_national_incomplete_stats.rds"),
    save = TRUE,
    verbose = TRUE
) {
    if (!dir.exists(incomplete_dir)) stop("directory not found: ", incomplete_dir)
    incomplete_files <- list.files(incomplete_dir, full.names = TRUE)
    if (verbose) print(incomplete_files)

    results_list <- lapply(incomplete_files, function(fp) {
        tryCatch({
            df <- incomplete_provider_stats(fp)
            df$source_file <- basename(fp)
            df
        }, error = function(e) {
            if (verbose) message("Parsing failed for ", basename(fp), ": ", e$message)
            NULL
        })
    })

    # drop any errors (non-data.frame) and empties
    results_list <- Filter(function(x) is.data.frame(x) && nrow(x) > 0, results_list)

    all_incomplete_stats <- if (length(results_list)) dplyr::bind_rows(results_list) else data.frame()

    if (nrow(all_incomplete_stats) > 0 && "report_date" %in% names(all_incomplete_stats)) {
        all_incomplete_stats$report_date <- as.Date(all_incomplete_stats$report_date)
    }

    if (verbose) cat("Combined rows:", nrow(all_incomplete_stats), " cols:", ncol(all_incomplete_stats), "\n")

    if (save) {
        dir.create(dirname(out_file), showWarnings = FALSE, recursive = TRUE)
        saveRDS(all_incomplete_stats, file = out_file)
    }

    invisible(all_incomplete_stats)
}




