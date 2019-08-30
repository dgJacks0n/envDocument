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
  
    tagInfo <- lapply(tagList, parseS3Tag)

  tagInfo <- do.call("rbind", tagInfo)
  
  # get sha for last commit
  lastCommit <- git2r::commits(repo, n = 1)[[1]]

    last <- as.data.frame(lastCommit) # will methods::as work on S3?

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
  
  # annotated tags come back as git tag objects, lightweight come back as git commits
  if(class(thisTag) == "git_tag") {
    thisTagInfo <- data.frame( sha = thisTag$sha,
                             target= thisTag$target,
                             when = thisTag$tagger$when$time,
                             name = thisTag$name,
                             message = thisTag$message,
                             person = thisTag$tagger$name,
                             email = thisTag$tagger$email
                             )
  } else if (class(thisTag) == "git_commit") {
    thisTagInfo <- data.frame( sha = "Not Available",
                               target= thisTag$sha,
                               when = thisTag$author$when$time,
                               name = "Not Available",
                               message = thisTag$message,
                               person = thisTag$author$name,
                               email = thisTag$author$email
    )
  } else {
    warning("Unhandled class: ", class(thisTag))
    return (NULL)
  }
  return(thisTagInfo)
  
}
