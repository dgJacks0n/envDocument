#' get_packageinfo
#' 
#' Get information on attached packages

get_packageinfo <- function() {
  packages <- sessionInfo()["otherPkgs"]$otherPkgs
  pkginfo <- data.frame()
  
  for (i in 1:length(packages)) {
    pkginfo <- rbind(pkginfo, get_thispackageinfo(packages[[i]]))
  }
  return(pkginfo)
}

#' get_thispackageinfo
#'
#' extract selected info on individual packages

get_thispackageinfo <- function(thisPackage){
  thisinfo <- data.frame( Name = ifelse(is.null(thisPackage$Package), "NA",
                                        thisPackage$Package),
                          Version = ifelse(is.null(thisPackage$Version), "NA",
                                           thisPackage$Version),
                          Repository = ifelse(is.null(thisPackage$Repository), "NA",
                                              thisPackage$Repository),
                          Build_Date = ifelse(is.null(thisPackage$Date), "NA",
                                              thisPackage$Date)
  )
  return(thisinfo)
  
}


#' get_rversion
#' 
#' get selected info on R version

get_rversion <- function() {
  rv <- R.Version()
  rinfo <- data.frame(
                       Version  = paste(rv$major, rv$minor, sep = "."), 
                       Build_Date = paste(rv$year, rv$month, rv$day, sep = "-")
  )
  return(rinfo)
  
}


#' get_sysinfo  
#' 
#' get system information

get_sysinfo <- function() {
  sysinfo <- data.frame( Name = names(Sys.info()), 
                         Value = unname(Sys.info()))
  
  return(sysinfo) 
}

# print_table  
# pretty-print system info as kable formatted table.
# problem - I need to figure out how to suppress knitr's comment prefix 
# not ready for use yet.
# print_table <- function(envinfo) {
#    print("Environment Information")
#   for (i in 1:length(envinfo)) {
#     # ideally format with levels
#     title <- paste( names(envinfo)[i], "Information")
#     print(title)
#     # wrap in tryCatch, default to just printing envinfo?
#     print(knitr::kable(envinfo[[i]], format="markdown", row.names=FALSE, caption=title))
#   }
# }

env_doc <- function ( system = TRUE,
                      version = TRUE,
                      packages = TRUE,
                      directory = TRUE,
                      output = c("print", "return")
) {
  
  envinfo <- list()
  
  
  if(system) {
    envinfo$System  <- get_sysinfo()
  }
  
  if(version) {
    envinfo$R <- get_rversion()
  }
  
  if(packages) {
    envinfo$Packages <- get_packageinfo()
  }
  
  if(directory) {
    envinfo$Directory <- data.frame( Path = getwd() )
  }
  
  # once info is collected either print it or return it
  if( match.arg(output) == "print") { 
    print(envinfo)
  } 
  else {
    return(envinfo)
  }
}
