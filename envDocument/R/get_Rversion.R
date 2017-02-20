#' Get  information on R version
#' 
#' @examples
#' Rversion <- getRversion()
#' @export
get_Rversion <- function() {
  rinfo <- data.frame( Name = "Version", 
                       Value = R.version.string
  )
  
  return(rinfo)
}
