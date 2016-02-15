# envDocument
R package providing a method to document the working environment for a script to support Reproducible Research

Provides method env_doc() which collects information on the system (OS, version, user), attached packages (name, source, version), 
R version and script (working directory, script path and modification time) and organizes them into a single data frame for manipulation
and/or formatting (for example with knitr::kable())

#Installation
Either download the current .tar.gz file from the (packageReleases) directory or use the following R console command:
`devtools::install_git("http://biogit.pri.bms.com/jacksod/envDocument", subdir="envDocument", repos=BiocInstaller::biocinstallRepos())`
*Thanks to John Thompson for providing this devtools command!*
