#' Collapse list of enviornment information into a single data frme
#' @param info_list List with environment information
#' 
collapseInfo <- function(info_list = list()) {
  tag_list <- lapply(names(info_list), tagSection, info_list)
  single_df <- do.call("rbind", tag_list)
  return(single_df)
}


tagSection <- function(section_name, info_list) {
  info_list[[section_name]]$Section <- section_name
  return(info_list[[section_name]])
}
