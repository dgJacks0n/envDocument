# fileStatus: check if file has been modified since last commit


fileStatus <- function(repo, testPath) {
  testStatus <- NULL
  
  # need to get top level path for repo
  repoPath <- try(repo$path, silent = TRUE)
  
  if(class(repoPath) == "try-error") {
    return(infoNotFound())
  }
  
  repoRoot <- sub("/\\.git/*", "", repoPath,  fixed = FALSE)
  
  statusVals <- unlist(git2r::status(repo))
  hasStatus <-  normalizePath(testPath, mustWork = FALSE) == 
    normalizePath(paste(repoRoot, statusVals, sep = "/"), 
                  mustWork = FALSE)
  
  if(any(hasStatus)) {
    testStatus <- paste(names(statusVals[hasStatus]), collapse = ", ")
  } else {
    testStatus <- "committed"
  }
  
  return(testStatus)
}
