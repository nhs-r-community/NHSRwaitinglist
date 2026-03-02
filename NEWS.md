# NHSRwaitinglist (development version)

## New Features

* **Histogram functionality now documented and exported**: The package has long included functions for analysing aggregated/binned waiting list data (histogram format), but these were previously internal-only. These functions are now fully documented and exported:
  * `wl_stats_hist()` - Comprehensive waiting list statistics from histogram data
  * `wl_referral_stats_hist()` - Demand/referral statistics 
  * `wl_removal_stats_hist()` - Capacity/removal statistics
  * `wl_queue_size_hist()` - Queue size calculation
  * `wl_mean_wait_age_hist()` - Mean waiting time
  * `wl_percentile_hist()` - Percentile calculations
  * `wl_join_hist()` and `wl_insert_hist()` - Histogram manipulation
  * `format_histogram()` and `aggregate_histogram()` - Data preparation utilities

* **Improved histogram API**: `wl_stats_hist()` and `wl_removal_stats_hist()` now accept a single histogram dataframe with multiple `report_date` values, rather than requiring two separate histogram parameters. This significantly improves usability and allows analysis across multiple time points.

* **New vignette**: Added comprehensive [histogram analysis vignette](https://nhs-r-community.github.io/NHSRwaitinglist/articles/histogram_analysis.html) demonstrating:
  * When and why to use histogram format
  * Data structure requirements
  * All histogram analysis functions
  * Working with NHS national statistics
  * Comparison with patient-level analysis

## Bug Fixes

* Fixed hardcoded `target_wait` value in `wl_stats_hist()` (was always 18, now uses function parameter)
* Removed duplicate file `wl_referral_stats_hist-E-LOSX4GYQ6L4.R`

# NHSRwaitinglist 0.1.2

* Bug fix release, required for changes in date handling in R.
* More input checks added
* CRAN installation instructions added.

# NHSRwaitinglist 0.1.1

* Bug fixes and formatting updated in some help files
* Added an additional vignette on using WL simulation to answer questions around managing waiting lists
* Arguments harmonised across several functions, and column specifications given more details. Thanks @davidfoord1
* Better column indexing in wl_insert and others. Thanks @davidfoord1
* More details added to DESCRIPTION


# NHSRwaitinglist 0.1

* Initial CRAN submission.
