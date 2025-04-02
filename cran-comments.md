## Release summary

This is the resubmission, after comments from Benni Altmann.
This a first release of a package implementing R functions associated with waiting list management, aimed 
at the UK's National Health Service (NHS). This package is a collaborative effort from the
NHS-R Community.  This package support a preprint tutorial paper and series of webinars, with paper available
at https://www.medrxiv.org/content/10.1101/2022.08.23.22279117v1.full.

Package includes:
* Functions applying queuing theory methods to waiting list inputs.
* Calculations for target values for managing lists.
* Functions for simulating waiting list.
* Functions to allow scheduling and prioritisation.

### Fixes based on pretest results, and email from CRAN team:
* Altered Title and Description in DESCRIPTION to follow guidance/comments
* Added brackets around year in reference.
* Uncommented examples in wl_join()
* Removed all \dontnotrun() tags
* Added noRd tag to two internal functions


## Test environments
* local windows 10 Enterprise, 22H2, R 4.4.3

* R-devel and release, on Win-builder

* GitHub actions:
  * Mac OS x 14.7.4 23H420, R 4.4.3
  * Windows Server x64 2022 Datacentre, 10.0.20348, R 4.4.3
  * Ubuntu 24.04.2 LTS, R-devel 2025-03-25
  * Ubuntu 24.04.4 LTS, R 4.4.3
  * Ubuntu 24.04.4 LTS, R 4.3.3

* r-hub v2 via GitHub actions: 
  * Results at: https://github.com/chrismainey/NHSRwaitinglist/actions/runs/14217992826
  * "Ubuntu-clang" 24.04.2 LTS, R-devel 2025-03-26 r88060
  * "Ubuntu-next" 24.04.2 LTS,  R version 4.5.0 alpha (2025-03-25 r88054)
  * "linux (R-devel)"" Ubuntu 24.04.2 LTS,  R Under development (unstable) (2025-03-26 r88060)
  * "intel" Ubuntu 24.04.2 LTS, R Under development (unstable) (2025-03-26 r88060)
  * "mkl"  Ubuntu 24.04.2 LTS,  Under development (unstable) (2025-03-26 r88060)
  * "rchk" Ubuntu 24.04.2 LTS,  Under development (unstable) (2025-03-26 r88060)  -  failed, unable to load post-test artifacts
  * "macos" Mac OS x 13.7.4 22H420, R Under development (unstable) (2025-03-25 r88054)
  * "windows" Windows Server x64 2022 Datacentre, 10.0.20348, R Under development (unstable) (2025-03-26 r88060 ucrt)
  
## R CMD check results
There were no ERRORs, WARNINGs.
A number of builds report NOTE of potential misspelling in DESCRIPTION for Fong, et, al, and NHS.  All are correct.

## Downstream dependencies
There are currently no downstream dependencies for this package to my knowledge.