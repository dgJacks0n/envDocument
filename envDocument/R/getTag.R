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
  
  # do tags match?  If not, return NULL
  if(tag@sha != git2r::commits(repo)[[1]]@sha) {
    return(NULL)
  }
  
  
  tagString <- paste( "[", substring(tag@target, 1,6), "] ", tag@name, sep = "" )
  return(tagString)
  
}

