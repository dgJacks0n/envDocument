#' Look up remotes for repository
#'
#' @param repo A git2r repository object
#'
remoteInfo <- function(repo) {
  if (length(git2r::remotes(repo)) == 0) {
    return(infoNotFound())
  }

  # get remote based on local head
  local <- try(git2r::repository_head(repo))

  if (inherits(local, "try_error") | is.null(local)) {
    return(infoNotFound())
  }

  upstream <- git2r::branch_get_upstream(local)

  # strip PAT from remote_url if it's included
  remote_url <- git2r::branch_remote_url(upstream)

  remote_url <- sub("^(https?://)[^@/]+@", "\\1", remote_url)

  remote_string <- paste(
    git2r::branch_remote_name(upstream),
    remote_url,
    sep = ": "
  )

  results <- data.frame(Name = "Remote", Value = remote_string)

  return(results)
}
