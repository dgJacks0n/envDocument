#' Output environment information as individual tables per section
#' 
#' Uses \code{knitr::kable} to pretty-print separate tables for each
#' 'section' (list element) in the enviromnent information.
#' 
prettyPrintInfo <- function(info_list = list()) {
  # make sure knitr is available
  if (!requireNamespace("knitr", quietly = TRUE)) {
    stop("Package knitr needed for this function to work. ",
         call. = FALSE)
  }
  
  # cache results setting, change to asis so kable results are formatted
  chunk_results <- knitr::opts_current$get("results")
  knitr::opts_chunk$set(results = "asis")
  
  discard <- sapply(names(info_list), prettyPrintSection, info_list)
  
  # restore existing chunk results
  knitr::opts_chunk$set(results = chunk_results)
  
}


prettyPrintSection <- function(section_name, info_list) {
  print( knitr::kable(info_list[[section_name]], 
                      caption = paste(section_name, "Information", sep = " ")))
}