#' Get  information on R version
#' 
#' @examples
#' Rversion <- getRversion()
#' @export
getRversion <- function() {
  rinfo <- data.frame( Name = "Version", 
                       Value = R.version.string
  )
  
  return(rinfo)
}
