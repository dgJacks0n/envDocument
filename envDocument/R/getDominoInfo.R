#' Get information about a Domino Datalab run from environment variables in the run environment
#' 
#' @param drop_vars Variables that will not be included in results.  Character vector;
#'     see \url{https://support.dominodatalab.com/hc/en-us/articles/205536355-Domino-environment-variables}
#'     for a list of variables.
#' 
#' @return data frame of Domino environment variables (renamed) and their values
#' 
#' @export

getDominoInfo <- function(drop_vars = c("DOMINO_API_HOST", 
                                        "DOMINO_EXECUTOR_HOSTNAME",
                                        "DOMINO_USER_API_KEY")) {
  # get list of domino environment vars
  domino_varnames <- grep("^DOMINO_", names(Sys.getenv()), value = TRUE)
  
  # Return 'not found' values if no info was found
  if(length(domino_varnames) == 0) {
    warning("Domino environment variables not found")
    return(infoNotFound())
  }
  

  domino_values <- Sys.getenv(domino_varnames)
  
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
  
  # drop variables in 'no_return' from output
  domino_values <- domino_values[!(rownames(domino_values) %in% drop_vars), ]
  
  
  rownames(domino_values) <- NULL
  
  return(domino_values)
  
}

