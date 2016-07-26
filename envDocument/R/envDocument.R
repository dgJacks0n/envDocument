#' Document the environment under which an analysis was performed
#' 
#' Provides a method \code{\link{env_doc}} that collects information on the script,
#' environment and system that performed an analysis including:
#'
#' - R version
#' - Attacheded packages and version
#' - OS, version and user
#' - Path and modification time of the calling script
#' - Git commit and tag info (optional, requires \code{\link{git2r}})
#' 
#' Results are collected in a standardized data frame that can be
#' queried or pretty-printed using knitr::kable() or similar methods.
#' 
"_PACKAGE"
#> [1] "_PACKAGE"