#' Get information on attached packages
#' 
#' \code{getPackageInfo} returns information on attached packages
#' including name, version and source.
#' 
#' @examples
#' packages <- getPackageInfo()
#' @export
#' 
getPackageInfo <- function() {
  packages <- utils::sessionInfo()[c("otherPkgs", "loadedOnly")]
  
  # collapse top level list
  packages <- unlist(packages, recursive = FALSE)

  # extract subset of information
  pkginfo <- lapply(packages, get_thispackageinfo)
  
  pkginfo_df <- do.call("rbind", pkginfo)
  
  rownames(pkginfo_df) <- NULL
  return(pkginfo_df)
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
