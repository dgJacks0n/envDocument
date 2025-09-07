#' Document the environment under which an analysis was performed
#' 
#' Provides a function \code{\link{env_doc}} that collects information on the
#' script, environment and system that performed an analysis.
#' 
#' Returns a data frame with information on:  
#' 
#'  - R version  
#' 
#'  - Attacheded packages and version   
#'  
#'  - OS, version and user
#'  
#'  - Path and modification time of the calling script   
#'  
#'   - Git commit and tag info (optional, requires 
#'       \code{git2r})
#' 
#' Results are collected in a standardized data frame that can be queried or
#' pretty-printed using \code{\link[knitr]{kable}} or similar methods.
#' 
"_PACKAGE"
#> [1] "_PACKAGE"

# note: this file contains no R code - only Roxygen2 comments
# used to generate package documentation