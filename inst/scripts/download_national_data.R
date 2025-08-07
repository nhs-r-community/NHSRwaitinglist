#' ---
#' title: "National Data Download Utility"
#' ---
#'
#' # Purpose
#'
#' This file provides functions and utilities to download all national-level data required for analysis or reporting. 
#' It is designed to automate the retrieval of datasets from official sources, ensuring that the most up-to-date and comprehensive national data is available for downstream processing.
#'
#' ## Usage
#'
#' - Use the provided functions to initiate downloads of national datasets.
#' - Ensure you have the necessary permissions and network access to reach the data sources.
#' - Review the documentation for each function to understand input parameters and expected outputs.
#'
#' ## Note
#'
#' This script is intended for use in national data aggregation workflows and may require periodic updates to accommodate changes in data source URLs or formats.
#'

# TODO: consider limiting download to a date range, e.g. start_date and end_date

# ---- Libraries ----
library(rvest)
library(httr)

# ---- Functions ----

# Extract inner links from a page or file link
extract_inner_links <- function(link, pattern = "\\.xlsx?$", base_url = NULL) {
    if (!grepl("^http", link)) {
        if (!is.null(base_url)) {
            link <- url_absolute(link, base_url)
        }
    }
    if (grepl(pattern, link, ignore.case = TRUE)) {
        return(link)
    }
    tryCatch({
        page <- read_html(link)
        inner_links <- html_nodes(page, "a") %>% html_attr("href")
        inner_links <- inner_links[!is.na(inner_links)]
        inner_links <- inner_links[grepl(pattern, inner_links, ignore.case = TRUE)]
        inner_links <- sapply(inner_links, function(x) {
            if (!grepl("^http", x)) url_absolute(x, link) else x
        })
        return(inner_links)
    }, error = function(e) {
        return(character(0))
    })
}


# Create directory structure
create_folders <- function(folders = c(
    "raw_data/national_rtt/provider/",
    "raw_data/national_rtt/provider/admitted/",
    "raw_data/national_rtt/provider/non-admitted/",
    "raw_data/national_rtt/provider/new_periods/",
    "raw_data/national_rtt/provider/incomplete/",
    "raw_data/national_rtt/comissioner/",
    "raw_data/national_rtt/comissioner/admitted/",
    "raw_data/national_rtt/comissioner/non-admitted/",
    "raw_data/national_rtt/comissioner/new_periods/",
    "raw_data/national_rtt/comissioner/incomplete/",
    "raw_data/national_rtt/csv/",
    "raw_data/national_rtt/time_series/"
)) {
    for (folder in folders) {
        if (!dir.exists(folder)) dir.create(folder, recursive = TRUE)
    }
}

# Download files from links to a folder with progress bar
download_files <- function(links, folder) {
    total_files <- length(links)
    downloaded_count <- 0
    pb <- txtProgressBar(min = 0, max = total_files, style = 3)
    for (link in links) {
        destfile <- file.path(folder, basename(link))
        if (!file.exists(destfile)) {
            cat(sprintf("Downloading %s to %s\n", link, destfile))
            tryCatch({
                resp <- GET(link, write_disk(destfile, overwrite = TRUE), timeout(120))
                if (status_code(resp) != 200) {
                    cat(sprintf("Failed to download: %s (HTTP %d)\n", link, status_code(resp)))
                }
            }, error = function(e) {
                cat(sprintf("Error downloading %s: %s\n", link, e$message))
            })
        } else {
            cat(sprintf("File already exists: %s\n", destfile))
        }
        downloaded_count <- downloaded_count + 1
        setTxtProgressBar(pb, downloaded_count)
        cat(sprintf(" (%.1f%%)\n", 100 * downloaded_count / total_files))
    }
    close(pb)
}

# Extract all zip files in a folder
extract_zip_files <- function(folder) {
    zip_files <- list.files(folder, pattern = "\\.zip$", full.names = TRUE)
    for (zip_file in zip_files) {
        cat(sprintf("Extracting %s\n", zip_file))
        tryCatch({
            unzip(zip_file, exdir = folder)
        }, error = function(e) {
            cat(sprintf("Error extracting %s: %s\n", zip_file, e$message))
        })
    }
}

