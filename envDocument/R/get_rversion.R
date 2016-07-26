#' get_rversion
#' 
#' Get selected info on R version
#' 
#' @examples
#' Rversion <- get_rversion()
#' @export
get_rversion <- function() {
  rv <- R.Version()
  rinfo <- data.frame(Section = "R", Name = "Version", Value = R.version.string
  )
  return(rinfo)
  
}
