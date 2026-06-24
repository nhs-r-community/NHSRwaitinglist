# Create a ggplot of an RTT improvement journey

Create a ggplot of an RTT improvement journey

## Usage

``` r
plot_rtt_journey(
  referral_rate,
  rtt_performance = c(0.5, 0.6, 0.7, 0.8, 0.92),
  n_bins = 64
)
```

## Arguments

- referral_rate:

  numeric. A weekly referral rate to plot

- rtt_performance:

  numeric vector. A vector of performance thresholds, as proportion e.g.
  0.65 = 65%.

- n_bins:

  numeric. Number of bins for histogram. Default is 1 - 64 weeks.

## Value

ggplot object
