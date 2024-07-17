<!-- badges: start -->
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-6-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/nhs-r-community/NHSRwaitinglist/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nhs-r-community/NHSRwaitinglist/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/nhs-r-community/NHSRwaitinglist/branch/main/graph/badge.svg)](https://app.codecov.io/gh/nhs-r-community/NHSRwaitinglist?branch=main)


<!-- badges: end -->


# NHSRwaitinglist <a alt="NHS-R Community's logo" href='https://nhsrcommunity.com/'><img src='https://nhs-r-community.github.io/assets/logo/nhsr-logo.png' align="right" height="80" /></a>

An R-package to implement the waiting list management approach described in the paper [Understanding Waiting Lists Pressures](https://www.medrxiv.org/content/10.1101/2022.08.23.22279117v1) by Fong et al.


# Installation 

You can install the current version of {name of package} from GitHub with:

```{r}

# install.packages("remotes")
remotes::install_github("nhs-r-community/NHSRwaitinglist", build_vignettes = TRUE)

```

## Contributing

If you want to learn more about this project, please join the discussion at the [NHS-R Community Slack](https://nhsrway.nhsrcommunity.com/community-handbook.html#slack) group and the specific channel #managing-waiting-lists.

Please see our 
[guidance on how to contribute](https://tools.nhsrcommunity.com/contribution.html).

This project is released with a Contributor [Code of Conduct](./CODE_OF_CONDUCT.md). 
By contributing to this project, you agree to abide by its terms.

The simplest way to contribute is to raise an issue detailing the feature or functionality you would like to see added, or any unexpected behaviour or bugs you have experienced.

### Pull-Request workflow

You are welcome to also submit Pull Requests and, as the `main` branch is protected and won't accept pushes directly even if you have been added to the repository as a member, the workflow will be (from your own forked repository if you are not a member, or a clone of the repository if you are a member):

* Create new branch with a descriptive name
* Commit to the new branch (add code or delete code or make changes)
* Push the commits 
* Create a pull-request in GitHub to signal that your work is ready to be merged
* Tag one or more reviewers (@ThomUK and @ChrisMainey) so that your contribution can be reviewed and merged into main


## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jacgrout"><img src="https://avatars.githubusercontent.com/u/103451105?v=4?s=100" width="100px;" alt="Jacqueline Grout"/><br /><sub><b>Jacqueline Grout</b></sub></a><br /><a href="#ideas-jacgrout" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/nhs-r-community/NHSRwaitinglist/commits?author=jacgrout" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ThomUK"><img src="https://avatars.githubusercontent.com/u/10871342?v=4?s=100" width="100px;" alt="Tom Smith"/><br /><sub><b>Tom Smith</b></sub></a><br /><a href="https://github.com/nhs-r-community/NHSRwaitinglist/commits?author=ThomUK" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://matt-dray.com"><img src="https://avatars.githubusercontent.com/u/18232097?v=4?s=100" width="100px;" alt="Matt Dray"/><br /><sub><b>Matt Dray</b></sub></a><br /><a href="https://github.com/nhs-r-community/NHSRwaitinglist/commits?author=matt-dray" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/kaituna"><img src="https://avatars.githubusercontent.com/u/151142766?v=4?s=100" width="100px;" alt="kaituna"/><br /><sub><b>kaituna</b></sub></a><br /><a href="https://github.com/nhs-r-community/NHSRwaitinglist/commits?author=kaituna" title="Documentation">📖</a> <a href="https://github.com/nhs-r-community/NHSRwaitinglist/commits?author=kaituna" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/chrismainey"><img src="https://avatars.githubusercontent.com/u/39626211?v=4?s=100" width="100px;" alt="Chris Mainey"/><br /><sub><b>Chris Mainey</b></sub></a><br /><a href="https://github.com/nhs-r-community/NHSRwaitinglist/commits?author=chrismainey" title="Code">💻</a> <a href="https://github.com/nhs-r-community/NHSRwaitinglist/commits?author=chrismainey" title="Documentation">📖</a> <a href="https://github.com/nhs-r-community/NHSRwaitinglist/commits?author=chrismainey" title="Tests">⚠️</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/PeterSNHS"><img src="https://avatars.githubusercontent.com/u/67410797?v=4?s=100" width="100px;" alt="PeterSNHS"/><br /><sub><b>PeterSNHS</b></sub></a><br /><a href="https://github.com/nhs-r-community/NHSRwaitinglist/commits?author=PeterSNHS" title="Documentation">📖</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!