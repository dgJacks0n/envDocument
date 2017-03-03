#' Locate the git repository where a file is tracked
#' 
#' \code{getRepo} looks the up the repository for a file and 
#' makes sure path is tracked in repo.  Repositories are searched
#' from the file directory up using 
#' \code{\link[git2r]{discover_repository}}
#' 
#'
#' @param testPath Path to a file to find/check repo
#' 
#' @export
#'
getRepo <- function(testPath = NA) {
  # if no path provided: test with calling script
  if(is.na(testPath)) {
    testPath <- getScriptPath()
    
    # did that work?
    if(is.na(testPath)) {
      warning("Unable to determine test path: no path provided or available from envDocument::getScriptPath()")
      return(NA)
    } else {
      message("No test path provided, using value from envDocument::getScriptPath()")
    }
  }
  
  # is testPath valid
  if(!file.exists(testPath)) {
    stop("File ", testPath, " does not exist, cannot locate repo")
  }
  
  
  # get location of repo that controls testPath
  repoPath <- git2r::discover_repository(testPath)
  
  
  if(is.null(repoPath) | is.na(repoPath)) {
    warning("Could not find repo directory for ", testPath)
    return(NA)
  }
  
  repo <- git2r::repository(repoPath)
  
  
  # is file tracked in repo?  
  untracked <- git2r::status(repo, staged = FALSE, unstaged = FALSE, untracked = TRUE)

  if(length(untracked[["untracked"]]) > 0) {
    repoRoot <- sub("/\\.git/*", "", repoPath,  fixed = FALSE)

    if(normalizePath(testPath) %in%
       normalizePath(paste(repoRoot, untracked[["untracked"]],sep = "/"))) {
      warning("File ", testPath, " is not tracked in repostitory ", repoPath)
      return(NA)
    }
  }
  
  return(repo)
  
}
