# getTag
# 
# Return git tag information if relavant
# Requires that repostiory have tags and that sha for last tag
# and last commit match.  
# 
getTag <- function(repo) {
  tagString <- NULL
  
  # get tags
  tagList <- git2r::tags(repo)
  
  # Abort if no tags in repo
  if(length(tagList) ==  0) {
    return(NULL)
  }
  
  tag <- tagList[[length(tagList)]]
  
  # pull out sha for tag.  Try old (S4) way, then new (S3)
  tagSha <- try(tag@sha, silent = TRUE)
  
  if(class(tagSha) == "try-error") {
    tagSha <- tag$sha
  }
  
  # same to get sha for last commit
  lastCommit <- git2r::commits(repo, n = 1)[[1]]
  
  lastSha <- try(lastCommit@sha, silent = TRUE)
  
  if(class(lastSha) == "try-error") {
    lastSha <- lastCommit$sha
  }
  
  # do tags match?  If not, return NULL
  if(tagSha != lastSha) {
    return(NULL)
  }
  
  
  tagString <- paste( "[", substring(tag@target, 1,6), "] ", tag@name, sep = "" )
  return(tagString)
  
}

