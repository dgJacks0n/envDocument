#!/usr/bin/Rscript

# check getScriptPath with Rscript

library(envDocument)

print( commandArgs(trailingOnly=FALSE) )

print(getScriptPath())

