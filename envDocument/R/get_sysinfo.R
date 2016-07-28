#' Get system information.  
#' 
#'   
#' \code{get_sysinfo} returns the OS, hostname, userid and working directory
#'  for the current analysis as a data frame
#' 
#' @examples 
#' get_sysinfo()
#' 
#' @export
#' 
get_sysinfo <- function() {
  sysinfo <- data.frame( Section = "System",
                         Name = names(Sys.info()), 
                         Value = unname(Sys.info()))
  
  cwd <- data.frame( Section = "System", Name = "Directory", Value = getwd() )
  
  sysinfo <- rbind(sysinfo, cwd)  
  
  return(sysinfo) 
}
