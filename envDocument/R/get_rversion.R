#' Get  information on R version
#' 
#' @examples
#' Rversion <- get_rversion()
#' @export
get_rversion <- function() {
  rinfo <- data.frame( Name = "Version", 
                       Value = R.version.string
  )
  
  return(rinfo)
}
