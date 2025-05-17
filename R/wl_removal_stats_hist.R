#' @title Calculate some stats about removals
#'
#' @description Calculate some stats about removals
#'
#' @param waiting_list data.frame. A df of referral dates and removals
#' @param start_date Date or character (in format 'YYYY-MM-DD'); The start date
#'   to calculate from.
#' @param end_date Date or character (in format 'YYYY-MM-DD'); The end date to
#'   calculate to.
#' @param referral_index Index of the referral column in waiting_list.
#' @param removal_index Index of the removal column in waiting_list.
#'
#' @return A data.frame with the following summary statistics on
#'   removals/capacity:
#'
#' \describe{
#'   \item{capacity_weekly}{Numeric. Mean number of removals from the waiting
#'     list per week.}
#'   \item{capacity_daily}{Numeric. Mean number of removals from the waiting
#'     list per day.}
#'   \item{capacity_cov}{Numeric. Coefficient of variation in the time between
#'     removals from the waiting list.}
#'   \item{removal_count}{Numeric. Total number of removals from the waiting
#'     list over the full time period.}
#' }
#'
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' removal_stats <- wl_removal_stats(waiting_list)
#'
wl_removal_stats_hist <- function(wl_hist1,wl_hist2,
                             start_date = NULL,
                             end_date = NULL,
                             referral_index = 1,
                             removal_index = 2) {



  wl_hist1 <- wl_hist1 %>%
    rename(
      n_hist1 = n,
      arrival_before_hist1 = arrival_before
    )

  wl_hist2 <- wl_hist2 %>%
    rename(
      n_hist2 = n,
      arrival_before_hist2 = arrival_before
    )

  # Step 2: Full join and handle missing data
  comparison <- full_join(wl_hist1, wl_hist2, by = "arrival_since") %>%
    mutate(
      n_hist1 = replace_na(n_hist1, 0),
      n_hist2 = replace_na(n_hist2, 0),
      # Step 3: Merge the arrival_before columns using coalesce
      arrival_before = coalesce(arrival_before_hist1, arrival_before_hist2),
      change = n_hist2 - n_hist1
    ) %>%
    # Optional: tidy up column order
    select(
      arrival_since,
      arrival_before,
      n_hist1,
      n_hist2,
      change
    ) %>%
    arrange(arrival_since)

  num_removals <- abs(sum(comparison$change[comparison$change < 0]))

  # Find the most recent dates
  latest1 <- max(wl_hist1$arrival_before_hist1, na.rm = TRUE)
  latest2 <- max(wl_hist2$arrival_before_hist2, na.rm = TRUE)

  # Calculate difference in days
  days_diff <- as.numeric(abs(difftime(latest1, latest2, units = "days")))

  capacity <- num_removals / days_diff
  capacity_weekly <- capacity * 7

  removal_stats <- data.frame(
    "capacity_weekly" = capacity_weekly,
    "capacity_daily" = capacity,
    "capacity_cov" = 1,
    "removal_count" = num_removals
  )

  return(removal_stats)
}
