# envDocument
R package providing a method to document the working environment for a script to support Reproducible Research

Provides method env_doc() which collects information on the system (OS, version, user), attached packages (name, source, version), 
R version and script (working directory, script path and modification time) and organizes them into a single data frame for manipulation
and/or formatting (for example with knitr::kable())

# Changes
Update in v2.2 adds information on the git commit, tag and status for the calling script.  

# Installation
Either download the current .tar.gz file from the [packageReleases](packageReleases) directory or use the following R console command:  

```
devtools::install_git("http://biogit.pri.bms.com/jacksod/envDocument", subdir="envDocument") 
```

*Note: due to a bug in git2r installation from a specified tag does not work*  

*Thanks to John Thompson for providing this devtools command!*
