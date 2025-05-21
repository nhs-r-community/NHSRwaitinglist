## Release summary

This a second release of NHSRwaitinglist, and fixes small bugs and documentation issues, as well as adding a further vignette.

### Fixes based on pretest results, and email from CRAN team:
* Update DESCRIPTION author list and added GitHub links
* Added waiting_list_sim vignette
* Updated wl_insert() functions
* Arguments harmonised across functions
* Updates to error handling and metadata in wl_simulator()


## Test environments
* local windows 10 Enterprise, 22H2, R 4.5.0

* R-devel and release, on Win-builder

* GitHub actions:
  * Mac OS aarch64-apple-darwin20, R 4.5.0
  * Windows Server x64 2022 Datacentre, 10.0.20348, R 4.5.0
  * Ubuntu 24.04.2 LTS, R-devel 2025-04-26 r88181
  * Ubuntu 24.04.2 LTS, R 4.5.0
  * Ubuntu 24.04.2 LTS, R 4.4.3

* r-hub v2 via GitHub actions: 
  * Results at: https://github.com/chrismainey/NHSRwaitinglist/actions/runs/14711639513/job/41285258415
  * "Ubuntu-clang" 22.04.5 LTS, R-devel (unstable) (2025-04-26 r88060)
  * "Ubuntu-next" 22.04.5 LTS,  R version 4.5.0 patched (2025-03-25 r88054)
  * "intel" Fedora 38, R Under development (unstable) (2025-04-26 r881810)
  * "mkl"  Fedora 38,  Under development (unstable) (2025-04-26 r88060)
  * "rchk" Ubuntu 22.04.5 LTS,  Under development (unstable) (2025-04-26 r88060)  -  failed, unable to load post-test artifacts
  * "macos" Ventura 13.7.5, R Under development (unstable) (2025-04-22 r88173)
  * "windows" Windows Server 2022 Datacenter x64 (build 20348),  R Under development (unstable) (2025-04-26 r88181 ucrt)
  
## R CMD check results
There were no ERRORs, WARNINGs.
Previous CRAN pre-checks gave NOTE of potential misspelling in DESCRIPTION for Fong, et, al, and NHS.  All are correct.

## Downstream dependencies
There are currently no downstream dependencies for this package to my knowledge.