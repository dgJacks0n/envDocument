#' Return a consistent failure result when something is not available
infoNotFound <- function() {
  return(data.frame( Name = "All Atributes", 
                     Value = "Not Available"))
}
