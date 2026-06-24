# A simple operation scheduler

Takes a list of dates and schedules them to a waiting list, by adding a
removal date to the data.frame. This is done in referral date order,
I.e. earlier referrals are scheduled first (FIFO).

## Usage

``` r
wl_schedule(
  waiting_list,
  schedule,
  referral_index = 1,
  removal_index = 2,
  unscheduled = FALSE
)
```

## Arguments

- waiting_list:

  data.frame. A df of referral dates and removals

- schedule:

  Date or character vector. Should be formatted as year-month-date, e.g.
  "2024-04-01". The dates to schedule open referrals into (i.e. dates of
  unbooked future capacity)

- referral_index:

  The column index in the waiting_list which contains the referral dates

- removal_index:

  The column index in the waiting_list which contains the removal dates

- unscheduled:

  logical. If TRUE, returns a list of scheduled and unscheduled
  procedures If FALSE, only returns the updated waiting list

## Value

The updated waiting list with removal dates assigned based on the given
schedule, either as a single `data.frame` (default) or as part of a list
(if `unscheduled = TRUE`).

If `unscheduled = TRUE`, returns a `list` with two data frames:

1.  A `data.frame`. The updated waiting list with scheduled removals.

2.  A `data.frame` showing which slots were used, with columns:

    - schedule:

      Date. The available dates from the input `schedule`.

    - scheduled:

      Numeric. `1` if the slot was used to schedule a patient, `0` if
      not.

## Examples

``` r
referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
removals <- c.Date("2024-01-08", NA, NA, NA)
waiting_list <- data.frame("referral" = referrals, "removal" = removals)
schedule <- c.Date("2024-01-03", "2024-01-05", "2024-01-18")
updated_waiting_list <- wl_schedule(waiting_list, schedule)
```
