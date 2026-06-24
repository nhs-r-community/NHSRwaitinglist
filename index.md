# NHSRwaitinglist

[![](https://nhs-r-community.github.io/assets/logo/nhsr-logo.png)](https://nhsrcommunity.com/)

{NHSRwaitinglist} is an R package implementing the waiting list
management approach described in the paper [Understanding Waiting Lists
Pressures](https://www.medrxiv.org/content/10.1101/2022.08.23.22279117v1)
by Fong et al (2022). The methodology is presented by Neil Walton,
Professor in Operations Management at Durham University Business School.
The package is being contributed to by members of the [NHS-R
Community](https://nhsrcommunity.com/), with the aim of making it
simpler for NHS analysts to adopt these methods for the analysis of
their own waiting lists.

## Explanatory Videos

These videos explain more about the Operations Management methodologies
which are encapsulated by the package. Click through to view them on
YouTube.

| Detailed presentation of method | Recap of method, and presentation of this package |
|:--:|:--:|
| [![Thumbnail for link to MAN huddle video](reference/figures/NHSRwaitinglist_MAN_huddle_thumbnail.jpg)](https://www.youtube.com/watch?v=NWthhW5Fgls) | [![Thumbnail for link to Health and Care Analytics Conference E-lab video](reference/figures/NHSRwaitinglist_HACA_elab_thumbnail.jpg)](https://www.youtube.com/watch?v=3peqTEl_ZAQ) |
| Midlands Analyst Network Huddle, Nov 2023 | Health and Care Analytics Conference e-lab, Jul 2024 |

## Installation

You can install the current version of {NHSRwaitinglist} from GitHub as
below.  
If you have not installed from GitHub before, you may first need to
create and store a “Personal Access Token” (PAT) to grant access to your
account, for example by following the [{usethis}
guide](https://usethis.r-lib.org/articles/git-credentials.html#get-a-personal-access-token-pat).

``` r

# Install from CRAN
install.packages("NHSRwaitinglist")

# install.packages("remotes")
remotes::install_github("nhs-r-community/NHSRwaitinglist", build_vignettes = TRUE)
```

## Getting Started

There is a minimal example below. To look in more detail at the
functions within the package and some more ways of using them, it is a
good idea to review the first two vignettes:

1.  The [example
    walkthrough](https://nhs-r-community.github.io/NHSRwaitinglist/articles/example_walkthrough.html)
    vignette takes a step-by-step walk through the white paper, using
    the six core functions in this package.  
2.  The [three example waiting
    lists](https://nhs-r-community.github.io/NHSRwaitinglist/articles/three_example_waiting_lists.html)
    vignette simulates three closely related waiting lists, and uses
    package functions to explore some of their characteristics.

At its most basic, the package can be used to simulate a waiting list (a
dataframe of waiting list addition dates and removal dates), and then
compute some important statistics. Of course, if you already have
waiting list data ready to analyse, you can skip the simulation step in
the code below.

``` r

# load the package
library(NHSRwaitinglist)

# simulate a waiting list
waiting_list <- wl_simulator(
  start_date = "2020-01-01",
  end_date = "2024-03-31",
  demand = 10, # simulating 10 patient arrivals per week
  capacity = 10.2 # simulating 10.2 patients being treated per week
)

# compute some waiting list statistics
overall_stats <- wl_stats(
  waiting_list = waiting_list,
  target_wait = 18 # standard NHS 18wk target
)

# review the minimal dataset needed to define a waiting list (first 5 rows only)
knitr::kable(head(waiting_list, 5))
```

| Referral   | Removal    |
|:-----------|:-----------|
| 2020-01-02 | 2020-01-03 |
| 2020-01-03 | 2020-01-04 |
| 2020-01-04 | 2020-01-05 |
| 2020-01-04 | 2020-01-06 |
| 2020-01-06 | 2020-01-07 |

``` r


# review the waiting list statistics
knitr::kable(overall_stats)
```

| mean_demand | mean_capacity | load | load_too_big | count_demand | queue_size | target_queue_size | queue_too_big | mean_wait | cv_arrival | cv_removal | target_capacity | relief_capacity | pressure |
|---:|---:|---:|:---|---:|---:|---:|:---|---:|---:|---:|---:|:---|---:|
| 9.818065 | 10.08372 | 0.9736549 | FALSE | 2174 | 5 | 44.18129 | FALSE | 1.8 | 1.131775 | 0.7003787 | 10.01489 | NA | 0.2 |

## Reporting functions

In addition to the underlying method functions above, there are some
convenience functions designed to quickly product plots for RTT
improvement discussions with clinical specialties.
[`plot_rtt_journey()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/plot_rtt_journey.md)
produces plots as demonstrated below, while
[`rep_rtt_improvement()`](https://nhs-r-community.github.io/NHSRwaitinglist/reference/rep_rtt_improvement.md)
is a quarto report generating function that makes it easy to produce a
discussion document covering multiple referral rates.

``` r

# produce a single plot showing waiting list and RTT size for a specialty
# with a referral rate of 300 patients per week
plot_rtt_journey(300)
```

![](reference/figures/README-plot_rtt_journey-1.png)

## Contributing

If you want to learn more about this project, please join the discussion
at the [NHS-R Community Slack](https://nhsrcommunity.slack.com/) group
and the specific channel \#managing-waiting-lists.

Please see our [guidance on how to
contribute](https://tools.nhsrcommunity.com/contribution.html).

This project is released with a Contributor [Code of
Conduct](https://github.com/nhs-r-community/NHSRwaitinglist/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.

The simplest way to contribute is to [raise an
issue](https://github.com/nhs-r-community/NHSRwaitinglist/issues)
detailing the feature or functionality you would like to see added, or
any unexpected behaviour or bugs you have experienced.

### Pull-Request workflow

You are welcome to also submit Pull Requests and, as the `main` branch
is protected and won’t accept pushes directly even if you have been
added to the repository as a member, the workflow will be (from your own
forked repository if you are not a member, or a clone of the repository
if you are a member):

- Create new branch with a descriptive name
- Commit to the new branch (add code or delete code or make changes)
- Push the commits
- Create a pull-request in GitHub to signal that your work is ready to
  be merged
- Tag one or more reviewers (@ThomUK and @ChrisMainey) so that your
  contribution can be reviewed and merged into main

## Contributors ✨

Thanks goes to these wonderful people ([emoji
key](https://github.com/all-contributors/all-contributors/blob/master/docs/emoji-key.md)):

[TABLE]

This project follows the
[all-contributors](https://github.com/all-contributors/all-contributors)
specification. Contributions of any kind welcome!
