#' Get the path of the calling script
#' 
#' \code{getScriptPath} returns the full path of the script that called this function (if any)
#' or NULL if path is not available
#' 
#' @param absolute Return absolute path (absolute = TRUE, default) or path relative
#' to working directory (FALSE)
#' 
#' @aliases get_scriptpath
#' 
#' @examples
#' \dontrun{ 
#' mypath <- getScriptPath() 
#' }
#'
#' @export
#' 
getScriptPath <- function(absolute = TRUE) {
  path <- NULL
  
  # location of script can depend on how it was invoked:
  # quarto render puts it in environment variables but ONLY
  # for versions >= 1.7
  if(!is.na( Sys.getenv("QUARTO_DOCUMENT_FILE", NA) )) {
    path <- file.path(Sys.getenv("QUARTO_PROJECT_ROOT"),
                      Sys.getenv("QUARTO_DOCUMENT_PATH"),
                      Sys.getenv("QUARTO_DOCUMENT_FILE"))
    
  } else  if(!is.null(knitr::current_input())) {
    # next try knitr::current input for Rmarkdown and for Quarto versions <1.7
    path <- knitr::current_input(dir = T)
      # change extension if quarto project?
      if(!is.na( Sys.getenv("QUARTO_DOCUMENT_PATH", NA))  ) {
        path <- sub("\\.rmarkdown$", ".qmd", path)
      }
  } else {
    # source() and knit() put it in sys.calls()
    if(!is.null(sys.calls())) {
      # get name of script - hope this is consistent!
      path <- as.character(sys.call(1))[2] 
    } else {
      # Rscript and R -f put it in commandArgs
      args <- commandArgs(trailingOnly = FALSE)
      path <- args
    }
  }
  
  if(is.null(path) | is.na(path)) {
    stop("No path information available.")
  }
  
  # make sure we got a file that ends in .R, .Rmd or .Rnw
  if ( !(grepl(".+[R|Rmd|Rnw|Qmd]$", path, perl=TRUE, ignore.case = TRUE)) )  {
    stop("Obtained value for path <", path, 
         "> does not end with .R, .Rmd, .Qmd or .Rnw: ", path)
  }
  
  # expand ~ if any
  path <- normalizePath(path, winslash = "/")
  
  # check that file exists
  if( !(file.exists(path))) {
    stop("Obtained value for path <", path,
         "> does not exist")
  }
  
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
