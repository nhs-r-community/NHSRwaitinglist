library(dplyr)
library(readxl)
# TODO: Correct so that mean is over the last years data only

all_new_periods <- readRDS("data/all_national_new_periods.rds")

mean_rows_df <- all_new_periods %>%
  group_by(Provider_Code, Treatment_Function_Code, Provider_Name, Treatment_Function, Region_Code) %>%
  summarise(Mean_Arrival = mean(n, na.rm = TRUE), .groups = 'drop')
#View(mean_rows_df)

all_national_incomplete <- readRDS("data/all_national_incomplete.rds")

max_report_date <- max(all_national_incomplete$report_date, na.rm = TRUE)
incomplete_data <- dplyr::filter(all_national_incomplete, report_date == max_report_date)
#View(incomplete_data)


# remove arrived_before / arrive_since and aggregate arrivals by provider + treatment function
incomplete_data <- incomplete_data %>%
  select(-any_of(c("arrived_before", "arrive_since")))

# sum n per Provider_Code + Treatment_Function_Code and keep fixed columns (take first observed value)
incomplete_data <- incomplete_data %>%
  group_by(Provider_Code, Treatment_Function_Code) %>%
  summarise(
    n = sum(n, na.rm = TRUE),
    Provider_Name = first(Provider_Name),
    Treatment_Function = first(Treatment_Function),
    Region_Code = first(Region_Code),
    .groups = "drop"
  )

  # keep original 'n' for compatibility, also add a clearer "Queue_Size" column
incomplete_data <- incomplete_data %>%
    dplyr::mutate(Queue_Size = as.numeric(n))

# View(incomplete_data)

# also preserve the existing Mean_Arrival (mean of the original n values per group)
mean_arrival_df <- all_new_periods_clean %>%
  group_by(Provider_Code, Treatment_Function_Code) %>%
  summarise(Mean_Arrival = mean(n, na.rm = TRUE), .groups = "drop")

# final dataframe to use downstream (contains summed n plus Mean_Arrival and fixed columns)
mean_rows_df <- incomplete_data %>%
  left_join(mean_arrival_df, by = c("Provider_Code", "Treatment_Function_Code"))
View(mean_rows_df)

# Join mean_rows_df with incomplete_data, removing duplicate columns from incomplete_data
common_cols <- intersect(names(mean_rows_df), names(incomplete_data))
# Exclude all common columns except "Provider_Code"
cols_to_remove <- setdiff(common_cols, c("Provider_Code", "Treatment_Function_Code"))
incomplete_data_nodup <- incomplete_data[, !(names(incomplete_data) %in% cols_to_remove), drop = FALSE]
joined_data <- merge(
  mean_rows_df, 
  incomplete_data, 
  by = c("Provider_Code", "Treatment_Function_Code"), 
  all.x = TRUE
)
#View(joined_data)

joined_data <- subset(
  joined_data,
  Mean_Arrival != 0 & n != 0
)
#View(joined_data)


############# REPEAT OF CODE BLOCK ABOVE FOR JAN2024


# Import the Incomplete Provider Excel file
# TODO: Automate the file path to always get the latest file
incomplete_24_file_path <- "ent_data/2024_25_Provider/Incomplete-Provider-May24-XLSX-8M-revised.xlsx"
incomplete_24_data <- read_excel(incomplete_24_file_path)
incomplete_24_data <- incomplete_24_data[-c(1:11), ]
head(incomplete_24_data)
colnames(incomplete_24_data) <- gsub(" ", "_", as.character(unlist(incomplete_24_data[1, ])))
incomplete_24_data <- incomplete_24_data[-1, ]
colnames(incomplete_24_data)



incomplete_24_data <- incomplete_24_data[, -c(6:110)]
#View(incomplete_24_data)

df_2024 <- incomplete_24_data[, c(
    "Provider_Code",
    "Treatment_Function_Code",
    "Total_number_of_incomplete_pathways",
    "Total_within_18_weeks",
    "%_within_18_weeks",
    "92nd_percentile_waiting_time_(in_weeks)"
)]
colnames(df_2024)[colnames(df_2024) == "Total_number_of_incomplete_pathways"] <- "Queue_size_2024"
colnames(df_2024)[colnames(df_2024) == "Total_within_18_weeks"] <- "Total_within_18_weeks_2024"
colnames(df_2024)[colnames(df_2024) == "%_within_18_weeks"] <- "%_within_18_weeks_2024"
colnames(df_2024)[colnames(df_2024) == "92nd_percentile_waiting_time_(in_weeks)"] <- "92nd_percentile_2024"

colnames(df_2024)[colnames(df_2024) == "Total_within_18_weeks"] <- "Total_within_18_weeks_2024"
colnames(df_2024)[colnames(df_2024) == "%_within_18_weeks"] <- "%_within_18_weeks_2024"
View(df_2024)


# Join mean_rows_df with incomplete_data, removing duplicate columns from incomplete_data

