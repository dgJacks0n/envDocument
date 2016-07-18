# test_envDocument
# 
# Note: I'm not sure how to run a true regression test on this package since its
# purpose is to print out a lot of machine-specific info.  For now just make
# sure it outupts the appropriate sections (system, Rversion and included package envDocument)

# comment library() out for build/reload, turn back on for use with knitr 
# library(envDocument)

# Calling env_doc with defaults returns a single data frame of information
# about the environment
info <- env_doc()

# Calling with "print" will print the data frame
env_doc("print")

# This df can be pretty-printed as a table in a knitr report
# Set the knitr chunk option results to "asis" or the table will be 
# prefixed with comments
knitr::opts_chunk$set(results="asis")

knitr::kable(info)

