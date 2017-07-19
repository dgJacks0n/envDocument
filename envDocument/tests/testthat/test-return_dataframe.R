context("return_dataframe")

# make sure that env_doc returns a data frame; 
# need script = FALSE and git = FALSE to suppress errors

test_that("returns dataframe", {
  result <- env_doc(script = FALSE, git = FALSE)
  expect_s3_class(result, "data.frame")
})