common_cols <- intersect(names(mean_rows_df), names(incomplete_data))
# Exclude all common columns except "Provider_Code"
cols_to_remove <- setdiff(common_cols, c("Provider_Code", "Treatment_Function_Code"))
incomplete_data_nodup <- incomplete_data[, !(names(incomplete_data) %in% cols_to_remove), drop = FALSE]
joined_data <- merge(
  mean_rows_df,
  incomplete_data_nodup,
  by = c("Provider_Code", "Treatment_Function_Code"),
  all.x = TRUE
)#View(joined_data)

# Remove rows where Mean_Arrival is zero or Total_number_of_incomplete_pathways is zero
joined_data <- subset(
  joined_data,
  Mean_Arrival != 0 & n != 0
)

joined_data <- merge(joined_data, df_2024, by = c("Provider_Code", "Treatment_Function_Code"), all.x = TRUE)

# Calculate Relative_Improvement_in_18_weeks
joined_data$Total_within_18_weeks_2024 <- as.numeric(joined_data$Total_within_18_weeks_2024)
joined_data$Total_within_18_weeks <- as.numeric(joined_data$Total_within_18_weeks)
joined_data$Relative_Improvement_in_18_weeks <-
  (joined_data$Total_within_18_weeks_2024 - joined_data$Total_within_18_weeks) / joined_data$Total_within_18_weeks_2024

View(joined_data)


final_table <- joined_data
colnames_final_table <- names(final_table)
print(colnames_final_table)

final_table$Target_Q_Size <- round(as.numeric(final_table$Mean_Arrival) * (18 / (2.52*4.345)))

#View(final_table)
final_table$Queue_Ratio <- as.numeric(final_table$n) / final_table$Target_Q_Size
# Rename column "92nd_percentile_waiting_time_(in_weeks)" to "percentile_92" in percentile_92
# Example: Load or define percentile_92 before renaming its column
# percentile_92 <- read_excel("path/to/percentile_92.xlsx") # Uncomment and edit as needed

final_table$percentile_92 <- final_table$`92nd_percentile_waiting_time_(in_weeks)`

final_table$percentile_92 <- as.numeric(final_table$percentile_92)
final_table$`92nd_percentile_2024` <- as.numeric(final_table$`92nd_percentile_2024`)
final_table$percentile_improvement <- (final_table$percentile_92 - final_table$`92nd_percentile_2024`) 
final_table$percentile_relative_improvement <- (final_table$percentile_92 - final_table$`92nd_percentile_2024`) / final_table$`92nd_percentile_2024`

final_table$Percentile_Pressure <- round(as.numeric(final_table$percentile_92) / 18, 1)



final_table$`%_within_18_weeks` <- 100*as.numeric(final_table$`%_within_18_weeks`)

final_table$Mean_Arrival <- round(as.numeric(final_table$Mean_Arrival), 1)

final_table$Region_Code <- NULL

# Move Treatment_Function_Code to the final column
final_table$Treatment_Function_Code <- joined_data$Treatment_Function_Code

final_table$Percentile_92nd <- round(100*as.numeric(final_table$`%_within_18_weeks`), 2)

final_table$Median_Wait <- final_table$`Average_(median)_waiting_time_(in_weeks)`

final_table$Queue_Size <- final_table$Total_number_of_incomplete_pathways

final_table$Total_number_of_incomplete_pathways <- NULL

final_table$Total_52_plus_weeks <- NULL
final_table$Total_78_plus_weeks <- NULL
final_table$Total_65_plus_weeks <- NULL
final_table$`%_52_plus_weeks` <- NULL

final_table$Queue_Size <- as.numeric(final_table$Queue_Size)
final_table$Queue_size_2024 <- as.numeric(final_table$Queue_size_2024)

final_table$Queue_Size_Change <- final_table$Queue_Size - final_table$Queue_size_2024
final_table$`%_Queue_Size_Change` <- 100*(final_table$Queue_Size - final_table$Queue_size_2024) / final_table$Queue_size_2024


final_table$Mean_Arrival <- as.numeric(final_table$Mean_Arrival)
final_table$Mean_Departure <- final_table$Mean_Arrival - (final_table$Queue_Size - final_table$Queue_size_2024) / 12
final_table$Load <- final_table$Mean_Arrival/final_table$Mean_Departure

View(final_table)

final_table$Mean_Arrival_Rank <- NA_integer_
mask <- final_table$Treatment_Function_Code == "C_999"
final_table$Mean_Arrival_Rank[mask] <- rank(-final_table$Mean_Arrival[mask], ties.method = "first")

rownames(final_table) <- NULL
View(final_table)


