envDocument
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
A R package to report various aspects of the environment in which an analysis was run. This includes system information, packages used, working directory, script path and git repository (if any; uses git2r).

Output can be returned as a data table, printed, or formatted using `knitr::kable`.

Usage
=====

``` r

# get environment information as a data frame
info <- env_doc()

# format environment information as a table
env_doc("table")

# print environment information
env_doc("print")
```
