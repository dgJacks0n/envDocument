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
  tagSha <- ifelse(isS4(tag),
                   try(tag@sha, silent = TRUE),
                   try(tag$sha, silent = TRUE))
  
  if(class(tagSha) == "try-error") {
    tagSha <- tag$sha
  }
  
  # same to get sha for last commit
  lastCommit <- git2r::commits(repo, n = 1)[[1]]
  
  # ifelse isn't working as expected here.
  last <- NULL
  if(isS4(lastCommit)) {
    last <- methods::as(repo, "data.frame")[1,]
  } else {
    last <- as.data.frame(lastCommit) # will methods::as work on S3?
  }
  
  

  # do tags match?  If not, return NULL
  if(tagSha != last$sha) {
    return(NULL)
  }
  
  
  tagString <- paste( "[", substring(tag@target, 1,6), "] ", tag@name, sep = "" )
  return(tagString)
  
}

