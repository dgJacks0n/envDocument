#' Get git repository for a file
#' 
#' \code{getRepo} looks the up the repository for a file and 
#' makes sure path is tracked in repo.  Repositories are searched
#' from the file directory up using 
#' \code{\link{git2r::discover_repository}}
#' 
#'
#' @param testPath Path to a file to find/check repo
#'
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
  
  
  if(length(untracked[["untracked"]]) > 0) {
    repoRoot <- sub("/.git/", "", repoPath,  fixed = TRUE)
    
    if(normalizePath(testPath) %in% normalizePath(paste(repoRoot, unlist(untracked), sep = "/"))) {
      warning("File ", testPath, " is not tracked in repostitory ", repoPath)
      return(NULL)
    }
  }
  
  return(repo)
  
}
