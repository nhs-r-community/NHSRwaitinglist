# Review Changes Log

This file records the changes made so far in the package review session.

## TODO

- Review this markdown change log for any duplicate entries, stale notes, or final cleanup before release.
- Re-read the related `.md` files after the next validation pass to confirm the documented state still matches the package.

## Source files

- R/wl_percentile_hist.R, rough lines 1-70
  - Expanded roxygen docs for the percentile helper.
  - Added input validation for `wl_hist` and `percentage`.
  - Removed the `lubridate::days()` dependency by using base date arithmetic.
  - Returned both the documented names (`date_percentile`, `weeks_percentile`) and legacy aliases (`date`, `weeks`) for backward compatibility.
  - Added handling for empty/zero-total histograms.

- R/wl_stats.R, rough lines 54-160
  - Replaced invalid date examples in roxygen comments.
  - Fixed the pressure calculation to use the computed `mean_wait_age` value instead of an undefined `mean_wait` symbol.

- R/wl_removal_stats.R, rough lines 27-31
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- R/wl_referral_stats.R, rough lines 25-29
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- R/wl_referral_stats_hist.R, rough lines 25-29
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- R/wl_queue_size.R, rough lines 25-29
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- R/wl_insert.R, rough lines 16-22
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- R/wl_join.R, rough lines 16-24
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- R/wl_schedule.R, rough lines 37-43
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

## Tests

- tests/testthat/test-wl_percentile_hist.R, rough lines 1-50
  - Added focused tests for documented return names, legacy aliases, invalid percentile values, and zero-total histograms.

- tests/testthat/test-wl_insert.R, rough lines 1-20
  - Replaced invalid `c.Date()` test fixtures with valid `as.Date(c(...))` syntax.

- tests/testthat/test-wl_schedule.R, rough lines 72-75
  - Replaced invalid `c.Date()` test fixture with valid `as.Date(c(...))` syntax.

## Generated documentation

- man/wl_percentile_hist.Rd, rough lines 1-20
  - Updated the return section to match the new backward-compatible return structure.

- man/wl_removal_stats.Rd, rough lines 44-48
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- man/wl_referral_stats.Rd, rough lines 40-44
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- man/wl_referral_stats_hist.Rd, rough lines 40-44
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- man/wl_queue_size.Rd, rough lines 42-46
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- man/wl_insert.Rd, rough lines 25-31
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- man/wl_join.Rd, rough lines 24-32
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- man/wl_schedule.Rd, rough lines 54-60
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

- man/wl_stats.Rd, rough lines 63-67
  - Replaced invalid `c.Date()` examples with valid `as.Date(c(...))` syntax.

## Notes

- The vignettes folder was not edited.
- The percentile helper was checked with a direct source-level runtime sanity test after the change.
- The package now has one extra test file focused on the histogram percentile helper.

## Additional review findings

- R/format_histogram.R, rough lines 1-95
  - This is the active histogram formatter used by multiple histogram helpers.
  - The roxygen example uses `group_column`, while the function argument is `group_columns`; that mismatch should be reviewed before any doc regeneration.
  - The implementation is doing several responsibilities at once: date coercion, optional row synthesis, and sorting.

- R/hist_format.R, rough lines 1-6
  - This looked like a legacy or experimental helper (`process_hist`) that was not referenced by any current R file.
  - It duplicated part of the histogram formatting behavior and has now been removed, leaving `format_histogram()` as the single active formatter.

- R/format_histogram.R, rough lines 1-95
  - The active formatter docs were aligned with the actual signature: `group_columns` is now documented correctly and `time_interval` is described.
  - The roxygen example now matches the function argument name and no longer refers to the old `group_column` spelling.

- R/wl_mean_wait_age_hist.R and R/wl_stats_hist.R, rough lines 1-120
  - The histogram waiting-time docs now match the implementation: `wl_mean_wait_age_hist()` is described as waiting age so far, not total sojourn time, and `wl_stats_hist()` now documents the returned `mean_wait_age` field instead of `mean_wait`.
  - The pressure description was updated to match the actual field name used in the calculation chain.

- R/wl_referral_stats_hist.R, rough lines 1-60
  - The histogram referral docs were aligned with the implementation: they now describe histogram inputs, use `wl_hist` consistently, and the example calls `wl_referral_stats_hist()` with histogram data rather than the raw-data helper.

- R/wl_join_hist.R and R/wl_insert_hist.R, rough lines 1-40
  - The histogram list-manipulation docs were aligned with the implementation: `wl_join_hist()` now documents the real `categories` argument, and `wl_insert_hist()` now has a clearer description of its wrapper behavior.

- R/vis_plot_hist.R, rough lines 1-60
  - The plotting helper now calls `wl_referral_stats_hist()` with histogram data instead of passing the percentile value into the wrong argument slot.
  - The helper now namespaces its plotting calls explicitly, making the function self-contained without relying on implicit ggplot2 attachment.

