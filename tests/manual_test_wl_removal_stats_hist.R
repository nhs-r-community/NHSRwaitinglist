# Manual Test Script for wl_removal_stats_hist
# Run this script from the package root directory

# Load required libraries
library(dplyr)
library(tidyr)

# Resolve the package root by walking upward until DESCRIPTION is found.
pkg_root <- normalizePath(getwd())
while (!file.exists(file.path(pkg_root, "DESCRIPTION"))) {
  parent_root <- dirname(pkg_root)
  if (identical(parent_root, pkg_root)) {
    stop("Could not locate package root from manual_test_wl_removal_stats_hist.R")
  }
  pkg_root <- parent_root
}

# Source the required functions
source(file.path(pkg_root, "R", "wl_removal_stats_hist.R"))
source(file.path(pkg_root, "R", "format_histogram.R"))
source(file.path(pkg_root, "R", "aggregate_histogram.R"))

cat("=== Manual Test: wl_removal_stats_hist ===\n\n")

# Test 1: Basic test with 2 snapshots
cat("Test 1: Basic functionality with 2 report dates\n")
cat("------------------------------------------------\n")

# Create a simple histogram with 2 time points
wl_hist_test1 <- rbind(
  data.frame(
    arrival_since = as.Date(c("2024-01-01", "2024-01-08", "2024-01-15")),
    arrival_before = as.Date(c("2024-01-07", "2024-01-14", "2024-01-21")),
    n = c(100, 80, 60),  # Total: 240 patients
    report_date = as.Date("2024-01-31")
  ),
  data.frame(
    arrival_since = as.Date(c("2024-01-01", "2024-01-08", "2024-01-15")),
    arrival_before = as.Date(c("2024-01-07", "2024-01-14", "2024-01-21")),
    n = c(90, 70, 50),  # Total: 210 patients (30 removed)
    report_date = as.Date("2024-02-29")
  )
)

cat("Input histogram:\n")
print(wl_hist_test1)

result1 <- wl_removal_stats_hist(wl_hist_test1)
cat("\nResult:\n")
print(result1)

days_between <- as.numeric(difftime(as.Date("2024-02-29"), as.Date("2024-01-31"), units = "days"))
cat("\nExpected removals: 30\n")
cat("Expected days between snapshots:", days_between, "\n")
cat("Expected capacity_daily:", 30/days_between, "\n")
cat("Expected capacity_weekly:", (30/days_between) * 7, "\n\n")

# Test 2: Multiple time points (3 snapshots)
cat("\nTest 2: Multiple time points (3 report dates)\n")
cat("------------------------------------------------\n")

wl_hist_test2 <- rbind(
  data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 300,
    report_date = as.Date("2024-01-31")
  ),
  data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 280,  # 20 removed
    report_date = as.Date("2024-02-29")
  ),
  data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 250,  # 30 more removed
    report_date = as.Date("2024-03-31")
  )
)

cat("Input histogram:\n")
print(wl_hist_test2)

result2 <- wl_removal_stats_hist(wl_hist_test2)
cat("\nResult:\n")
print(result2)

cat("\nExpected total removals: 50 (20 + 30)\n")
cat("Period 1 (Jan 31 to Feb 29): 20 removals over 29 days\n")
cat("Period 2 (Feb 29 to Mar 31): 30 removals over 31 days\n")
cat("Weighted average capacity should reflect both periods\n\n")

# Test 3: No removals (stable queue)
cat("\nTest 3: No removals (stable queue)\n")
cat("------------------------------------------------\n")

wl_hist_test3 <- rbind(
  data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 100,
    report_date = as.Date("2024-01-31")
  ),
  data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 100,  # Same count
    report_date = as.Date("2024-02-29")
  )
)

cat("Input histogram:\n")
print(wl_hist_test3)

result3 <- wl_removal_stats_hist(wl_hist_test3)
cat("\nResult:\n")
print(result3)

cat("\nExpected: 0 removals, 0 capacity\n\n")

# Test 4: Using start_date and end_date filters
cat("\nTest 4: Date range filtering\n")
cat("------------------------------------------------\n")

wl_hist_test4 <- rbind(
  data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 100,
    report_date = as.Date("2024-01-31")
  ),
  data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 90,
    report_date = as.Date("2024-02-29")
  ),
  data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 80,
    report_date = as.Date("2024-03-31")
  ),
  data.frame(
    arrival_since = as.Date("2024-01-01"),
    arrival_before = as.Date("2024-01-07"),
    n = 70,
    report_date = as.Date("2024-04-30")
  )
)

cat("Input histogram (4 time points):\n")
print(wl_hist_test4)

# Filter to only Feb-Mar
result4 <- wl_removal_stats_hist(wl_hist_test4, 
                                  start_date = "2024-02-01", 
                                  end_date = "2024-03-31")
cat("\nResult (filtered to Feb-Mar only):\n")
print(result4)

cat("\nExpected: Only uses Feb 29 and Mar 31 snapshots\n")
cat("Expected removals: 10 (90 - 80)\n\n")

# Test 5: Error case - single report date
cat("\nTest 5: Error handling - single report date\n")
cat("------------------------------------------------\n")

wl_hist_test5 <- data.frame(
  arrival_since = as.Date("2024-01-01"),
  arrival_before = as.Date("2024-01-07"),
  n = 100,
  report_date = as.Date("2024-01-31")
)

cat("Input histogram (only 1 time point):\n")
print(wl_hist_test5)

cat("\nTrying to run function (should error)...\n")
tryCatch(
  {
    result5 <- wl_removal_stats_hist(wl_hist_test5)
    cat("ERROR: Should have thrown an error but didn't!\n")
  },
  error = function(e) {
    cat("✓ Correctly threw error:", conditionMessage(e), "\n")
  }
)

cat("\n=== All manual tests completed ===\n")
cat("You can now experiment with your own test cases below:\n\n")
