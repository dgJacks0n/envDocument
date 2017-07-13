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
      warning(scriptpath)
      return(infoNotFound())
    }
  }
  
  scriptRepo <- try(getRepo(scriptpath), silent = TRUE)
  
  if(class(scriptRepo) == "try-error") {
    warning(scriptRepo)
    return(infoNotFound())
  }
  
  # get branch name
  branchname <- branches(scriptRepo)[[1]]@name
  results <- data.frame( Name = "Branch",
                         Value = branchname)
 
   # get last commit info
  lastCommit <- methods::as(scriptRepo, "data.frame")[1,]
  
  # has the file been changed since last commit
  changed <- fileStatus(scriptRepo, scriptpath)
  
  results <- rbind(results,
                   data.frame( Name = c("Commit Hash", 
                                        "Commit Time", 
                                        "Status"),
                               Value = c(substring(lastCommit$sha, 1, 7), 
                                         as.character.Date(lastCommit$when), 
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


