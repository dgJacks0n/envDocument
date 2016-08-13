#' Get information about the  calling script 
#' 
#' \code{get_scriptinfo} retrieves the  file path and  modification time
#' for the calling script.  
#' 
#' Note:
#' Currently this works if the script was called via source(),
#' knitr::spin() or Rstudio's _compile notebook_ (ctrl-shift-K).
#' It does not work if the script was called via 'R -f' or 'Rscript'.
#' In those cases NAs are returned for the path and mod. time.
#' A later version should capture additional cases.
#' 
#' @examples 
#' scriptinfo <- get_scriptinfo()
#' @export
#' 
get_scriptinfo <- function() {
  mtime <- NULL
  path <- get_scriptpath()
  
  if(!is.null(path)) {
    mtime <- file.info(path)$mtime
  }
  scrinfo <- rbind(data.frame(Name = "Path", Value = path),
                   data.frame(Name = "Modified",
                              Value = as.character(mtime))
  )
  return(scrinfo)
}
