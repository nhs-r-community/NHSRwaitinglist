# Generator a list of dates to schedule

Generates a list if dates in a given range

## Usage

``` r
sim_schedule(n_rows = 10, start_date = NULL, daily_capacity = 1)
```

## Arguments

- n_rows:

  Number of rows/patients to generate

- start_date:

  Start date (needed to generate patient ages)

- daily_capacity:

  Number of patients per day

## Value

A vector of `Date` values representing scheduled procedure dates. The
length of the vector is equal to `n_rows`, and the dates are spaced
according to the specified `daily_capacity`.
