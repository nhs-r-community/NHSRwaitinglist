#' @title Calculate some stats about removals from histogram data
#'
#' @description Calculate removal statistics from a histogram containing multiple
#'   report dates. Compares consecutive snapshots to estimate removal rates over time.
#'
#' @param wl_hist data.frame. A histogram with columns: arrival_since, arrival_before,
#'   n, and report_date. Must contain at least 2 unique report_date values.
#' @param start_date Date or character (in format 'YYYY-MM-DD'); The start date
#'   to calculate from. If NULL, uses the earliest report_date in the histogram.
#' @param end_date Date or character (in format 'YYYY-MM-DD'); The end date to
#'   calculate to. If NULL, uses the latest report_date in the histogram.
#'
#' @return A data.frame with the following summary statistics on
#'   removals/capacity:
#'
#' \describe{
#'   \item{capacity_weekly}{Numeric. Mean number of removals from the waiting
#'     list per week, averaged across all consecutive time periods.}
#'   \item{capacity_daily}{Numeric. Mean number of removals from the waiting
#'     list per day, averaged across all consecutive time periods.}
#'   \item{capacity_cov}{Numeric. Coefficient of variation in the time between
#'     removals from the waiting list (currently fixed at 1).}
#'   \item{removal_count}{Numeric. Total number of removals from the waiting
#'     list over the full time period.}
#' }
#'
#' @importFrom dplyr filter rename full_join mutate select arrange
#' @importFrom tidyr replace_na
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Histogram with multiple report dates
#' wl_hist <- data.frame(
#'   arrival_since = as.Date(c("2024-01-01", "2024-01-08")),
#'   arrival_before = as.Date(c("2024-01-07", "2024-01-14")),
#'   n = c(100, 120),
#'   report_date = as.Date(c("2024-01-31", "2024-02-29"))
#' )
#' removal_stats <- wl_removal_stats_hist(wl_hist)
#' }
#'

# TODO: Currently assumes equal intervals between snapshots. Consider updating to handle unequal intervals (e.g., monthly then weekly snapshots, or irregular snapshot dates). This would improve flexibility for operational data.

wl_removal_stats_hist <- function(wl_hist,
                                   start_date = NULL,
                                   end_date = NULL) {
  
  # Extract unique report dates
  report_dates <- unique(wl_hist$report_date)
  report_dates <- sort(report_dates)
  
  # Set start_date to earliest if not provided
  if (is.null(start_date)) {
    start_date <- min(report_dates)
  } else {
    start_date <- as.Date(start_date)
  }
  
  # Set end_date to latest if not provided
  if (is.null(end_date)) {
    end_date <- max(report_dates)
  } else {
    end_date <- as.Date(end_date)
  }
  
  # Filter dates within range
  report_dates <- report_dates[report_dates >= start_date & report_dates <= end_date]
  
  # Check we have at least 2 dates
  if (length(report_dates) < 2) {
    stop("Histogram must contain at least 2 report_date values within the specified date range to calculate removal statistics")
  }
  
  # Initialize accumulators
  total_removals <- 0
  total_days <- 0
  weighted_capacity_sum <- 0
  
  # Loop through consecutive pairs
  for (i in 1:(length(report_dates) - 1)) {
    date1 <- report_dates[i]
    date2 <- report_dates[i + 1]
    
    # Filter histograms for these two dates
    wl_hist1 <- wl_hist |>
      dplyr::filter(.data$report_date == date1) |>
      dplyr::rename(
        n_hist1 = .data$n,
        arrival_before_hist1 = .data$arrival_before
      )
    
    wl_hist2 <- wl_hist |>
      dplyr::filter(.data$report_date == date2) |>
      dplyr::rename(
        n_hist2 = .data$n,
        arrival_before_hist2 = .data$arrival_before
      )
    
    # Compare the two snapshots
    comparison <- dplyr::full_join(wl_hist1, wl_hist2, by = "arrival_since") |>
      dplyr::mutate(
        n_hist1 = tidyr::replace_na(.data$n_hist1, 0),
        n_hist2 = tidyr::replace_na(.data$n_hist2, 0),
        change = .data$n_hist2 - .data$n_hist1
      ) |>
      dplyr::select(
        .data$arrival_since,
        .data$n_hist1,
        .data$n_hist2,
        .data$change
      ) |>
      dplyr::arrange(.data$arrival_since)
    
    # Calculate removals for this period (negative changes)
    period_removals <- abs(sum(comparison$change[comparison$change < 0]))
    
    # Calculate days between snapshots
    days_diff <- as.numeric(difftime(date2, date1, units = "days"))
    
    # Accumulate
    total_removals <- total_removals + period_removals
    total_days <- total_days + days_diff
    
    # Calculate capacity for this period
    period_capacity <- period_removals / days_diff
    weighted_capacity_sum <- weighted_capacity_sum + (period_capacity * days_diff)
  }
  
  # Calculate mean capacity (weighted by days in each period)
  capacity_daily <- weighted_capacity_sum / total_days
  capacity_weekly <- capacity_daily * 7
  
  removal_stats <- data.frame(
    "capacity_weekly" = capacity_weekly,
    "capacity_daily" = capacity_daily,
    "capacity_cov" = 1,
    "removal_count" = total_removals
  )
  
  return(removal_stats)
}
