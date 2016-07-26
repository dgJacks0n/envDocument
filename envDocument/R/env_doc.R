#' env_doc
#' \code{env_doc} reports the working environment
#' 
#' Returns a data frame with information about the script, system
#' and environment
#' 
#'- System version (OS, version, user, working directory)
#'
#'- R version
#'
#'- Package names and versions
#'
#'- Top-level script name and modification time
#'
#'- Git hash, status and tag (if any; requires \code{\link{git2r}})
#'
#'
#' @param output How should output be handled? return: return as a 
#'   data frame (default); print: print to stdout
#' @param system Include OS info from get_sysinfo()? Default TRUE
#' @param version Include R version?  Default TRUE
#' @param packages Include packages with repository and version from get_packageinfo()? Default TRUE
#' @param script Include script path and modification time from get_scriptinfo()? Default TRUE
#' @param git Include git repository information? from get_gitInfo (note: requires git2r)?  Default TRUE
#'  
#' @examples
#'  env_doc("print") # print information to stdout
#'  info <- env_doc() # return information as a consolidated data frame
#' @export
env_doc <- function ( output=c("return", "print"), system=TRUE, version=TRUE, 
                      packages=TRUE, script=TRUE, git = TRUE ) {
  
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
  
  if(script) {
    envinfo$Script <- get_scriptinfo()
  }
  
  if(git) {
    # is git2r installed?
    if(!requireNamespace("git2r", quietly = TRUE)) {
      stop("Function get_gitinfo requires package git2r.  Either install it or use env_doc(git = FALSE)")
    }
    
    envinfo$Git <- get_gitInfo()
  }
  
  # flatten list to data frame
  einfo_df <- NULL
  for (envitem  in names(envinfo)) {
    if(!is.null(einfo_df)) {
      einfo_df <- rbind(einfo_df, envinfo[[envitem]])
    }
    else {
      einfo_df <- envinfo[[envitem]]
    }
  }
  
  # once info is collected either print it or return it
  if( match.arg(output) == "print") { 
    print(einfo_df)
    return(NULL)
  } 

  return(einfo_df)
}