# Custom numeric filter: show rows with value >= filter input
numeric_filter_method <- reactable::JS(
  "function(rows, id, filterValue) {\n" 
  , "  if (filterValue === undefined || filterValue === null || filterValue === '' || isNaN(Number(filterValue))) { return rows; }\n"
  , "  var num = Number(filterValue);\n"
  , "  return rows.filter(function(row) {\n"
  , "    var value = row.values[id];\n"
  , "    var valNum = Number(value);\n"
  , "    if (value === null || value === undefined || value === '' || isNaN(valNum) || !isFinite(valNum)) { return false; }\n"
  , "    return valNum >= num;\n"
  , "  });\n"
  , "}"
)



View(final_table)



# ONLY INCLUDE FULL ROWS
final_table_finite <- final_table[complete.cases(final_table), ]
# ...existing code...
numeric_cols <- sapply(final_table, is.numeric)
final_table_finite <- final_table[apply(final_table[, numeric_cols], 1, function(row) all(is.finite(row))), ]
final_table <- final_table_finite[final_table_finite$Queue_Size != 0, ]
# ...existing code...



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


finalized_table$Load <- round(as.numeric(finalized_table$Load), 2)
finalized_table$Queue_Size <- as.numeric(finalized_table$Queue_Size)
finalized_table$Queue_Ratio <- round(finalized_table$Queue_Ratio, 2)
finalized_table$percentile_92 <- round(as.numeric(finalized_table$percentile_92), 1)

View(finalized_table)

# Ensure first four columns are character, rest are numeric
for (i in 1:4) {
  finalized_table[[i]] <- as.character(finalized_table[[i]])
}
for (i in 5:ncol(finalized_table)) {
  finalized_table[[i]] <- as.numeric(finalized_table[[i]])
}

# Dynamic Rank numbering: remove any existing Row/Rank then add placeholder as first column
existing_rank_cols <- intersect(names(finalized_table), c("Row","Rank"))
if (length(existing_rank_cols)) finalized_table[existing_rank_cols] <- NULL
finalized_table <- cbind(Rank = NA_integer_, finalized_table)
## Remove any automatic row names so reactable doesn't render an extra index column
rownames(finalized_table) <- NULL

library(reactable)

# Custom color function for gradients (light blue to light red) from tom_report_3
gradient_color <- function(value, min, max) {
    if (is.na(value)) return(NA)
    # Interpolate between light blue (#add8e6) and light red (#ffb3b3)
    pal <- colorRampPalette(c("#add8e6", "#ffb3b3"))
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
library(htmlwidgets)
# Define columns that should use default string filter
# String filter columns, split to multiple lines for readability
string_filter_cols <- c(
  "Provider_Code",
  "Provider_Name",
  "Treatment_Function_Code",
  "Treatment_Function"
)


header_blues <- c("#4682B4", "#5A9BD5", "#7FB3D5", "#B3C6FF")

# Auto-insert Rank column if missing (supports running bottom block alone)
if (!"Rank" %in% names(finalized_table)) {
  finalized_table <- cbind(Rank = NA_integer_, finalized_table)
}

# Recompute header blue indices based on presence of Rank
has_rank <- identical(names(finalized_table)[1], "Rank")
if (has_rank) {
  base_pattern <- c(1, rep(1,4), rep(2,3), rep(3,3), rep(4,5))
} else {
  base_pattern <- c(rep(1,4), rep(2,3), rep(3,3), rep(4,5))
}
header_blue_indices <- rep(base_pattern, length.out = ncol(finalized_table))

# Helper to pick a blue shade based on column index
get_header_blue <- function(col) {
  idx <- which(names(finalized_table) == col)
  header_blues[header_blue_indices[idx]]
}

View(finalized_table)

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
  } else if (col %in% c("Provider_Code","Provider_Name","Treatment_Function_Code","Treatment_Function")) {
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
        if (is.na(value)) return(NULL)
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
          background = gradient_color(value, rng[1], rng[2]),
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
message("[diagnostic] First 5 columns (expect Rank/Row first): ", paste(utils::head(names(finalized_table),5), collapse=", "))

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

# Inject CSS counter-based row numbering so that visible rows are always
# numbered sequentially (resets automatically when filters change).
if (!"htmltools" %in% .packages()) {
  # ensure namespace loaded for tag helpers
  library(htmltools)
}
row_number_css <- htmltools::tags$style(HTML(
"#national_table .rt-tbody { counter-reset: rowNumber; }\n#national_table .rt-tbody .rt-tr-group { counter-increment: rowNumber; }\n#national_table .rt-tbody .rt-tr-group .rt-td:nth-child(1)::before {\n  content: counter(rowNumber);\n  font-weight: bold;\n  display: inline-block;\n  width: 100%;\n  color: inherit;\n}\n"
))
hide_row_filter_css <- htmltools::tags$style(HTML(
"#national_table .rt-th:nth-child(1) input { display: none !important; }\n"
))
tbl_widget <- htmlwidgets::prependContent(tbl_widget, list(row_number_css, hide_row_filter_css))

tbl_widget

Sys.setenv(RSTUDIO_PANDOC="/usr/local/bin") # or wherever pandoc is installed
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

save_and_clean_widget(tbl_widget, "ent_data/National_Data_Sept.html")

