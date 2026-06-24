# Insert new referrals into the waiting list

Adds new referrals, with other columns set as `NA`.

## Usage

``` r
wl_insert(waiting_list, additions, referral_index = 1)
```

## Arguments

- waiting_list:

  data.frame. A df of referral dates and removals

- additions:

  Date or character vector (in format 'YYYY-MM-DD'). A list of referral
  dates to add to the waiting list

- referral_index:

  The index of the column in `waiting_list` which contains the referral
  dates. Defaults to the first column.

## Value

A `data.frame` representing the updated waiting list, with additional
referrals dates in the column specified by `referral_index`. Other
columns are filled with `NA` in the new rows. The result is sorted by
the referral column.

## Examples

``` r
referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
removals <- c.Date("2024-01-08", NA, NA, NA)
waiting_list <- data.frame("referral" = referrals, "removal" = removals)
additions <- c.Date("2024-01-03", "2024-01-05", "2024-01-18")
longer_waiting_list <- wl_insert(waiting_list, additions)
```
