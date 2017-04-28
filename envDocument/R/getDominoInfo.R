#' Get information about a Domino run from environment variables
#' 
#' @export

getDominoInfo <- function() {
  domino_varnames <- c("DOMINO_PROJECT_NAME", "DOMINO_API_HOST", "DOMINO_RUN_ID", "DOMINO_RUN_NUMBER", 
                       "DOMINO_WORKING_DIR", "DOMINO_STARTING_USERNAME")
  
  domino_values <- Sys.getenv(domino_varnames)
  
  # did we get values?
  if(nchar(domino_values["DOMINO_RUN_ID"]) == 0) {
    stop("No Domino Run ID found")
  }
  
  domino_values <- data.frame(domino_values, stringsAsFactors = FALSE)
  colnames(domino_values) <- "Value"
  
  domino_values$Name <- sub("^DOMINO_", "", rownames(domino_values))
  domino_values <- domino_values[c("Name", "Value")]
  rownames(domino_values) <- NULL
  
  return(domino_values)
  
}

