#' @title Create Waiting List
#'
#' @description
#' Creates a waiting list using the parameters specified
#'
#'
#' @param n Numeric value of rate of demand in same units as target wait
#'  - e.g. if target wait is weeks, then demand in units of patients/week.
#' @param mean_arrival_rate Numeric value of mean daily arrival rate.
#' @param mean_wait Numeric value of mean wait time for treatment/on waiting
#' list.
#' @param start_date Character value of date from which to start generated
#' waiting list.
#' @param limit_removals Defaults to TRUE
#' @param sd Numeric value, standard deviation. Defaults to 0.
#' @param rott Numeric value, proportion of referrals to be randomly flagged
#' as ROTT. Defaults to 0.
#' @param ... Container for the list
#'
#' @return A tibble of a random generated list of patients with addition_date,
#'  removal_date, wait_length and rott status for each patient
#' @export
#'
#' @examples create_waiting_list(366, 50, 21, "2024-01-01", 10, 0.1)
#'
create_waiting_list <- function(n, mean_arrival_rate, mean_wait,
                                start_date = Sys.Date(), limit_removals = TRUE,
                                sd = 0, rott = 0, ...) {

  if(!n>0){
    stop("Invalid rate (n) value supplied")
  }

  dots <- list(...)

  # Generate date range and number of referrals for each date (with or without
  # random variation around mean_arrival_rate)
  dates <- seq.Date(
    from = as.Date(start_date, format = "%Y-%m-%d"),
    length.out = n,
    by = "day"
  )
  counts <- pmax(0, stats::rnorm(n, mean = mean_arrival_rate, sd = sd))
  referrals <- rep(dates, times = counts)

  # set random waiting time in days for each referral received with exponential
  # distribution rate 1/mean_waiting_time
  values <- stats::rexp(length(referrals), 1 / mean_wait)

  # Create dataframe of referrals and calculate removal date
  test_df <- data.frame(addition_date = referrals, wait_length = values)
  test_df$removal_date <- test_df$addition_date + round(test_df$wait_length, 0)

  # Suppress removal dates that are greater than start date + 'n' days to
  # simulate non-zero waitlist at end of simulated period.
  if (limit_removals) {
    test_df$removal_date[test_df$removal_date >
                           (as.Date(start_date, format = "%Y-%m-%d") + n)] <- NA
    test_df$wait_length[is.na(test_df$removal_date)] <- NA
  }

  # Randomly flag user defined proportion of referrals as ROTT
  test_df$rott <- FALSE
  sample_list <- sample(seq_len(nrow(test_df)), nrow(test_df) * rott,
    replace = FALSE
  )
  test_df$rott[sample_list] <- TRUE

  # Add a patient ID to each referral and prepare data for return
  test_df$pat_id <- seq_len(nrow(test_df))
  test_df <- test_df[
    order(test_df$addition_date),
    c(
      "pat_id", "addition_date",
      "removal_date", "wait_length", "rott"
    )
  ]

  return(dplyr::as_tibble(c(dots, test_df)))
}
