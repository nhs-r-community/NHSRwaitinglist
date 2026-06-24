# Create Waiting List

Creates a waiting list using the parameters specified

## Usage

``` r
create_waiting_list(
  n,
  mean_arrival_rate,
  mean_wait,
  start_date = Sys.Date(),
  limit_removals = TRUE,
  sd = 0,
  rott = 0,
  ...
)
```

## Arguments

- n:

  Numeric value of rate of demand in same units as target wait

  - e.g. if target wait is weeks, then demand in units of patients/week.

- mean_arrival_rate:

  Numeric value of mean daily arrival rate.

- mean_wait:

  Numeric value of mean wait time for treatment/on waiting list.

- start_date:

  Character value of date from which to start generated waiting list.

- limit_removals:

  Defaults to TRUE

- sd:

  Numeric value, standard deviation. Defaults to 0.

- rott:

  Numeric value, proportion of referrals to be randomly flagged as ROTT.
  Defaults to 0.

- ...:

  Container for the list

## Value

A tibble with randomly generated patient records and the following
columns:

- pat_id:

  Integer. Unique identifier for the patient.

- addition_date:

  Date. The date the patient was added to the waiting list.

- removal_date:

  Date. The date the patient was removed from the waiting list.

- wait_length:

  Numeric. Number of days between the addition and removal dates.

- rott:

  Logical. Whether the removal was for reasons other than treatment
  (ROTT).

Additional columns may be included if supplied via `...`, where named
vectors (e.g., patient-level variables) of compatible length are merged
into the output tibble.

## Examples

``` r
create_waiting_list(366, 50, 21, "2024-01-01", 10, 0.1)
#> # A tibble: 18,133 × 5
#>    pat_id addition_date removal_date wait_length rott 
#>     <int> <date>        <date>             <dbl> <lgl>
#>  1      1 2024-01-01    2024-03-07         66.3  FALSE
#>  2      2 2024-01-01    2024-01-13         12.3  FALSE
#>  3      3 2024-01-01    2024-02-12         42.2  FALSE
#>  4      4 2024-01-01    2024-02-16         45.8  FALSE
#>  5      5 2024-01-01    2024-01-02          1.12 FALSE
#>  6      6 2024-01-01    2024-01-05          3.53 FALSE
#>  7      7 2024-01-01    2024-01-06          5.34 FALSE
#>  8      8 2024-01-01    2024-02-06         36.4  FALSE
#>  9      9 2024-01-01    2024-01-17         16.3  FALSE
#> 10     10 2024-01-01    2024-01-25         24.4  FALSE
#> # ℹ 18,123 more rows
```
