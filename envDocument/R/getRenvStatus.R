#' Check whether \code{renv} is in use for this project.  
#'   If it is, get project status.
#'   Requires that \code{renv} be installed and active.
#' 
#' @param project_root Project root directory (optional); defalults to value
#'   from \code{here::here()}
#'   
#' @export

getRenvStatus <- function(project_root = NA) {
  # check that `renv` is installed:
  # check whether git2r is installed
  if (!requireNamespace("renv", quietly = TRUE)) {
    warning("Package renv is needed by getRenvStatus Please install it or call env_doc(renv = FALSE).",
            call. = FALSE)
    return(infoNotFound())
  }
  
  # If project_root was supplied is it valid?
  # otherwise set to NULL so renv::status will look for it
  if(!(is.na(project_root))) {
    if(!dir.exists(project_root)) {
      warning("Project root directory does not exist")
      return(infoNotFound())
    }
  } else {
    project_root <- NULL
    #project_root <- here::here()
  }
  
  
  # Use purr::quietly to capture results and output from renv::status
  #q_status <- purrr::quietly(renv::status)
  
  #myresult <- q_status(project_root)
  
 utils::capture.output(myresult <- renv::status(project_root), 
                file = nullfile())

 # also get output message renv:status prints
  myoutput <- utils::capture.output(renv::status(project_root))
  
  myoutput <- grep("\\w+", myoutput, value = TRUE)
  
  myoutput <- paste(myoutput, collapse = "\n")
  
  myreturn <- data.frame(Name = "Renv Status",
                         Value = myoutput)
  
  # add lockfile
  # note: renv::paths$lockfile() returns the file name it's looking for
  # even if that file doesn't exist - so test first
  lockfile <- renv::paths$lockfile(project_root)
  
  if(file.exists(lockfile)) {
    myreturn <- rbind(myreturn,
                      data.frame(Name = "Lockfile",
                                 Value = normalizePath(lockfile))
    )
  }
  
  # check for python lockfile info
  if ( 'Python' %in% names(myresult$lockfile) ) {
    myreturn <- rbind(myreturn,
                      data.frame(Name = "Python Version",
                                 Value = myresult$lockfile$Python$Version),
                      data.frame(Name = "Python Type",
                                 Value = myresult$lockfile$Python$Type)
    )
    
    if ( myresult$lockfile$Python$Type %in% c('virtualenv','conda') ) {
      myreturn <- rbind(myreturn,
                        data.frame(Name = "Python Lockfile",
                                   Value = normalizePath(myresult$lockfile$Python$Name)
                        )
      )
    }
  }

    return(myreturn)
}
