<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/nhs-r-community/NHSRwaitinglist/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nhs-r-community/NHSRwaitinglist/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/nhs-r-community/NHSRwaitinglist/branch/main/graph/badge.svg)](https://app.codecov.io/gh/nhs-r-community/NHSRwaitinglist?branch=main)


<!-- badges: end -->


# NHSRwaitinglist <a alt="NHS-R Community's logo" href='https://nhsrcommunity.com/'><img src='https://nhs-r-community.github.io/assets/logo/nhsr-logo.png' align="right" height="80" /></a>

An R-package to implement the waiting list management approach described in the paper [Understanding Waiting Lists Pressures](https://www.medrxiv.org/content/10.1101/2022.08.23.22279117v1) by Fong et al.


## To install the package, run:
``` r
remotes::install_github("nhs-r-community/NHSRwaitinglist", build_vignettes = TRUE)
```


## Contribution

This is an NHS-R Community project that is open for anyone to contribute to in any way that they are able. Please see the [NHS-R Way](https://nhsrway.nhsrcommunity.com/style-guides.html) to read more on the style guides and for [Code of Conduct](https://nhsrway.nhsrcommunity.com/code-of-conduct.html) related to any activity or contribution to the NHS-R Community as well as the Code of Conduct in this repository which is generated using `usethis::use_code_of_conduct(contact = "nhs.rcommunity@nhs.net")`.
By contributing to this project, you agree to abide by these terms.

If you want to learn more about this project, please join the discussion at the [NHS-R Community Slack](https://nhsrway.nhsrcommunity.com/community-handbook.html#slack) group and the specific channel #managing-waiting-lists.

The simplest way to contribute is to raise an issue detailing the feature or functionality you would like to see added, or any unexpected behaviour or bugs you have experienced.

### Pull-Request workflow

You are welcome to also submit Pull Requests and, as the `main` branch is protected and won't accept pushes directly even if you have been added to the repository as a member, the workflow will be (from your own forked repository if you are not a member, or a clone of the repository if you are a member):

* Create new branch with a descriptive name
* Commit to the new branch (add code or delete code or make changes)
* Push the commits 
* Create a pull-request in GitHub to signal that your work is ready to be merged
* Tag one or more reviewers so that your contribution can be reviewed and merged into `main`
