## Test environments
Tests were run using rhub::rhub_check()

* linux: All R versions on GitHub Actions ubuntu-latest
* m1-san: All R versions on GitHub Actions macos-15, ASAN + UBSAN on macOS
* macos-arm64: All R versions on GitHub Actions macos-latest
* windows: All R versions on GitHub Actions windows-latest
* ubuntu-next: R version 4.5.1 Patched (2025-08-23 r88798) on Ubuntu 22.04.5 LTS
* ubuntu-release: R version 4.5.1 (2025-06-13) on Ubuntu 22.04.5 LTS

Local test: R version 4.2.2 (2022-10-31) on Mac OsX darwin20

## R CMD check results
There were no ERRORs or WARNINGs 

NOTES
This is update release 2.4.2.  It provides a new function to get status of the
renv lockfile if used. It also determines the path and filename of 
Quarto markdown documents (requires quarto version 1.7 or higher)

## Reverse Dependency Checks
From devtools::revdep()

character(0)