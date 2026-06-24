# This script generates a national-level summary table of Waiting List Data

# The script assumes that the following files are present:
# - data/all_national_new_periods.rds
# - data/all_national_incomplete_stats.rds
# These can be generated using the scripts:
# - inst/scripts/download_national_data.R
# - inst/scripts/process_national_data.R

# Below we :
# 1. Load the preprocessed data
# 2a. Extract the latest report dates for incompletes
# 2b. And we extract the same report from a year ago
# 3. We compute mean arrivals per provider
# 4. We then combine and process rows to generate a final table
# 5. Finally we render the table using reactable adding filtering and sorting

########################
# 0. Required libraries
########################
library(readxl)
library(dplyr)
library(tidyr)
library(reactable)
library(htmlwidgets)
library(htmltools)
################################
# 1. Load the preprocessed data
################################

all_national_incomplete <- readRDS("data/all_national_incomplete_stats.rds")
all_national_new_periods <- readRDS("data/all_national_new_periods.rds")

#########################################################
# 2. We extract the report for incompletes
#########################################################
# TODO: Correct so that mean is over the last years data only
# TODO: Don't name things 2024 just say a year ago


# There are some old labels (when Area Code and 95th percentile was used)
# Remove Area_Team_Code if present to avoid carrying it through joins
all_national_incomplete <- all_national_incomplete %>% select(-any_of("Area_Team_Code"))
# Drop 95th percentile column(s) if present (handle both common name variants)
cols_95 <- grep("(?i)95th", names(all_national_incomplete), value = TRUE, perl = TRUE)
if (length(cols_95) > 0) {
  all_national_incomplete <- all_national_incomplete %>% select(-any_of(cols_95))
}
# Relabel some columns from national format
# Rename as Queue_Size for clarity
all_national_incomplete <- all_national_incomplete %>%
  rename(Queue_Size = Total_number_of_incomplete_pathways)
all_national_incomplete$Queue_Size <- as.numeric(all_national_incomplete$Queue_Size)

#########################################################
# 2a. The latest report date
#########################################################

max_report_date <- max(all_national_incomplete$report_date, na.rm = TRUE)
incomplete_data <- dplyr::filter(all_national_incomplete, report_date == max_report_date)


##############################################################
# 2b. The same report date from a year ago (approx 52 weeks)
##############################################################

# compute the date 12 months before the latest report_date (handles Date/POSIX)
one_year_ago <- seq(as.Date(max_report_date), length = 2, by = "-12 months")[2]
# extract rows for that report date (year-ago snapshot)
incomplete_data_year_ago <- dplyr::filter(all_national_incomplete, report_date == one_year_ago)

# We don't need all columns so we select and rename what we need
a_year_ago <- incomplete_data_year_ago[, c(
  "Provider_Code",
  "Treatment_Function_Code",
  "Queue_Size",
  "Total_within_18_weeks",
  "%_within_18_weeks",
  "92nd_percentile_waiting_time_(in_weeks)"
)]
colnames(a_year_ago)[colnames(a_year_ago) == "Queue_Size"] <- "Queue_size_year_ago"
colnames(a_year_ago)[colnames(a_year_ago) == "Total_within_18_weeks"] <- "Total_within_18_weeks_year_ago"
colnames(a_year_ago)[colnames(a_year_ago) == "%_within_18_weeks"] <- "%_within_18_weeks_year_ago"
colnames(a_year_ago)[colnames(a_year_ago) == "92nd_percentile_waiting_time_(in_weeks)"] <- "92nd_percentile_year_ago"
colnames(a_year_ago)[colnames(a_year_ago) == "Total_within_18_weeks"] <- "Total_within_18_weeks_year_ago"
colnames(a_year_ago)[colnames(a_year_ago) == "%_within_18_weeks"] <- "%_within_18_weeks_year_ago"
colnames(a_year_ago)[colnames(a_year_ago) == "92nd_percentile_waiting_time_(in_weeks)"] <- "92nd_percentile_year_ago"

# View(a_year_ago)


##########################################
# 3. We compute mean arrivals per provider
##########################################

mean_rows_df <- all_national_new_periods %>%
  filter(
    as.Date(report_date) >= as.Date(one_year_ago),
    as.Date(report_date) <= as.Date(max_report_date)
  ) %>%
  group_by(
    Provider_Code,
    Treatment_Function_Code,
    Provider_Name,
    Treatment_Function,
    Region_Code
  ) %>%
  summarise(
    Mean_Arrival = mean(n, na.rm = TRUE),
    .groups = "drop"
  )

