# Join two waiting list

Take two waiting list and sorting in date order

## Usage

``` r
wl_join(wl_1, wl_2, referral_index = 1)
```

## Arguments

- wl_1:

  a waiting list: dataframe consisting addition and removal dates

- wl_2:

  a waiting list: dataframe consisting addition and removal dates

- referral_index:

  the column index where referrals are listed

## Value

A data.frame representing the combined waiting list, created by joining
`wl_1` and `wl_2`. The result is sorted by the referral date column
specified by `referral_index`. The column structure is preserved from
the input data frames.

## Examples

``` r

referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
removals <- c.Date("2024-01-08", NA, NA, NA)
wl_1 <- data.frame("referral" = referrals, "removal" = removals)

referrals <- c.Date("2024-01-04", "2024-01-05", "2024-01-16", "2024-01-25")
removals <- c.Date("2024-01-09", NA, "2024-01-19", NA)
wl_2 <- data.frame("referral" = referrals, "removal" = removals)
wl_join(wl_1, wl_2)
#>     referral    removal
#> 1 2024-01-01 2024-01-08
#> 2 2024-01-04       <NA>
#> 3 2024-01-04 2024-01-09
#> 4 2024-01-05       <NA>
#> 5 2024-01-10       <NA>
#> 6 2024-01-16       <NA>
#> 7 2024-01-16 2024-01-19
#> 8 2024-01-25       <NA>
```
