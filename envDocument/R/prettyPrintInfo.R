#' Output environment information as individual tables per section
#' 
#' Uses \code{knitr::kable} to pretty-print separate tables for each
#' 'section' (list element) in the enviromnent information.
#' 
#' @param info_list R list with environment information
#' 
prettyPrintInfo <- function(info_list = list()) {
  # make sure knitr is available
  if (!requireNamespace("knitr", quietly = TRUE)) {
    stop("Package knitr is not available and is needed for this function to work.",
         call. = FALSE)
  }
  
  # need to catch output from sapply so it doesn't print.
  discard <- sapply(names(info_list), prettyPrintSection, info_list)
  
}

# internal function that formats individual sections
prettyPrintSection <- function(section_name, info_list) {
  print( knitr::kable(info_list[[section_name]], 
                      caption = paste(section_name, "Information", sep = " ")))
}