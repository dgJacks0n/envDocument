#' Output environment information as individual tables per section
#' 
#' Uses \code{knitr::kable} to pretty-print separate tables for each
#' 'section' (list element) in the enviromnent information.
#' 
prettyPrintInfo <- function(info_list = list()) {
  discard <- sapply(names(info_list), prettyPrintSection, info_list)
}


prettyPrintSection <- function(section_name, info_list) {
  print( knitr::kable(info_list[[section_name]], 
                      caption = paste(section_name, "Information", sep = " ")))
}