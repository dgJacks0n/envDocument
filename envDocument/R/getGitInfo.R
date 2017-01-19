#' Get git repository information for a script
#' 
#' \code{getGitInfo} locates the git repository for the calling script
#' (if any) and retrieves relevant informaiton such as last commit, status
#' (e.g. modified since last commit) and tag (if any).
#' 
#' Requires that \code{git2r} be installed.
#' 
#' @param scriptpath Path to script (optional, defaults to get_scriptPath())
#' 
#' @examples
#' git_info <- getGitInfo()
#' 
#' @export
#' 
getGitInfo <- function(scriptpath = "") {
  
  # check whether git2r is installed
  if (!requireNamespace("git2r", quietly = TRUE)) {
    stop("Package git2r needed for this function to work. Please install it or call env_doc(git = FALSE).",
         call. = FALSE)
  }
  
  
  if(scriptpath == "") {
    scriptpath <- getScriptPath()
  }
  
  if(is.null(scriptpath) | is.na(scriptpath)) {
    warning("Could not determine script path, unable to look up git information")
    return(NULL)
  }
  
 
  scriptRepo <- getRepo(scriptpath)
  
  if(is.null(scriptRepo)) {
    # getRepo will throw the warning...
    return(NULL)
  }
  
  
  # get last commit info
  lastCommit <- methods::as(scriptRepo, "data.frame")[1,]
  
  # has the file been changed since last commit
  changed <- fileStatus(scriptRepo, scriptpath)
  
  results <- data.frame( Name = c("Commit Hash", 
                                  "Commit Time", 
                                  "Status"),
                         Value = c(substring(lastCommit$sha, 1, 7), 
                                   as.character.Date(lastCommit$when), 
                                   changed) 
                         )
  
  # see if commit is tagged
  tagString <- getTag(scriptRepo)
  
  if(!is.null(tagString)) {
    results <- rbind(results, data.frame( Name = "Tag", Value = tagString))
  }
  
  remotes <- remoteInfo(scriptRepo)
  results <- rbind(results, remotes)
  
  return(results)
}
