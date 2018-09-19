library(envDocument)

context("gitinfo")

# does git info work?
test_that("git lookup", {
  # skip if git2r is not available
  if (!requireNamespace("git2r", quietly = TRUE)) {
    skip("git2r not available")
  }
  
  expect_s3_class(getGitInfo("./test-gitinfo.R"), "data.frame")
})


test_that("finds repo", {
  # skip if git2r is not available
  if (!requireNamespace("git2r", quietly = TRUE)) {
    skip("git2r not available")
  }
  
  res <- getRepo("./test-gitinfo.R")
  expect_s3_class(res, "git_repository")
})
