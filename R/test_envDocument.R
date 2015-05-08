#' ---
#' title: test_envDocument
#' author: Donald Jackson (donald.jackson@bms.com)
#' description: test suite for envDocument package
#' ---
#' Note: I'm not sure how to run a true regression test on this package since its
#' purpose is to print out a lot of machine-specific info.  For now just make
#' sure it outupts the appropriate sections (system, Rversion and included package envDocument)


library("envDocument")

env_doc()