# Categorize Excel links into folders
categorize_links <- function(links) {
    categorized_links <- list()
    uncategorized_links <- c()
    for (link in links) {
        folder <- NA
        lnk <- tolower(link)
        if (grepl("non[-_]?admitted", lnk) || grepl("nonadmitted", lnk)) {
            if (grepl("provider", lnk)) {
                folder <- "raw_data/national_rtt/provider/non-admitted/"
            } else if (grepl("commiss", lnk)) {
                folder <- "raw_data/national_rtt/comissioner/non-admitted/"
            }
        } else if (grepl("timeseries", lnk)) {
            folder <- "raw_data/national_rtt/time_series/"
        } else if (grepl("csv", lnk)) {
            folder <- "raw_data/national_rtt/csv/"
        } else if (grepl("provider", lnk)) {
            if (grepl("admitted", lnk)) {
                folder <- "raw_data/national_rtt/provider/admitted/"
            } else if (grepl("new[_-]?period", lnk)) {
                folder <- "raw_data/national_rtt/provider/new_periods/"
            } else if (grepl("incomplete", lnk)) {
                folder <- "raw_data/national_rtt/provider/incomplete/"
            } else {
                folder <- "raw_data/national_rtt/provider/"
            }
        } else if (grepl("commiss", lnk)) {
            if (grepl("admitted", lnk)) {
                folder <- "raw_data/national_rtt/comissioner/admitted/"
            } else if (grepl("new[_-]?period", lnk)) {
                folder <- "raw_data/national_rtt/comissioner/new_periods/"
            } else if (grepl("incomplete", lnk)) {
                folder <- "raw_data/national_rtt/comissioner/incomplete/"
            } else {
                folder <- "raw_data/national_rtt/comissioner/"
            }
        }
        if (!is.na(folder)) {
            if (!folder %in% names(categorized_links)) categorized_links[[folder]] <- c()
            categorized_links[[folder]] <- c(categorized_links[[folder]], link)
        } else {
            uncategorized_links <- c(uncategorized_links, link)
        }
    }
    list(categorized = categorized_links, uncategorized = uncategorized_links)
}

# Remove unrevised files when a revised version exists
remove_unrevised_duplicates <- function(categorized_links) {
    unrevised_duplicates <- list()
    for (folder in names(categorized_links)) {
        links <- categorized_links[[folder]]
        links_xls <- links[grepl("\\.xls[x]?$", links, ignore.case = TRUE)]
        base_names <- sub("(-|_)?revised(?=\\.[^.]+$)", "", basename(links_xls), ignore.case = TRUE, perl = TRUE)
        revised_flags <- grepl("revised", basename(links_xls), ignore.case = TRUE)
        for (bn in unique(base_names)) {
            idx <- which(base_names == bn)
            if (any(revised_flags[idx]) && any(!revised_flags[idx])) {
                unrevised_links <- links_xls[idx[!revised_flags[idx]]]
                if (length(unrevised_links) > 0) {
                    if (!folder %in% names(unrevised_duplicates)) unrevised_duplicates[[folder]] <- c()
                    unrevised_duplicates[[folder]] <- c(unrevised_duplicates[[folder]], unrevised_links)
                    categorized_links[[folder]] <- setdiff(categorized_links[[folder]], unrevised_links)
                }
            }
        }
    }
    list(categorized = categorized_links, unrevised = unrevised_duplicates)
}

