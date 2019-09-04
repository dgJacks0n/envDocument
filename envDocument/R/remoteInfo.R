#' Look up remotes for repository
#' 
#' @param repo A git2r repository object
#' 
remoteInfo <- function(repo) {
  if(length(git2r::remotes(repo)) == 0) { return( infoNotFound() )}
  
  # get remote based on local head
  local <- try(git2r::repository_head(repo)) 
  
  if(class(local) == "try_error" | is.null(local)) {
    return(infoNotFound())
  }
  
  upstream <- git2r::branch_get_upstream(local)
  
  remote_string <- paste(git2r::branch_remote_name(upstream), 
                         git2r::branch_remote_url(upstream), sep = ": ")
  
  results <- data.frame( Name = "Remote", Value = remote_string)
  
  return(results)
}