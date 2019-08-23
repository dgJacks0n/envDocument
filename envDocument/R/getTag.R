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
  
  if(isS4(tagList[[1]])) {
    tagInfo <- lapply(tagList, parseS4Tag)
  } else {
    tagInfo <- lapply(tagList, parseS3Tag)
  }
  
  tagInfo <- do.call("rbind", tagInfo)
  
  # get sha for last commit
  lastCommit <- git2r::commits(repo, n = 1)[[1]]

  # ifelse isn't working as expected here.
  last <- NULL
  if(isS4(lastCommit)) {
    last <- methods::as(repo, "data.frame")[1,]
  } else {
    last <- as.data.frame(lastCommit) # will methods::as work on S3?
  }

  # do any tag targets match last commit? if not, return null
  if( !any(last$sha == tagInfo$target) ) { return(NULL) }
  
  # return info for tag that matches target
  tagTarget <- tagInfo[ (last$sha == tagInfo$target), ]
  
  tagString <- paste( "[", substring(tagTarget$target, 1,6), "] ", tagTarget$name, 
                      sep = "" )
  return(tagString)
  
}

# parseS3Tags
#
# function to parse individual tags using s# structure

parseS3Tag <- function(thisTag) {
  thisTagTime <- thisTag$tagger$when$time
  
  thisTagInfo <- data.frame( sha = thisTag$sha,
                             target= thisTag$target,
                             when = thisTagTime,
                             name = thisTag$name,
                             message = thisTag$message,
                             person = thisTag$tagger$name,
                             email = thisTag$tagger$email
                             )
  
  return(thisTagInfo)
  
}


# parseS4Tag
# parse individual tag using S4 calls
parseS4Tag <- function(thisTag) {
  thisTagTime <- thisTag@tagger@when@time
  
  thisTagInfo <- data.frame(sha = thisTag@sha,
                            target = thisTag@target,
                            when =  thisTagTime,
                              name = thisTag@name,
                            message  = thisTag@message,
                            person = thisTag@tagger@name,
                            email = thisTag@tagger@email
                            )
  # add functions to get info from S4 based objects
  
  return(thisTagInfo)
}