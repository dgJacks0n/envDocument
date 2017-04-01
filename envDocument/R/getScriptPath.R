#' Get the path of the calling script
#' 
#' \code{getScriptPath} returns the full path of the script that called this function (if any)
#' or NULL if path is not available
#' 
#' @param absolute Return absolute path (absolute = TRUE, default) or path relative
#' to working directory
#' 
#' @aliases get_scriptpath
#' 
#' @examples 
#' mypath <- getScriptPath()
#' 
#' @export
#' 
getScriptPath <- function(absolute = TRUE) {
  # not relevant in interactive mode
  if(interactive()) {
    warning("Unable to determine script path in interactive mode")
    return(NA)
  }
  
  # location of script can depend on how it was invoked:
  # source() and knit() put it in sys.calls()
  path <- NULL
  
  if(!is.null(sys.calls())) {
    # get name of script - hope this is consistent!
    path <- as.character(sys.call(1))[2] 
    # make sure we got a file that ends in .R, .Rmd or .Rnw
  } else{
    # Rscript and R -f put it in commandArgs
    args <- commandArgs(trailingOnly = FALSE)
    path <- args
  }
  
  if ( !(grepl(".+[R|Rmd|Rnw]$", path, perl=TRUE, ignore.case = TRUE)) )  {
    warning("Obtained value for path <", path, "> does not end with .R, .Rmd or .Rnw: ", path)

    return(NA)
  }
  
  # expand ~ if any
  path <- normalizePath(path, winslash = "/")
  
  # if absolute path is requested then return full path
  # otherwise return relative to working directory
  if(!absolute) {
    path <- sub(normalizePath(getwd(), winslash = "/"), ".", path, fixed = TRUE)
  }
  
  return(path)
}

# alias for backward compatibility

#' @export
get_scriptpath <- getScriptPath