###############################################################
# 4. We then combine and process to generate a final table
###############################################################

# Join the incompletes data with the arrival rate data
joined_data <- incomplete_data %>%
  left_join(mean_rows_df, by = c("Provider_Code", "Treatment_Function_Code"))

# remove duplicated columns and zero entries
joined_data <- joined_data[, !grepl("\\.y$", names(joined_data)), drop = FALSE]
names(joined_data) <- sub("\\.x$", "", names(joined_data))
#
joined_data <- subset(
  joined_data,
  Mean_Arrival != 0 & Queue_Size != 0
)

# Now we merge with date from a year-ago
joined_data <- merge(joined_data, a_year_ago, by = c("Provider_Code", "Treatment_Function_Code"), all.x = TRUE)

# Call it final_table
final_table <- joined_data
View(final_table)

# Remove unwanted columns
final_table$Total_52_plus_weeks <- NULL
final_table$Total_78_plus_weeks <- NULL
final_table$Total_65_plus_weeks <- NULL
final_table$`%_52_plus_weeks` <- NULL
final_table$Region_Code <- NULL
final_table$`Average_(median)_waiting_time_(in_weeks)` <- NULL
final_table$report_date <- NULL
final_table$source_file <- NULL

# Make sure the types of columns are correct
final_table[, 1:4] <- lapply(final_table[, 1:4], function(x) as.character(x))
final_table[, 5:ncol(final_table)] <- lapply(final_table[, 5:ncol(final_table)], function(x) as.numeric(as.character(x)))

# Calculate Improvement within 18 weeks
final_table$Relative_Improvement_in_18_weeks <-
  (final_table$Total_within_18_weeks_year_ago - final_table$Total_within_18_weeks) / final_table$Total_within_18_weeks_year_ago

# Calculate Improvement in 92nd percentile
final_table$percentile_improvement <- (final_table$percentile_92 - final_table$`92nd_percentile_year_ago`)

# Calculate Relative Improvement in 92nd percentile
final_table$percentile_relative_improvement <- (final_table$percentile_92 - final_table$`92nd_percentile_year_ago`) / final_table$`92nd_percentile_year_ago`

# Calculate Changes in Queue Size
final_table$Queue_Size_Change <- final_table$Queue_Size - final_table$Queue_size_year_ago
final_table$`%_Queue_Size_Change` <- 100 * (final_table$Queue_Size - final_table$Queue_size_year_ago) / final_table$Queue_size_year_ago


# Calculate Target Queue Size
final_table$Target_Q_Size <- round(as.numeric(final_table$Mean_Arrival) * (18 / (2.52 * 4.345)))

# Calculate Queue Ratio
final_table$Queue_Ratio <- as.numeric(final_table$Queue_Size) / final_table$Target_Q_Size

# Calculated departure rate and Load
final_table$Mean_Departure <- final_table$Mean_Arrival - (final_table$Queue_Size - final_table$Queue_size_year_ago) / 12
final_table$Load <- final_table$Mean_Arrival / final_table$Mean_Departure

# Shorten some titles
final_table$percentile_92 <- final_table$`92nd_percentile_waiting_time_(in_weeks)`

# Round numbers a bit for presentation purposes
final_table$Percentile_Pressure <- round(as.numeric(final_table$percentile_92) / 18, 1)
final_table$`%_within_18_weeks` <- 100 * as.numeric(final_table$`%_within_18_weeks`)
final_table$Mean_Arrival <- round(as.numeric(final_table$Mean_Arrival), 1)
final_table$`%_within_18_weeks` <- round(as.numeric(final_table$`%_within_18_weeks`), 1)
final_table$Load <- round(as.numeric(final_table$Load), 2)
final_table$Queue_Ratio <- round(final_table$Queue_Ratio, 2)
final_table$percentile_92 <- round(as.numeric(final_table$percentile_92), 1)

# reset rows
rownames(final_table) <- NULL


# Drop unwanted columns
cols_to_remove <- c(
  "95th_percentile_waiting_time_(in_weeks)",
  "Area_Team_Code",
  "Mean_Arrival_Rank"
)
cols_present <- intersect(names(final_table), cols_to_remove)
if (length(cols_present) > 0) {
  final_table[cols_present] <- NULL
}

# ONLY INCLUDE FULL ROWS WITH FINITE VALUES
final_table_finite <- final_table[complete.cases(final_table), ]
numeric_cols <- sapply(final_table, is.numeric)
final_table_finite <- final_table[apply(final_table[, numeric_cols], 1, function(row) all(is.finite(row))), ]
final_table <- final_table_finite[final_table_finite$Queue_Size != 0, ]

