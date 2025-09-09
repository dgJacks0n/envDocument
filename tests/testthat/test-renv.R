library(envDocument)

context("renv")

# does renv status work?
test_that("renv status", {
  
  # only run if renv is installed and renv.lock exists
  skip_if_not_installed("renv")
  
  skip_if_not( file.exists(file.path(here::here(), "renv.lock")) )
  
  expect_is(getRenvStatus(), 
            "data.frame")
})


