#' Get information on attached packages
#' 
#' \code{get_packageinfo} returns information on attached packages
#' including name, version and source.
#' 
#' @examples
#' packages <- get_packageinfo()
#' @export
get_packageinfo <- function() {
  packages <- sessionInfo()["otherPkgs"]$otherPkgs
  pkginfo <- data.frame()
  
  for (i in 1:length(packages)) {
    pkginfo <- rbind(pkginfo, get_thispackageinfo(packages[[i]]))
  }
  return(pkginfo)
}


# get_thispackageinfo
#
# helper for get_packageinfo.  Extracts selected info on individual packages.  

get_thispackageinfo <- function(thisPackage){
  thisinfo <- data.frame( Name = ifelse(is.null(thisPackage$Package), "NA",
                                        thisPackage$Package),
                          Value = paste( ifelse(is.null(thisPackage$Version), "NA",thisPackage$Version),
                                         ifelse(is.null(thisPackage$Repository), "NA", thisPackage$Repository),
                                         ifelse(is.null(thisPackage$Repository), "NA",  thisPackage$Repository),
                                         ifelse(is.null(thisPackage$Date), "NA", thisPackage$Date)
                          )
  )
  return(thisinfo)
  
}