# Reorder columns to put Treatment_Function_Code last and include percentile_relative_improvement
finalized_table <- final_table[, c(
  "Provider_Code",
  "Provider_Name",
  "Treatment_Function_Code",
  "Treatment_Function",
  "Queue_Size",
  "Target_Q_Size",
  "Queue_Ratio",
  "percentile_92",
  "%_within_18_weeks",
  "Percentile_Pressure",
  "Queue_Size_Change",
  "Relative_Improvement_in_18_weeks",
  "%_Queue_Size_Change",
  "percentile_improvement",
  "Load"
)]


# View(finalized_table)

# # Ensure first four columns are character, rest are numeric
# for (i in 1:4) {
#   finalized_table[[i]] <- as.character(finalized_table[[i]])
# }
# for (i in 5:ncol(finalized_table)) {
#   finalized_table[[i]] <- as.numeric(finalized_table[[i]])
# }

View(finalized_table)


##################################################################
# 5. Render the table using reactable adding filtering and sorting
##################################################################


# Custom numeric filter: show rows with value >= filter input
numeric_filter_method <- reactable::JS(
  "function(rows, id, filterValue) {\n",
  "  if (filterValue === undefined || filterValue === null || filterValue === '' || isNaN(Number(filterValue))) { return rows; }\n",
  "  var num = Number(filterValue);\n",
  "  return rows.filter(function(row) {\n",
  "    var value = row.values[id];\n",
  "    var valNum = Number(value);\n",
  "    if (value === null || value === undefined || value === '' || isNaN(valNum) || !isFinite(valNum)) { return false; }\n",
  "    return valNum >= num;\n",
  "  });\n",
  "}"
)


# Dynamic Rank numbering: remove any existing Row/Rank then add placeholder as first column
existing_rank_cols <- intersect(names(finalized_table), c("Row", "Rank"))
if (length(existing_rank_cols)) finalized_table[existing_rank_cols] <- NULL
finalized_table <- cbind(Rank = NA_integer_, finalized_table)
## Remove any automatic row names so reactable doesn't render an extra index column
rownames(finalized_table) <- NULL


# Custom color function for gradients (light blue to light red) from tom_report_3
gradient_color <- function(value, min, max) {
  if (is.na(value)) {
    return(NA)
  }
  # Interpolate between light blue (#add8e6) and light red (#ffb3b3)
  pal <- colorRampPalette(c("#add8e6", "#ffb3b3"))
  n <- 100
  colors <- pal(n)
  idx <- as.integer((value - min) / (max - min) * (n - 1)) + 1
  colors[pmax(pmin(idx, n), 1)]
}

# Reverse gradient (light red to light blue) so higher values are blue
gradient_color_rev <- function(value, min, max) {
  if (is.na(value)) {
    return(NA)
  }
  pal <- colorRampPalette(c("#ffb3b3", "#add8e6"))
  n <- 100
  colors <- pal(n)
  idx <- as.integer((value - min) / (max - min) * (n - 1)) + 1
  colors[pmax(pmin(idx, n), 1)]
}


# Gradient color by rank: 1st is red, last is blue (same palette as above)
gradient_color_by_rank <- function(values) {
  pal <- colorRampPalette(c("#ffb3b3", "#add8e6")) # Red to blue
  n <- length(values)
  colors <- rep(NA_character_, n)
  valid <- which(is.finite(values) & !is.na(values))
  if (length(valid) > 0) {
    # Rank so that highest value is rank 1 (red), lowest is last (blue)
    ranks <- rank(-values[valid], ties.method = "first")
    pal_colors <- pal(length(valid))
    colors[valid] <- pal_colors[ranks]
  }
  colors
}


# Calculate min/max for relevant columns
min_queue_ratio <- min(finalized_table$Queue_Ratio[is.finite(finalized_table$Queue_Ratio)], na.rm = TRUE)
max_queue_ratio <- max(finalized_table$Queue_Ratio[is.finite(finalized_table$Queue_Ratio)], na.rm = TRUE)
min_percentile_pressure <- min(finalized_table$Percentile_Pressure[is.finite(finalized_table$Percentile_Pressure)], na.rm = TRUE)
max_percentile_pressure <- max(finalized_table$Percentile_Pressure[is.finite(finalized_table$Percentile_Pressure)], na.rm = TRUE)
min_queue_size <- min(finalized_table$Queue_Size[is.finite(finalized_table$Queue_Size)], na.rm = TRUE)
max_queue_size <- max(finalized_table$Queue_Size[is.finite(finalized_table$Queue_Size)], na.rm = TRUE)
min_queue_size_change_pct <- min(finalized_table$`%_Queue_Size_Change`[is.finite(finalized_table$`%_Queue_Size_Change`)], na.rm = TRUE)
max_queue_size_change_pct <- max(finalized_table$`%_Queue_Size_Change`[is.finite(finalized_table$`%_Queue_Size_Change`)], na.rm = TRUE)

