
getwd()
all_data <- readRDS("ent_data/all_ent_data.rds")
View(all_data)
source("R/utils_dates.R")

# Import the Incomplete Provider Excel file
incomplete_file_path <- "raw_data/national_rtt/provider/incomplete/Incomplete-Provider-May25-XLSX-9M-32711.xlsx"

report_date <- excel_report_date(incomplete_file_path) %>% first_day_of_month


incomplete_data <- read_excel(incomplete_file_path)
incomplete_data <- incomplete_data[-c(1:11), ]
head(incomplete_data)
colnames(incomplete_data) <- gsub(" ", "_", as.character(unlist(incomplete_data[1, ])))
incomplete_data <- incomplete_data[-1, ]
colnames(incomplete_data)




# remove columns after column 6 up to and including the first column whose name contains "_plus"
plus_col <- which(grepl("_plus", colnames(incomplete_data), ignore.case = TRUE))[1L]
if (!is.na(plus_col) && plus_col > 6L) {
    cols_to_remove <- seq.int(6L, plus_col)
    incomplete_data <- incomplete_data[, -cols_to_remove, drop = FALSE]
} else {
    incomplete_data <- incomplete_data[, -c(6:110)]
}

incomplete_data$report_date <- report_date

View(incomplete_data)



