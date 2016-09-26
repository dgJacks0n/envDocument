#' Look up remotes for repository
#' 
#' @param repo A git2r repository object
#' 
remoteInfo <- function(repo) {
  if(length(git2r::remotes(repo)) == 0) { return(NULL)}
  
  remote_string <- paste(git2r::remotes(repo), git2r::remote_url(repo), sep = ": ")
  
  results <- data.frame( Name = "Remote", Value = remote_string)
  
  return(results)
}