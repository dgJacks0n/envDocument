# envDocument
R package providing a method to document the working environment for a script to support Reproducible Research

Provides method env_doc() which collects information on the system (OS, version, user), attached packages (name, source, version), 
R version and script (working directory, script path and modification time) and organizes them into a single data frame for manipulation
and/or formatting (for example with `knitr::kable()`)

# Changes
See the changes described in [envDocument/NEWS.md](envDocument/NEWS.md) for a summary of version-to-version changes

# Installation
Recommended: install from CRAN.  See https://cran.r-project.org/package=envDocument

Alternatives: Either download the current .tar.gz file from the [packageReleases](packageReleases) directory or use the following R console command:  

```
devtools::install_git("https://github.com/dgJacks0n/envDocument", subdir="envDocument") 
```

*Note: due to a known bug in git2r installation from a specified tag does not work*  


