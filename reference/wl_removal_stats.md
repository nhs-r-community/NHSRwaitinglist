# Calculate some stats about removals

Calculate some stats about removals

## Usage

``` r
wl_removal_stats(
  waiting_list,
  start_date = NULL,
  end_date = NULL,
  referral_index = 1,
  removal_index = 2
)
```

## Arguments

- waiting_list:

  data.frame. A df of referral dates and removals

- start_date:

  Date or character (in format 'YYYY-MM-DD'); The start date to
  calculate from.

- end_date:

  Date or character (in format 'YYYY-MM-DD'); The end date to calculate
  to.

- referral_index:

  Index of the referral column in waiting_list.

- removal_index:

  Index of the removal column in waiting_list.

## Value

A data.frame with the following summary statistics on removals/capacity:

- capacity_weekly:

  Numeric. Mean number of removals from the waiting list per week.

- capacity_daily:

  Numeric. Mean number of removals from the waiting list per day.

- capacity_cov:

  Numeric. Coefficient of variation in the time between removals from
  the waiting list.

- removal_count:

  Numeric. Total number of removals from the waiting list over the full
  time period.

## Examples

``` r
referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
removals <- c.Date("2024-01-08", NA, NA, NA)
waiting_list <- data.frame("referral" = referrals, "removal" = removals)
removal_stats <- wl_removal_stats(waiting_list)
```
