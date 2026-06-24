# Calculate Waiting List Pressure

For a waiting list with target waiting time, the pressure on the waiting
list is twice the mean delay divided by the waiting list target. The
pressure of any given waiting list should be less than 1. If the
pressure is greater than 1 then the waiting list is most likely going to
miss its target. The waiting list pressure is calculated as follows:
pressure = 2 \* mean_wait / target_wait.

## Usage

``` r
calc_waiting_list_pressure(mean_wait, target_wait)
```

## Arguments

- mean_wait:

  Numeric value of target mean waiting time to achieve a given target
  wait.

- target_wait:

  Numeric value of the number of weeks that has been set as the target
  within which the patient should be seen.

## Value

Numeric value of wait_pressure which is the waiting list pressure.

## Examples

``` r
calc_waiting_list_pressure(63, 52)
#> [1] 2.423077
```
