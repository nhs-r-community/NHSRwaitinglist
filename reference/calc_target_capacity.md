# Target Capacity

Applies Kingman/Marchal's Formula :

     capacity = demand + (cvd**2 + cvc**2) / waiting_time

where cvd = coefficient of variation of time between arrivals cvd =
coefficient of variation of service times waiting_time = target_wait /
factor

## Usage

``` r
calc_target_capacity(
  demand,
  target_wait,
  factor = 4,
  cv_demand = 1,
  cv_capacity = 1
)
```

## Arguments

- demand:

  Numeric value of rate of demand in same units as target wait e.g. if
  target wait is weeks, then demand in units of patients/week.

- target_wait:

  Numeric value of number of weeks that has been set as the target
  within which the patient should be seen.

- factor:

  the amount we divide the target by in the waiting list e.g. if target
  is 52 weeks the mean wait should be 13 for a factor of 4

- cv_demand:

  coefficient of variation of time between arrivals

- cv_capacity:

  coefficient of variation between removals due to operations completed

## Value

numeric. The capacity required to achieve a target waiting time.

## Examples

``` r

demand <- 4 # weeks
target_wait <- 52 # weeks

# number of operations per week to have mean wait of 52/4
calc_target_capacity(demand, target_wait)
#> [1] 4.076923
```
