#' Report the working environment in which an analysis was performed.
#' 
#' \code{env_doc} prints or returns a data frame with the following information:  
#' - System version (OS, version, user, working directory)  
#' 
#' - R version  
#' 
#' - Package names and versions  
#' 
#' - Top-level script name and modification time  
#' 
#' - Git hash, status and tag (if any; requires package git2r)  
#'
#' @param output How should output be handled? Character, values: 
#'   return - return as a data frame (default);
#'    print - print to stdout; 
#'    table - pretty-print
#'   using knitr::kable (requires package knitr)
#' @param system Include OS info from \code{\link{getSysInfo}}? Boolean, 
#'   default TRUE
#' @param version Include R version from \code{\link{getRversion}}?  
#'   Boolean, default TRUE
#' @param packages Include attached packages with repository and version from 
#'   \code{\link{getPackageInfo}}? Boolean, default TRUE
#' @param script Include script path and modification time from 
#'   \code{\link{getScriptInfo}}? Boolean, default TRUE
#' @param git Include git repository information from \code{\link{getGitInfo}}
#'   (note: requires \code{git2r})?  Boolean, default TRUE
#' @param domino Include Domino Datalab run information from 
#'   \code{\link{getDominoInfo}}?  Character, values:
#'   auto - include if available; 
#'   on - include with warning if not available; 
#'   off - do not include evn if available
#'   
#' @return If output = return (default): A data frame with columns for information 
#'   type, variable name and value.  NULL for output = print or output = table
#'  
#' @examples
#'  env_doc("print") # print information to stdout
#'  info <- env_doc() # return information as a consolidated data frame
#' @export
#' 
env_doc <- function ( output=c("return", "print", "table"), system=TRUE, version=TRUE, 
                      packages=TRUE, script=TRUE, git = TRUE, domino = c("auto", "on", "off")) {
  
  envinfo <- list()
  
  if(system) {
    envinfo$System  <- getSysInfo()
  }
  
  if(version) {
    envinfo$R <- get_Rversion()
  }
  
  if(packages) {
    envinfo$Packages <- getPackageInfo()
  }
  
  if(script) {
    envinfo$Script <- getScriptInfo()
  }
  
  if(git) {
    envinfo$Git <- getGitInfo()
  }
  
  # should we include domino table?
  if ((match.arg(domino) == "on")) {
    envinfo$Domino <- getDominoInfo()
  } else if(match.arg(domino) == "auto" & any(grepl("^DOMINO_", names(Sys.getenv())))) {
    envinfo$Domino <- getDominoInfo()
  }
  
  
  # once info is collected either format, print it or return it
  if( match.arg(output) == "table") {
    prettyPrintInfo(envinfo)
  }

  # flatten list to data frame for unformatted print or return
  einfo_df <- collapseInfo(envinfo)
  
  if( match.arg(output) == "print") { 
    print(einfo_df)
  } 

  if( match.arg(output) == "return") {
    return(einfo_df)
  }
}
