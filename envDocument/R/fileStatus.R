# fileStatus: check if file has been modified since last commit


fileStatus <- function(repo, testPath) {
  testStatus <- NULL
  
  # need to get top level path for repo
  repoRoot <- sub("/\\.git/*", "", repo@path,  fixed = FALSE)
  
  statusVals <- unlist(git2r::status(repo))
  hasStatus <-  normalizePath(testPath) == 
    normalizePath(paste(repoRoot, statusVals, sep = "/"))
  
  if(any(hasStatus)) {
    testStatus <- paste(names(statusVals[hasStatus]), collapse = ", ")
  } else {
    testStatus <- "committed"
  }
  
  return(testStatus)
}