# Define columns that should use default string filter
# String filter columns, split to multiple lines for readability
string_filter_cols <- c(
  "Provider_Code",
  "Provider_Name",
  "Treatment_Function_Code",
  "Treatment_Function"
)

# Set headers blue shades pattern
header_blues <- c("#4682B4", "#5A9BD5", "#7FB3D5", "#B3C6FF")

# Auto-insert Rank column if missing (supports running bottom block alone)
if (!"Rank" %in% names(finalized_table)) {
  finalized_table <- cbind(Rank = NA_integer_, finalized_table)
}

# Recompute header blue indices based on presence of Rank
has_rank <- identical(names(finalized_table)[1], "Rank")
if (has_rank) {
  base_pattern <- c(1, rep(1, 4), rep(2, 3), rep(3, 3), rep(4, 5))
} else {
  base_pattern <- c(rep(1, 4), rep(2, 3), rep(3, 3), rep(4, 5))
}
header_blue_indices <- rep(base_pattern, length.out = ncol(finalized_table))

# Helper to pick a blue shade based on column index
get_header_blue <- function(col) {
  idx <- which(names(finalized_table) == col)
  header_blues[header_blue_indices[idx]]
}

# View(finalized_table)

###############################################
## Build columns list with appropriate filterMethod
columns_list <- lapply(seq_along(names(finalized_table)), function(i) {
  col <- names(finalized_table)[i]
  header_bg <- header_blues[header_blue_indices[i]]
  if (col == "Rank") {
    # Per-page numbering (simpler & reliable); will restart each page
    colDef(
      name = "Rank",
      # Use CSS counter for numbering so that numbers always re-sequence
      # after filtering/sorting (no gaps, restart at 1 for visible rows on each page)
      # The cell content itself is left blank; numbers injected via ::before.
      cell = reactable::JS("function(cellInfo){ return ''; }"),
      sortable = FALSE,
      filterable = FALSE,
      width = 65,
      align = "center",
      sticky = "left",
      style = function(value) list(fontWeight = "bold"),
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      )
    )
  } else if (col %in% c("Provider_Code", "Provider_Name", "Treatment_Function_Code", "Treatment_Function")) {
    # Key string filter columns
    colDef(
      filterable = TRUE,
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      )
    )
  } else if (col == "Queue_Ratio") {
    queue_ratio_colours <- gradient_color_by_rank(finalized_table$Queue_Ratio)
    colDef(
      style = function(value, index) {
        list(background = queue_ratio_colours[index], fontWeight = "bold")
      },
      format = colFormat(digits = 2),
      name = "Queue Ratio",
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      ),
      filterable = TRUE,
      filterMethod = numeric_filter_method
    )
  } else if (col == "Queue_Size") {
    colDef(
      style = function(value) {
        list(fontWeight = "bold")
      },
      name = "Queue Size",
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      ),
      filterable = TRUE,
      filterMethod = numeric_filter_method
    )
  } else if (col == "Target_Q_Size") {
    colDef(
      style = function(value) {
        list(fontWeight = "bold")
      },
      name = "Target Q Size",
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      ),
      filterable = TRUE,
      filterMethod = numeric_filter_method
    )
  } else if (col == "Percentile_Pressure") {
    colDef(
      style = function(value) {
        list(
          background = gradient_color(
            value,
            min_percentile_pressure,
            max_percentile_pressure
          ),
          fontWeight = "bold"
        )
      },
      format = colFormat(digits = 2),
      name = "Percentile Pressure",
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      ),
      filterable = TRUE,
      filterMethod = numeric_filter_method
    )
  } else if (col == "Queue_Size_Change") {
    colDef(
      format = colFormat(digits = 0),
      name = "Queue Size Change",
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      ),
      filterable = TRUE,
      filterMethod = numeric_filter_method
    )
  } else if (col == "%_Queue_Size_Change") {
    colDef(
      format = colFormat(digits = 2),
      name = "% Queue Size Change",
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      ),
      filterable = TRUE,
      filterMethod = numeric_filter_method
    )
  } else if (col == "Load") {
    colDef(
      style = function(value) {
        if (is.na(value)) {
          return(NULL)
        }
        if (value > 1) {
          list(background = "#ffb3b3", fontWeight = "bold")
        } else {
          list(background = "#b3ffb3", fontWeight = "bold")
        }
      },
      format = colFormat(digits = 2),
      name = "Load",
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      ),
      filterable = TRUE,
      filterMethod = numeric_filter_method
    )
  } else if (col == "%_within_18_weeks") {
    colDef(
      style = function(value) {
        rng <- range(finalized_table$`%_within_18_weeks`, na.rm = TRUE)
        list(
          background = gradient_color_rev(value, rng[1], rng[2]),
          fontWeight = "bold"
        )
      },
      name = "% within 18 Weeks",
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      ),
      filterable = TRUE,
      filterMethod = numeric_filter_method
    )
  } else if (col == "Relative_Improvement_in_18_weeks") {
    colDef(
      format = colFormat(digits = 2),
      name = "Relative Improvement in 18 Weeks",
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      ),
      filterable = TRUE,
      filterMethod = numeric_filter_method
    )
  } else if (col == "percentile_improvement") {
    colDef(
      format = colFormat(digits = 2),
      name = "Percentile Change",
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      ),
      filterable = TRUE,
      filterMethod = numeric_filter_method
    )
  } else {
    colDef(
      filterable = TRUE,
      headerStyle = list(
        background = header_bg,
        color = "white",
        fontWeight = "bold"
      )
    )
  }
})
names(columns_list) <- names(finalized_table)

