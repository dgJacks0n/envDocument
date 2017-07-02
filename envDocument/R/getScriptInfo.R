#' Get information about the  calling script 
#' 
#' \code{getScriptInfo} retrieves the  file path and  modification time
#' for the calling script.  
#' 
#' Note:
#' Currently this works if the script was called via source(),
#' knitr::spin(),  Rstudio's _compile notebook_ (ctrl-shift-K), 
#' Rscript or R -f.  
#' 
#' 
#' @examples 
#' script_info <- getScriptInfo()
#' @export
#' 

getScriptInfo <- function() {
  mtime <- NA
  path <- try(getScriptPath(), silent = TRUE)
  
  if (class(path) == "try-error") {
    warning(path)
    return(infoNotFound())
  } 
  
  scrinfo <- rbind(data.frame(Name = "Path", Value = path),
                   data.frame(Name = "Modified",
                              Value = as.character(file.info(path)$mtime))
  )
  
  return(scrinfo)
}
