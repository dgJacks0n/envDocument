#' get_packageinfo
#' 
#' Get information on attached packages, return as a data frame
#' 
#' @param none
#' @examples
#' packages <- get_packageinfo

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
#' extract selected info on individual packages.  Called by get_packageinfo

get_thispackageinfo <- function(thisPackage){
  thisinfo <- data.frame( Section = "Packages",
                          Name = ifelse(is.null(thisPackage$Package), "NA",
                                        thisPackage$Package),
                          Value = paste( ifelse(is.null(thisPackage$Version), "NA",thisPackage$Version),
                                         ifelse(is.null(thisPackage$Repository), "NA", thisPackage$Repository),
                                         ifelse(is.null(thisPackage$Repository), "NA",  thisPackage$Repository),
                                         ifelse(is.null(thisPackage$Date), "NA", thisPackage$Date)
                          )
  )
  return(thisinfo)
  
}


#' get_rversion
#' 
#' Get selected info on R version
#' 
#' @param none
#' @examples
#' Rversion <- get_rversion()

get_rversion <- function() {
  rv <- R.Version()
  rinfo <- data.frame(Section = "R", Name = "Version", Value = R.version.string
  )
  return(rinfo)
  
}


#' Get information about the  calling script 
#' 
#' file name and path, last modification time.  
#' Currently this works if the script was called via source(),
#' knitr::spin() or Rstudio's _compile notebook_ (ctrl-shift-K).
#' It does not work if the script was called via 'R -f' or 'Rscript'.
#' In those cases NAs are returned for the path and mod. time.
#' A later version should capture additional cases.
#' 
#' @param none
#' @examples scriptinfo <- get_scriptinfo()
#' 
get_scriptinfo <- function() {
  mtime <- NULL
  path <- get_scriptpath()
  
  if(!is.null(path)) {
    mtime <- file.info(path)$mtime
  }
  scrinfo <- rbind(data.frame(Section = "Script", Name = "Path", Value = path),
                   data.frame(Section = "Script", Name = "Modified",
                              Value = as.character(mtime))
  )
  return(scrinfo)
}

#' get_scriptpath
#' Get the path of the calling script
#' 
#' Returns the full path of the script that called this function (if any)
#' or NULL if path is not available
#' 
#' @param none
#' @examples mypath <- get_scriptpath()

get_scriptpath <- function() {
  # location of script can depend on how it was invoked:
  # source() and knit() put it in sys.calls()
  path <- NULL
  
  if(!is.null(sys.calls())) {
    # get name of script - hope this is consisitent!
    path <- as.character(sys.call(1))[2] 
    # make sure we got a file that ends in .R
    if (grepl("..+\\.[R|.Rmd|Rnw$]", path, perl=TRUE, ignore.case = TRUE) )  {
      return(path)
    } else { 
      message("Obtained value for path does not end with .R ", path)
    }
  } else{
  # Rscript and R -f put it in commandArgs
    args <- commandArgs(trailingOnly = FALSE)
  }
  return(path)
}

# getRepo: get git repository from path
getRepo <- function(testPath) {
  # get location of repo that controls testPath
  repoPath <- git2r::discover_repository(testPath)
  
  if(is.null(repoPath)) {
    warning("Could not find repo directory for ", testPath)
    return(NULL)
  }
  
  repo <- git2r::repository(repoPath)
  
  # is file tracked in repo?
  untracked <- git2r::status(repo, staged = FALSE, unstaged = FALSE, untracked = TRUE)
  
  if(normalizePath(testPath) %in% normalizePath(unlist(untracked))) {
    warning("File ", testPath, " is not tracked in repostitory ", repoPath)
    return(NULL)
  }
  
  return(repo)
  
}

# has file been modified?
fileStatus <- function(repo, testPath) {
  testStatus <- NULL
  
  statusVals <- unlist(git2r::status(repo))
  hasStatus <-  normalizePath(testPath) == normalizePath(statusVals)
  
  if(any(hasStatus)) {
    testStatus <- paste(names(statusVals[hasStatus]), collapse = ", ")
  } else {
    testStatus <- "committed"
  }
  
  return(testStatus)
}

#' getTag: return git tag information if relavant
#' Requires that repostiory have tags and that sha for last tag
#' and last commit match.  
getTag <- function(repo) {
  tagString <- NULL
  
  # get tags
  tagList <- git2r::tags(repo)
  
  # Abort if no tags in repo
  if(length(tagList) ==  0) {
    return(NULL)
  }
  
  tag <- tagList[[length(tagList)]]
  
  # do tags match?  If not, return NULL
  if(tag@sha != commits(repo)[[1]]@sha) {
    return(NULL)
  }
    
  
  tagString <- paste( "[", substring(tag@target, 1,6), "] ", tag@name, sep = "" )
  return(tagString)

}


#' get_gitInfo: Get git information from repository
#' 
get_gitInfo <- function(scriptPath = "") {
  
  if(scriptPath == "") {
    scriptPath <- get_scriptpath()
  }
  
  if(is.null(scriptPath) | is.na(scriptPath)) {
    warning("Could not determine script path, unable to look up git information")
    return(NULL)
  }
  
  scriptPath <- path.expand(scriptPath)
  
  scriptRepo <- getRepo(scriptPath)
  
  if(is.null(scriptRepo)) {
    # getRepo will throw the warning...
    return(NULL)
  }
  
  
  # get last commit info
  lastCommit <- as(scriptRepo, "data.frame")[1,]

  # has the file been changed since last commit
  changed <- fileStatus(scriptRepo, scriptPath)
  
  results <- data.frame( Name = c("Commit Hash", "Commit Time", "Status"),
                         Value = c(substring(lastCommit$sha, 1, 7), lastCommit$when, changed) )
  
  # see if commit is tagged
  tagString <- getTag(scriptRepo)
  
  if(!is.null(tagString)) {
    results <- rbind(results, data.frame( Name = "Tag", Value = tagString))
  }
  
  results$Section = "Git"
  
  return(results)
}


#' Get system information
#'   
#' Get system information: OS, hostname, userid, working directory as a data frame
#' @param None
#' @examples get_sysinfo()

get_sysinfo <- function() {
  sysinfo <- data.frame( Section = "System",
                         Name = names(Sys.info()), 
                         Value = unname(Sys.info()))
  
  cwd <- data.frame( Section = "System", Name = "Directory", Value = getwd() )
  
  sysinfo <- rbind(sysinfo, cwd)  
  
  return(sysinfo) 
}

#' Environment info
#' 
#' Document the working environment for a script including:
#' 
#'- System version (OS, version, user, working directory)
#'- R version
#'- Package names and versions
#'- Top-level script name and modification time
#'
#' @param output How should output be handled? return: return as a data frame (default);
#'  print: print to stdout
#'  @param system Include OS info from get_sysinfo()? Default TRUE
#'  @param version Include R version?  Default TRUE
#'  @param packages Include packages with repository and version from get_packageinfo()? Default TRUE
#'  @param script Include script path and modification time from get_scriptinfo()? Default TRUE
#'  @param git Include git repository information? from get_gitInfo (note: requires git2r)?  Default TRUE
#'  
#'  @examples
#'  env_doc("print") # print information to stdout
#'  info <- env_doc() # return information as a consolidated data frame

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
