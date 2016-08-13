#' Get git repository information for a script
#' 
#' \code{get_gitinfo} locates the git repository for the calling script
#' (if any) and retrieves relevant informaiton such as last commit, status
#' (e.g. modified since last commit) and tag (if any).
#' 
#' Requires that \code{\link{git2r}} be installed.
#' 
#' @param script Path to script (optional, defaults to get_scriptPath())
#' @examples
#' git_info <- get_gitInfo()
#' @export
#' 
get_gitInfo <- function(scriptPath = "") {
  
  # need to check whether git2r is installed!
  
  if (!requireNamespace("git2r", quietly = TRUE)) {
    stop("Package git2r needed for this function to work. Please install it or call env_doc(git = FALSE).",
         call. = FALSE)
  }
  
  
  if(scriptPath == "") {
    scriptPath <- get_scriptpath()
  }
  
  if(is.null(scriptPath) | is.na(scriptPath)) {
    warning("Could not determine script path, unable to look up git information")
    return(NULL)
  }
  
 
  scriptRepo <- getRepo(scriptPath)
  
  if(is.null(scriptRepo)) {
    # getRepo will throw the warning...
    return(NULL)
  }
  
  
  # get last commit info
  lastCommit <- as(scriptRepo, "data.frame")[1,]
  
  # has the file been changed since last commit
  changed <- fileStatus(scriptRepo, scriptPath)
  
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