# Download categorized Excel files with progress bar
download_categorized_files <- function(categorized_links) {
    total_files <- sum(sapply(categorized_links, length))
    downloaded_count <- 0
    pb <- txtProgressBar(min = 0, max = total_files, style = 3)
    for (folder in names(categorized_links)) {
        links <- categorized_links[[folder]]
        for (link in links) {
            destfile <- file.path(folder, basename(link))
            if (!file.exists(destfile)) {
                cat(sprintf("Downloading %s to %s\n", link, destfile))
                tryCatch({
                    resp <- GET(link, write_disk(destfile, overwrite = TRUE), timeout(120))
                    if (status_code(resp) != 200) {
                        cat(sprintf("Failed to download: %s (HTTP %d)\n", link, status_code(resp)))
                    }
                }, error = function(e) {
                    cat(sprintf("Error downloading %s: %s\n", link, e$message))
                })
            } else {
                cat(sprintf("File already exists: %s\n", destfile))
            }
            downloaded_count <- downloaded_count + 1
            setTxtProgressBar(pb, downloaded_count)
            cat(sprintf(" (%.1f%%)\n", 100 * downloaded_count / total_files))
        }
    }
    close(pb)
}


download_national_data <- function(
    rtt_url = "https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/",
    provider_or_commissioner = c("Provider", "Comissioner") # Download both by default
) {
    provider_or_commissioner <- match.arg(provider_or_commissioner, choices = c("Provider", "Comissioner"), several.ok = TRUE)
    
    getwd()
    if (!grepl("NHSRwaitinglist$", getwd())) {
        warning("Current working directory is not 'NHSRwaitinglist'. Download location may be incorrect.")
    }

    cat("Downloading...\n")
    cat("All data is approx 14GB...\n")


    # Create folders: comissioner, provider, timeseries and csv files
    create_folders()    

    # Extract pages from the main RTT page
    page <- read_html(rtt_url)
    links <- html_nodes(page, "a") %>% html_attr("href")
    links <- links[!is.na(links)]
    links <- links[grepl("rtt-data-", links) & grepl("statistical-work-areas", links)]
    links <- unique(links)

    # Extract Excel links within the each year
    all_excel_links <- unlist(lapply(links, extract_inner_links, pattern = "\\.xlsx?$", base_url = rtt_url))
    all_excel_links <- unique(all_excel_links)


    timeseries_links <- all_excel_links[grepl("timeseries", all_excel_links, ignore.case = TRUE)]
    # Download timeseries links to the time_series folder
    if (length(timeseries_links) > 0) {
        download_categorized_files(list("raw_data/national_rtt/time_series/" = timeseries_links))
    }


    # Extract CSV links within the each year (csv's are in a zip folder)
    all_csv_links <- unlist(lapply(links, extract_inner_links, pattern = "\\.zip?$", base_url = rtt_url))
    all_csv_links <- unique(all_csv_links)

    # Download all CSV files into raw_data/national_rtt/csv/
    print("Downloading CSV files...")
    csv_folder <- "raw_data/national_rtt/csv/"
    download_files(all_csv_links, csv_folder)
    extract_zip_files(csv_folder)

    # Allocate links to folders
    # Filtering by provider or commissioner
    cat_links <- categorize_links(all_excel_links)
    categorized_links <- cat_links$categorized
    uncategorized_links <- cat_links$uncategorized

    keep_folders <- character()
    if ("Provider" %in% provider_or_commissioner) {
        keep_folders <- c(keep_folders, grep("provider", names(categorized_links), value = TRUE))
    }
    if ("Comissioner" %in% provider_or_commissioner) {
        keep_folders <- c(keep_folders, grep("comissioner", names(categorized_links), value = TRUE))
    }
    categorized_links <- categorized_links[keep_folders]

    cat("Links categorized by folder:\n")
    for (f in names(categorized_links)) {
        cat(sprintf("%s: %d links\n", f, length(categorized_links[[f]])))
    }
    if (length(uncategorized_links) > 0) {
        cat("\nLinks not categorized into any folder:\n")
        print(uncategorized_links)
    } else {
        cat("\nAll links categorized.\n")
    }

    dup_result <- remove_unrevised_duplicates(categorized_links)
    categorized_links <- dup_result$categorized
    unrevised_duplicates <- dup_result$unrevised

    cat("\nUnrevised files with a revised version available (moved to unrevised_duplicates):\n")
    for (f in names(unrevised_duplicates)) {
        cat(sprintf("%s: %d links\n", f, length(unrevised_duplicates[[f]])))
    }

    # Download categorized Excel files
    download_categorized_files(categorized_links)
}

