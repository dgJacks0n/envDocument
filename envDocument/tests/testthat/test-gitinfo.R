library(envDocument)

context("gitinfo")

# does git info work?
test_that("git lookup", {
  # skip if git2r is not available
  if (!requireNamespace("git2r", quietly = TRUE)) {
    skip("git2r not available")
  }
  
  # don't run this test on CRAN
  skip_on_cran()
  expect_is(getGitInfo("./test-gitinfo.R"), "data.frame")
})


test_that("finds repo", {
  # skip if git2r is not available
  if (!requireNamespace("git2r", quietly = TRUE)) {
    skip("git2r not available")
  }
  
  # don't run this test on CRAN
  skip_on_cran()
  res <- getRepo("./test-gitinfo.R")
  expect_is(res, "git_repository")
})
