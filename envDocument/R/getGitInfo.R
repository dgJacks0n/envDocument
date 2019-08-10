#' Get git repository information for a script
#' 
#' \code{getGitInfo} locates the git repository for the calling script
#' (if any) and retrieves relevant informaiton such as last commit, status
#' (e.g. modified since last commit) and tag (if any).
#' 
#' Requires that \code{git2r} be installed.
#' 
#' @param scriptpath Path to script (optional, defaults to calling script from get_scriptPath())
#' 
#' @examples
#' git_info <- getGitInfo()
#' 
#' @export
#' 
getGitInfo <- function(scriptpath = NA) {
  
  # check whether git2r is installed
  if (!requireNamespace("git2r", quietly = TRUE)) {
    warning("Package git2r is needed by getGitInfo. Please install it or call env_doc(git = FALSE).",
         call. = FALSE)
    return(infoNotFound())
  }
  
  # look up script 
  if(is.na(scriptpath)) {
    scriptpath <- try(getScriptPath(), silent = TRUE)
    
    if(class(scriptpath) == "try-error") {
      warning("Unable to look up git information; could not determine calling script\n",
              scriptpath)
      return(infoNotFound())
    }
  }
  
  scriptRepo <- try(getRepo(scriptpath), silent = TRUE)
  
  if(class(scriptRepo) == "try-error") {
    warning(scriptRepo)
    return(infoNotFound())
  }
  
  # get branch information.  Need to support git2r >= v0.22.1 (S3) and < v0.21 (S4)
  branch <- git2r::branches(scriptRepo)[[1]]
  
  # try S4 method for git2r v <= 0.2.1 and S3 for later
  branchname <- ifelse(isS4(branch),
                       try(branch@name, silent = TRUE),
                       try(branch$name, silent = TRUE)
  )
  
  
  # if both fail, give up
  if(class(branchname) == "try-error" | is.null(branchname)) {
    branchname <- infoNotFound()
  }
  
  
  results <- data.frame( Name = "Branch",
                         Value = branchname)
 
   # get last commit info
  # get last commit info, again with S4 or S3
  #lastCommit <- as.data.frame(git2r::commits(scriptRepo, n = 1)[[1]])
  lastCommit <- git2r::commits(scriptRepo, n = 1)[[1]]
  
  # ifelse isn't working as expected here.
  last <- NULL
  if(isS4(lastCommit)) {
    last <- methods::as(scriptRepo, "data.frame")[1,]
  } else {
    last <- as.data.frame(lastCommit) # will methods::as work on S3?
  }
  
  
  # has the file been changed since last commit
  changed <- fileStatus(scriptRepo, scriptpath) # need to update for git2r >= v0.22.1
  
  results <- rbind(results,
                   data.frame( Name = c("Commit Hash", 
                                        "Commit Time", 
                                        "Status"),
                               Value = c(substring(last$sha, 1, 7), 
                                         as.character.Date(last$when), 
                                         changed) 
                   ))
  
  # see if commit is tagged
  tagString <- getTag(scriptRepo)
  
  if(!is.null(tagString)) {
    results <- rbind(results, data.frame( Name = "Tag", Value = tagString))
  }
  
  remotes <- remoteInfo(scriptRepo)
  results <- rbind(results, remotes)
  
  return(results)
}


