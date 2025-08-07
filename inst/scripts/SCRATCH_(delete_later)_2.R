# Download excel
# HERE: create a download script for the national data from the NHS England website
# TODO: TIDY THIS UP

#- Create structure
# raw_data/ -- rtt_data/ provider/ admitted \ non-admitted\ incomplete/  





getwd()
if (!grepl("NHSRwaitinglist$", getwd())) {
    warning("Current working directory is not 'NHSRwaitinglist'. Download location may be incorrect.")
}


rtt_url <- "https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/"

start_data <- "2024-04-01"
end_data <- "2025-03-31"
providered_or_commissioner <- "Provider" # or "Commissioner"

# Create directory structure for raw_data and subfolders
folders_to_create <- c(
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
)

for (folder in folders_to_create) {
  if (!dir.exists(folder)) dir.create(folder, recursive = TRUE)
}

# List all links on the RTT waiting times page
library(rvest)
page <- read_html(rtt_url)
links <- html_nodes(page, "a") %>% html_attr("href")
links <- links[!is.na(links)] # Remove NAs
links <- links[grepl("rtt-data-", links) & grepl("statistical-work-areas", links)]
links <- unique(links) # Remove repeated links

print(links)



# For each link, if it's an HTML page, extract links within it; otherwise, keep as is
extract_inner_links <- function(link, pattern = "\\.xlsx?$") {
    # Make full URL if needed
    if (!grepl("^http", link)) {
        link <- url_absolute(link, rtt_url)
    }
    # If it's a file matching the pattern, return as is
    if (grepl(pattern, link, ignore.case = TRUE)) {
        return(link)
    }
    # If it's an HTML page, extract matching links within
    tryCatch({
        page <- read_html(link)
        inner_links <- html_nodes(page, "a") %>% html_attr("href")
        inner_links <- inner_links[!is.na(inner_links)]
        # Filter for files matching the pattern
        inner_links <- inner_links[grepl(pattern, inner_links, ignore.case = TRUE)]
        # Make full URLs
        inner_links <- sapply(inner_links, function(x) {
            if (!grepl("^http", x)) url_absolute(x, link) else x
        })
        return(inner_links)
    }, error = function(e) {
        return(character(0))
    })
}

# Apply extract_inner_links to all links for Excel files
all_excel_links <- unlist(lapply(links, extract_inner_links, pattern = "\\.xlsx?$"))
all_excel_links <- unique(all_excel_links)
print(head(all_excel_links))

# Print all links that contain the text "Timeseries" (case-insensitive)
timeseries_links <- all_excel_links[grepl("timeseries", all_excel_links, ignore.case = TRUE)]
print(timeseries_links)


# Apply extract_inner_links to all links for CSV files
all_csv_links <- unlist(
    lapply(
        links,
        extract_inner_links,
        pattern = "\\.zip?$"
    )
)
all_csv_links <- unique(all_csv_links)
print(head(all_csv_links))

# Download all CSV files into raw_data/national_rtt/csv/
csv_folder <- "raw_data/national_rtt/csv/"
for (link in all_csv_links) {
    destfile <- file.path(csv_folder, basename(link))
    if (!file.exists(destfile)) {
        cat(sprintf("Downloading CSV %s to %s\n", link, destfile))
        tryCatch({
            resp <- GET(link, write_disk(destfile, overwrite = TRUE), timeout(120))
            if (status_code(resp) != 200) {
                cat(sprintf("Failed to download: %s (HTTP %d)\n", link, status_code(resp)))
            }
        }, error = function(e) {
            cat(sprintf("Error downloading %s: %s\n", link, e$message))
        })
    } else {
        cat(sprintf("CSV file already exists: %s\n", destfile))
    }
}

# Extract all zip files in the CSV folder
csv_zip_files <- list.files("raw_data/national_rtt/csv/", pattern = "\\.zip$", full.names = TRUE)
for (zip_file in csv_zip_files) {
    cat(sprintf("Extracting %s\n", zip_file))
    tryCatch({
        unzip(zip_file, exdir = "raw_data/national_rtt/csv/")
    }, error = function(e) {
        cat(sprintf("Error extracting %s: %s\n", zip_file, e$message))
    })
}

# Categorize Excel links into folders
categorized_links <- list()
uncategorized_links <- c()

for (link in all_excel_links) {
    folder <- NA
    # Lowercase for easier matching
    lnk <- tolower(link)
    # NonAdmitted links should always go to non-admitted folder
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

# Print summary
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

View(categorized_links)

# Identify and separate unrevised files when a revised version exists
unrevised_duplicates <- list()

for (folder in names(categorized_links)) {
    links <- categorized_links[[folder]]
    # Only consider .xls or .xlsx files
    links_xls <- links[grepl("\\.xls[x]?$", links, ignore.case = TRUE)]
    # Find base names (remove "-revised" or "revised" before extension)
    base_names <- sub("(-|_)?revised(?=\\.[^.]+$)", "", basename(links_xls), ignore.case = TRUE, perl = TRUE)
    # Find which base names have both revised and unrevised
    revised_flags <- grepl("revised", basename(links_xls), ignore.case = TRUE)
    for (bn in unique(base_names)) {
        idx <- which(base_names == bn)
        if (any(revised_flags[idx]) && any(!revised_flags[idx])) {
            # Move unrevised to separate list
            unrevised_links <- links_xls[idx[!revised_flags[idx]]]
            if (length(unrevised_links) > 0) {
                if (!folder %in% names(unrevised_duplicates)) unrevised_duplicates[[folder]] <- c()
                unrevised_duplicates[[folder]] <- c(unrevised_duplicates[[folder]], unrevised_links)
                # Remove from categorized_links
                categorized_links[[folder]] <- setdiff(categorized_links[[folder]], unrevised_links)
            }
        }
    }
}

cat("\nUnrevised files with a revised version available (moved to unrevised_duplicates):\n")
for (f in names(unrevised_duplicates)) {
    cat(sprintf("%s: %d links\n", f, length(unrevised_duplicates[[f]])))
}
# Download all categorized Excel files into their respective folders
library(httr)

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

