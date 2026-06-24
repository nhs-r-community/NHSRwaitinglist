# Walkthrough of waiting list functions

``` r

library(NHSRwaitinglist)
```

This vignette is a practical demonstration of the {NHSRwaitinglist}
functions, using the same running example that is used in the reference
white paper [Fong el
al.](https://www.medrxiv.org/content/10.1101/2022.08.23.22279117v1.full-text),
and [video](https://www.youtube.com/watch?v=NWthhW5Fgls).

The example is centred on a P4 (priority 4) Ear, Nose & Throat (ENT)
waiting list at an acute hospital.

The package functions we will be using are:

| Function | Purpose |
|---:|:---|
| [`calc_queue_load()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_queue_load.md) | To understand the ratio between demand and capacity. |
| [`calc_target_mean_wait()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_target_mean_wait.md) | To understand the average waiting time for a queue in equilibrium. |
| [`calc_target_queue_size()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_target_queue_size.md) | To understand the queue size for a queue in equilibrium. |
| [`calc_relief_capacity()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_relief_capacity.md) | To calculate the relief capacity needed to bring a very large queue under control. |
| [`calc_target_capacity()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_target_capacity.md) | To understand the capacity required to keep a queue in equilibrium, depending on how much variability it experiences. |
| [`calc_waiting_list_pressure()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_waiting_list_pressure.md) | A pressure measure, which can be used to compare multiple waiting lists for planning purposes. |

## Setup

First, we’ll add the initial data we need, taken from the white paper.

``` r

# Queue size (patients)
queue_size <- 1200

# Waiting time target (weeks)
waiting_time_target <- 52

# Average waiting time in the queue (weeks)
avg_waiting_time <- 63

# Proportion of waiting list who have missed the 52 week target (%)
perc_missing_target <- 0.51

# Demand (patients per week)
demand <- 30

# Capacity (procedures per week)
capacity <- 27

# Standard deviation of number of operations per week
std_dev_procedures <- 160
```

## Demand, capacity, and load

> Fact 1: Capacity must be larger than demand, otherwise the waiting
> list size will grow indefinitely.

``` r

load <- calc_queue_load(demand, capacity)
load
#> [1] 1.111111
```

We see that the load is 1.11, which is greater than 1. The queue will
therefore grow in size indefinitely.

> Fact 2: If the load is greater than 1, then the queue is unstable, and
> the waiting list will grow indefinitely. If the load is less than 1,
> then the queue will be stable and the load is the proportion of the
> time that that waiting list is non-empty.

## Waiting list targets

> Fact 3: If the load on a queue is less than 1 then the chance of
> missing the target halves each time we increase the target by some
> fixed number of days.

> Fact 4: If we want to have a chance between 1.8%-0.2% of not achieving
> a waiting time target, then the average patient should have a waiting
> time between a quarter and a sixth of the target.

In the case of a P4 waiting list, the target wait is 52 weeks. Thus, we
should expect the average patient being operated on to have waited
between 9 and 13 weeks. In the case of P2 customers, the target is 4
weeks. Thus, the mean wait of a typical patient should be under one
week.

``` r

target_mean_wait <- calc_target_mean_wait(waiting_time_target)
target_mean_wait
#> [1] 13
```

We see that the target mean wait is 13 weeks.

## Target queue length

> Fact 5: Little’s Law. Assuming capacity exceeds demand, the average
> queue size is demand multiplied by average waiting time.

If, as given in Fact 4 above, we want the average waiting time to be a
quarter of the target, then Little’s Law leads to fact 6.

## Target queue size

> Fact 6: Target queue size is demand multiplied by target wait, divided
> by 4.

``` r

target_queue_size <- calc_target_queue_size(demand, waiting_time_target)
target_queue_size
#> [1] 390

queue_ratio <- queue_size / target_queue_size
queue_ratio
#> [1] 3.076923
```

In this example, the target queue size is 390, and the actual queue is
1200. The queue ratio is 3.1, meaning that the queue is 3.1 times its
target size.

If the waiting list size is over twice the target queue size, then we
consider that special measures are needed to increase capacity, and
reduce waiting list size.

## Relief capacity

> Fact 7: If the actual queue size is more than double the target queue
> size, then decide on a target date by which the queue will be brought
> down, and apply the necessary relief capacity.

``` r

weeks_until_target_acheived <- 26

relief_capacity <- calc_relief_capacity(
  demand = demand,
  queue_size = queue_size,
  target_queue_size = target_queue_size,
  time_to_target = weeks_until_target_acheived
)
relief_capacity
#> [1] 61.15385
```

In this example, we decide that the target should be achieved by the
start of the summer, 26 weeks away. To do this, the capacity needed is
61.2 procedures per week, compared to 27 procedures per week currently
being performed.

## Target capacity

As discussed above if the queue size is more than double its target then
capacity should be increased temporarily. However, once the queue size
is within an acceptable range, we can maintain the waiting time target
with what is potentially a much smaller capacity allocation to the
waiting list.

We know the mean waiting time (13 weeks) and queue size (390 patients)
of a waiting list operating at its target equilibrium. Now we calculate
a capacity allocation that will maintain this equilibrium in the long
run.

> Fact 8: Target capacity formula, based on the Pollaczek-Khinchine
> formula. The target capacity depends on demand, plus an additional
> capacity which is based on service variability, and the waiting time
> target.

The parameter “F” depends on the variability of the service. If we do
not know F, we can assume F = 1. Values less than 1 are good. Higher
values represent more variability, which in turn will increase the
capacity required to maintain equilibrium.

``` r

# set the "F" variability parameter
f_1 <- 1

target_capacity_1 <- calc_target_capacity(
  demand = demand,
  target_wait = waiting_time_target,
  factor = f_1
)
target_capacity_1
#> [1] 30.01923
```

If F is 1, we can see that the capacity required is 30.02, or 0.02 more
than the demand.

``` r

f_2 <- 6.58

target_capacity_2 <- calc_target_capacity(
  demand = demand,
  target_wait = waiting_time_target,
  factor = f_2
)
target_capacity_2
#> [1] 30.12654
```

If F is 6.58, we can see that the capacity required is 30.13, or 0.13
more than the demand.

So, decreasing variability of service (for example by stabilising
operating theatre schedules from day to day and week to week) has the
effect of reducing the capacity required to achieve a given service
waiting standard.

## Waiting list pressure

> Fact 9: Waiting list pressure. For a waiting list with target waiting
> time, the pressure on the waiting list is twice the mean waiting time
> divided by the target waiting time. The pressure of any given waiting
> list should be less than 1. If the pressure is greater than 1 then the
> waiting list is most likely going to miss its target.

Measuring waiting list pressure can give a comparative measure with
which to compare waiting lists, and help make resource allocation
decisions.

For the P4 ENT example we have been following:

``` r

waiting_list_pressure_p4 <-
  calc_waiting_list_pressure(
    avg_waiting_time,
    waiting_time_target
  )
waiting_list_pressure_p4
#> [1] 2.423077
```

The queue size is large, with 1200 patients waiting. The waiting time
target is 52 weeks, and the average waiting time being experienced is 63
weeks. This gives a waiting list pressure of 2.42. **NOTE** these
numbers are slightly different to the [white
paper](https://www.medrxiv.org/content/10.1101/2022.08.23.22279117v1.full-text),
which changes the average waiting time from 63 weeks to 61 weeks during
the example.

If we look at the P2 ENT example:

``` r

queue_size_p2 <- 220
avg_waiting_time_p2 <- 24
waiting_time_target_p2 <- 4

waiting_list_pressure_p2 <-
  calc_waiting_list_pressure(
    avg_waiting_time_p2,
    waiting_time_target_p2
  )
waiting_list_pressure_p2
#> [1] 12
```

The queue size is smaller, with 220 patients waiting. The waiting time
target is 4 weeks, and the average waiting time being experienced is 24.
This gives a waiting list pressure of 12.

In these two examples the pressure on the much shorter P2 waiting list
is 5 times higher than that on the P4 list. Closer attention should be
paid to P2 procedures.

## Summary

This worked example aims to demonstrate the functions available in this
package. In chronological order of application they were:

| Function | Purpose |
|---:|:---|
| [`calc_queue_load()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_queue_load.md) | To understand the ratio between demand and capacity. |
| [`calc_target_mean_wait()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_target_mean_wait.md) | To understand the average waiting time for a queue in equilibrium. |
| [`calc_target_queue_size()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_target_queue_size.md) | To understand the queue size for a queue in equilibrium. |
| [`calc_relief_capacity()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_relief_capacity.md) | To calculate the relief capacity needed to bring a very large queue under control. |
| [`calc_target_capacity()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_target_capacity.md) | To understand the capacity required to keep a queue in equilibrium, depending on how much variability it experiences. |
| [`calc_waiting_list_pressure()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/calc_waiting_list_pressure.md) | A pressure measure, which can be used to compare multiple waiting lists for planning purposes. |

## Further reading

For examples of practical applications, and other considerations, see
the helpful “Case Studies” section towards the end of the [white
paper](https://www.medrxiv.org/content/10.1101/2022.08.23.22279117v1.full-text).

END
