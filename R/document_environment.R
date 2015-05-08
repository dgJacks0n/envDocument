

# print_packageinfo: print selected attributes for all loaded packages
print_packageinfo <- function() {
  packages <- sessionInfo()["otherPkgs"]$otherPkgs
  print ("Loaded packages")
  for (i in 1:length(packages)) {
    print (paste("Package:", packages[[i]]$Package))
    print (paste("Version:", packages[[i]]$Version))
    print (paste("Repository:", packages[[i]]$Repository))
    print (paste("Built:", packages[[i]]$Built))
    print("")
  }
}

env_doc <- function ( system = TRUE,
                      version = TRUE,
                      packages = TRUE,
                      directory = TRUE ) {
  
  if(system == TRUE) {
    print("System information:")
    print(Sys.info())
    print("")
  }
  
  if(version == TRUE) {
    print("R Version")
    print(R.version)
    print("")
  }
  
  if(packages == TRUE) {
    print_packageinfo()
  }
  
  if(directory == TRUE) {
    print(paste("Working directory: ", getwd()))
  }
}