# Diagnostic message so user can confirm Row exists before rendering
# message("[diagnostic] First 5 columns (expect Rank/Row first): ", paste(utils::head(names(finalized_table),5), collapse=", "))

# Create the reactable widget with filters enabled
tbl_widget <- reactable(
  finalized_table,
  sortable = TRUE,
  filterable = TRUE,
  defaultSorted = "Provider_Code",
  elementId = "national_table",
  highlight = TRUE,
  bordered = TRUE,
  striped = TRUE,
  resizable = TRUE,
  defaultPageSize = 250,
  pageSizeOptions = c(25, 50, 100, 250, 500),
  defaultColDef = colDef(
    align = "center",
    minWidth = 100,
    headerStyle = list(
      background = "#4682B4",
      color = "white",
      fontWeight = "bold",
      fontSize = "1.1em"
    ),
    filterable = TRUE
  ),
  columns = columns_list,
  theme = reactableTheme(
    borderColor = "#4682B4",
    stripedColor = "#f0f8ff",
    highlightColor = "#e6f7ff",
    cellPadding = "8px 12px",
    style = list(
      fontFamily = "Segoe UI, Arial, sans-serif",
      fontSize = "1em"
    ),
    inputStyle = list(color = "black", background = "white")
  )
)


# Bits and pieces to improve appearance
# Add CSS for row numbering using counter (works with filtering/sorting)
# Also hide the filter box for the Rank column
row_number_css <- htmltools::tags$style(HTML(
  "#national_table .rt-tbody { counter-reset: rowNumber; }\n#national_table .rt-tbody .rt-tr-group { counter-increment: rowNumber; }\n#national_table .rt-tbody .rt-tr-group .rt-td:nth-child(1)::before {\n  content: counter(rowNumber);\n  font-weight: bold;\n  display: inline-block;\n  width: 100%;\n  color: inherit;\n}\n"
))
hide_row_filter_css <- htmltools::tags$style(HTML(
  "#national_table .rt-th:nth-child(1) input { display: none !important; }\n"
))


tbl_widget <- htmlwidgets::prependContent(tbl_widget, list(row_number_css, hide_row_filter_css))

tbl_widget

Sys.setenv(RSTUDIO_PANDOC = "/usr/local/bin") # or wherever pandoc is installed
# Save the widget to a temporary file, read it, and remove unwanted header lines
save_and_clean_widget <- function(widget, file) {
  tmpfile <- tempfile(fileext = ".html")
  saveWidget(widget, tmpfile, selfcontained = TRUE)
  lines <- readLines(tmpfile, warn = FALSE)
  # Remove lines that start with "---" or contain "title:" or "header-include:" or "head:"
  lines <- lines[!grepl("^---|^title:|^header-include:|^head:", lines)]
  writeLines(lines, file)
  unlink(tmpfile)
}

date_str <- format(max_report_date, "%Y-%m")
out_dir <- "inst/examples/national_table/national_table_output"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
outfile <- file.path(out_dir, paste0("National_Data_", date_str, ".html"))
save_and_clean_widget(tbl_widget, outfile)
