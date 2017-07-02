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
    testPath <- try(getScriptPath(), silent = TRUE)
    
    # did that work?
    if(class(testPath) == "try-error") {
      stop(testPath)
    }
  }
  # is testPath valid
  if(!file.exists(testPath)) {
    stop("File ", testPath, " does not exist, cannot locate repo")
  }
  
  # get location of repo that controls testPath
  repoPath <- git2r::discover_repository(testPath)
  
  
  if(is.null(repoPath) || is.na(repoPath)) {
    stop("Could not find repo directory for ", testPath)
  }
  
  repo <- git2r::repository(repoPath)
  
  if(class(repo) != "git_repository") {
    stop("Unable to locate a git repository for", testPath)
  }
  
  # is file tracked in repo?  
  untracked <- git2r::status(repo, staged = FALSE, unstaged = FALSE, untracked = TRUE)

  if(length(untracked[["untracked"]]) > 0) {
    repoRoot <- sub("/\\.git/*", "", repoPath,  fixed = FALSE)

    if(normalizePath(testPath, mustWork = FALSE) %in%
       normalizePath(paste(repoRoot, untracked[["untracked"]],sep = "/"),
                     mustWork = FALSE)) {
      stop("File ", testPath, " is not tracked in repostitory ", repoPath)
    }
  }
  
  return(repo)
}
