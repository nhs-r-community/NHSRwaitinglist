# Queue size calculator

Calculates queue sizes from a waiting list

## Usage

``` r
wl_queue_size(
  waiting_list,
  start_date = NULL,
  end_date = NULL,
  referral_index = 1,
  removal_index = 2
)
```

## Arguments

- waiting_list:

  data.frame consisting addition and removal dates

- start_date:

  Date or character (in format 'YYYY-MM-DD'); start of calculation
  period

- end_date:

  Date or character (in format 'YYYY-MM-DD'); end of calculation period

- referral_index:

  the index of referrals in waiting_list

- removal_index:

  the index of removals in waiting_list

## Value

A data.frame containing the size of the waiting list for each day in the
specified date range. If `start_date` and/or `end_date` are `NULL`, the
function uses the earliest and latest referral dates in the input
data.frame. The returned data.frame has the following columns:

- dates:

  Date. Each date within the computed range, starting from the first
  referral.

- queue_size:

  Numeric. Number of patients on the waiting list on that date.

## Examples

``` r
referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
removals <- c.Date("2024-01-08", NA, NA, NA)
waiting_list <- data.frame("referral" = referrals, "removal" = removals)
wl_queue_size(waiting_list)
#>         dates queue_size
#> 1  2024-01-01          1
#> 2  2024-01-02          1
#> 3  2024-01-03          1
#> 4  2024-01-04          2
#> 5  2024-01-05          2
#> 6  2024-01-06          2
#> 7  2024-01-07          2
#> 8  2024-01-08          1
#> 9  2024-01-09          1
#> 10 2024-01-10          2
#> 11 2024-01-11          2
#> 12 2024-01-12          2
#> 13 2024-01-13          2
#> 14 2024-01-14          2
#> 15 2024-01-15          2
#> 16 2024-01-16          3
```
