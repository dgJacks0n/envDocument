## Test environments
* local OSX 10.14 install, R 3.5.1 (64 bit)
* Linux 2.6.32-431.23.3.el6.x86_64
* Ubuntu Linux 16.04 LTS, R-devel, GCC on builder.r-hub.io
* Ubuntu Linux 16.04 LTS, R-release, GCC on builder.r-hub.io
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit on builder.r-hub.io


## R CMD check results
There were no ERRORs or WARNINGs 

NOTES
This is update release 2.4.2.  It provides a new function to get status of the
renv lockfile if used. It also determines the path and filename of 
Quarto markdown documents (requires quarto version 1.7 or higher)

## Reverse Dependency Checks
From devtools::revdep_check()

No ERRORs or WARNINGs found 