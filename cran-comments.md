## Release summary

This is the first release of a package implementing R functions associated with waiting list management, aimed 
at the UK's National Health Service (NHS), and this package is a collaborative effort from the
NHS-R Community.  This package support a preprint tutorial paper and series of webinars, with paper available
at https://www.medrxiv.org/content/10.1101/2022.08.23.22279117v1.full.

Package includes:
* Functions applying queuing theory methods to waiting list inputs.
* Calculations for target values for managing lists.
* Functions for simulating waiting list.
* Functions to allow scheduling and prioritisation

## Test environments
* local windows 10 Enterprise, 22H2, R 4.4.3

* R-devel and release, on Win-builder

* GitHub actions:
  * Mac OS x 14.7.4 23H420, R 4.4.3
  * Windows Server x64 2022 Datacentre, 10.0.20348, R 4.4.3
  * Ubuntu 24.04.2 LTS, R-devel 2025-03-25
  * Ubuntu 24.04.4 LTS, R 4.3.3
  * Ubuntu 24.04.4 LTS, R 4.3.3

* r-hub v2 via GitHub actions:
  * Ubuntu Linux 22.04.4 LTS, R-release, GCC
  * Mac OS-arm x 14.4.1 23E224, R 4.3.3
  * Mac OS-arm x 14.4.1 23E224, R-devel 2024-04-12
  * Fedora Linux, R-devel 2024-04-12, clang, gfortran
  * Windows Server 2022, R-devel 2024-04-12, 64 bit

## R CMD check results
There were no ERRORs, WARNINGs or NOTES.

## Downstream dependencies
There are currently no downstream dependencies for this package to my knowledge.