- R/sim_exponential_histogram.R, rough lines 1-40
  - The simulator roxygen block now matches the implementation signature: `num_intervals`, `queue_size`, `time_interval`, and `random` are documented instead of the old placeholder argument names.

- man/vis_plot_hist.Rd and man/sim_exponential_histogram.Rd
  - The generated help pages were synced with the source updates so the packaged help matches the histogram helper behavior and arguments.

- R/wl_schedule.R, rough lines 60-110
  - Fixed a scheduling edge case by checking the row bound before indexing into the unscheduled waiting list. This avoids out-of-range access when no open referrals are left to schedule.

- R/wl_stats.R and man/wl_stats.Rd, rough lines 35-60
  - Aligned summary-field documentation with implementation by using `mean_wait_age` and updating the pressure formula text accordingly.

- R/wl_mean_wait_age.R and man/wl_mean_wait_age.Rd, rough lines 6-20
  - Corrected the parameter name in documentation from `dob_index` to `referral_index`.

- R/wl_mean_wait_sojourn.R and man/wl_mean_wait_sojourn.Rd, rough lines 1-35
  - Updated implementation to infer referral/removal columns using existing index helpers instead of hardcoded `Referral`/`Removal` names.
  - Added explicit handling for cases with no complete referral/removal pairs (`NA_real_`).
  - Aligned docs with this behavior and generalized column naming expectations.

- R/calc_relief_capacity.R and man/calc_relief_capacity.Rd, rough lines 20-45
  - Replaced placeholder documentation for `cv_demand` with a concrete description of how it is used in demand uplift when referral count data are supplied.

- R/calc_target_queue_size.R and man/calc_target_queue_size.Rd, rough lines 5-45
  - Corrected documentation to match implementation: target queue size is computed via target mean wait (`target_wait / factor`), not hardcoded division by 4.
  - Updated `factor` default description to `-log(0.08)` and clarified that factor `4` remains a quarter-target option.

- tests/testthat/test_wl_stats.R, rough lines 55-65
  - Updated an outdated expectation from `result$mean_wait` to `result$mean_wait_age` to reflect current `wl_stats()` output naming.

- R/wl_queue_size.R, rough lines 50-70
  - Corrected the departures-availability check to test `length(departures) > 0` directly (instead of checking the length of a logical comparison result).

- R/wl_removal_stats.R and man/wl_removal_stats.Rd, rough lines 15-105
  - Added explicit no-removals handling: returns `NA` for capacity metrics and `0` for `removal_count` when no removals fall in range.
  - Added a zero-mean-removal guard so capacity is reported as `Inf` and removal CV as `NA` rather than producing unstable division outputs.
  - Updated help text to document capacity behavior when no removals are present.

- R/create_waiting_list.R and man/create_waiting_list.Rd, rough lines 8-45
  - Corrected the `limit_removals` parameter documentation to describe it as logical.
  - Fixed the example call so the fifth argument is `TRUE` rather than a numeric placeholder.
  - Removed the stale duplicate `limit_removals` help entry left behind in the generated Rd file.
  - Repaired the generated Rd `usage`/`arguments` block after an intermediate malformed edit.

- DESCRIPTION, rough lines 1-20
  - Added the missing `Author` field required by `R CMD check` so package validation can proceed.
  - Added `tidyr` to `Imports` because the histogram removal stats helper uses `tidyr::replace_na()`.

- R/wl_stats.R, R/wl_stats_hist.R, and the matching Rd files, rough lines 30-185
  - Added backward-compatible `mean_wait` aliases so existing vignette and downstream code that still selects the older field name continue to work.

- R/wl_mean_wait_sojourn.R and man/wl_mean_wait_sojourn.Rd, rough lines 1-25
  - Replaced the undocumented example reference with a self-contained example data frame so the help page example can run cleanly.

- R/wl_removal_stats_hist.R and tests/manual_test_wl_removal_stats_hist.R, rough lines 70-120
  - Namespaced the histogram helper column references to silence package-check binding notes.
  - Fixed the manual test script to source package files via the parent directory, matching how it runs during package checks.

- R/vis_plot_hist.R, rough lines 35-55
  - Switched the fill-label naming helper to `stats::setNames()` so the package check no longer flags an unexported `base` symbol.

- man/wl_referral_stats_hist.Rd, rough lines 1-8
  - Fixed malformed title markup (`\title`) in generated help file header.

- man/wl_insert_hist.Rd, man/sim_exponential_histogram.Rd, and man/wl_mean_wait_age_hist.Rd, rough lines 1-8
  - Fixed remaining malformed title markup in generated help headers to ensure valid Rd syntax.

- Current status
  - The histogram documentation now consistently distinguishes waiting age so far from total sojourn time, and the active formatter/referral helpers have matching source and Rd text.
  - Core non-histogram scheduling/docs/sojourn and calculation-helper docs are now aligned with implementation.
  - The vignettes folder remains untouched.
  - `R/hist_format.R` was removed after confirming it had no references in the package code.
