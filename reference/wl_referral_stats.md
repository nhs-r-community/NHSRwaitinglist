# Calculate some stats about referrals

Calculate some stats about referrals

## Usage

``` r
wl_referral_stats(
  waiting_list,
  start_date = NULL,
  end_date = NULL,
  referral_index = 1
)
```

## Arguments

- waiting_list:

  data.frame. A df of referral dates and removals

- start_date:

  Date or character (in format 'YYYY-MM-DD'); The start date to
  calculate from

- end_date:

  Date or character (in format 'YYYY-MM-DD'); The end date to calculate
  to

- referral_index:

  the column index of referrals

## Value

A data.frame with the following summary statistics on referrals/demand:

- demand_weekly:

  Numeric. Mean number of additions to the waiting list per week.

- demand_daily:

  Numeric. Mean number of additions to the waiting list per day.

- demand_cov:

  Numeric. Coefficient of variation in the time between additions to the
  waiting list.

- demand_count:

  Numeric. Total demand over the full time period.

## Examples

``` r
referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
removals <- c.Date("2024-01-08", NA, NA, NA)
waiting_list <- data.frame("referral" = referrals, "removal" = removals)
referral_stats <- wl_referral_stats(waiting_list)
```
