#' Get system information.  
#' 
#'   
#' \code{getSysInfo} returns the OS, hostname, userid and working directory
#'  for the current analysis as a data frame
#' 
#' @examples 
#' getSysInfo()
#' 
#' @export
#' 
getSysInfo <- function() {
  sysinfo <- data.frame( Name = names(Sys.info()), 
                         Value = unname(Sys.info()))
  
  cwd <- data.frame( Name = "Directory", Value = getwd() )
  
  sysinfo <- rbind(sysinfo, cwd)  
  
  return(sysinfo) 
}
