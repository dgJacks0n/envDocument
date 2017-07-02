#' Get information about a Domino run from environment variables
#' 
#' @export

getDominoInfo <- function() {
  domino_varnames <- c("DOMINO_API_HOST", "DOMINO_PROJECT_NAME", "DOMINO_PROJECT_OWNER",
                       "DOMINO_RUN_ID", "DOMINO_RUN_NUMBER", "DOMINO_STARTING_USERNAME",
                       "DOMINO_WORKING_DIR")
  
  domino_values <- Sys.getenv(domino_varnames)
  
  # Return 'not found' values if no info was found
  if(nchar(domino_values["DOMINO_RUN_ID"]) == 0) {
    warning("Domino environment variables not found")
    return(infoNotFound())
  }
  
  # strip port off of DOMINO_API_HOST to get sever
  domino_values["DOMINO_SERVER"] <- sub(":\\d+$", "", 
                                        domino_values["DOMINO_API_HOST"])
  
  # build url
  domino_values["DOMINO_RUN_URL"] <- paste(domino_values["DOMINO_SERVER"],
                                           "u",
                                           domino_values["DOMINO_PROJECT_OWNER"],
                                           domino_values["DOMINO_PROJECT_NAME"],
                                           "runs",
                                           domino_values["DOMINO_RUN_ID"],
                                           sep = "/")
  domino_values["DOMINO_RUN_URL"] <- paste0(domino_values["DOMINO_RUN_URL"], "#info")  

  
  
  domino_values <- data.frame(domino_values, stringsAsFactors = FALSE)
  colnames(domino_values) <- "Value"
  
  # format variable names
  domino_values$Name <- sub("^DOMINO_", "", rownames(domino_values))
  domino_values$Name <- gsub("_", " ", domino_values$Name)
  
  # titlecase variable names if stringr is available
  if(requireNamespace("stringr", quietly = TRUE)) {
    domino_values$Name <- stringr::str_to_title(domino_values$Name)
  }
  
  domino_values <- domino_values[c("Name", "Value")]
  rownames(domino_values) <- NULL
  
  return(domino_values)
  
}

