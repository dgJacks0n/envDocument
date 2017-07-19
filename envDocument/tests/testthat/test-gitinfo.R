context("gitinfo")

# does git info work?
test_that("git lookup", {
  # skip if git2r is not available
  if (!requireNamespace("git2r", quietly = TRUE)) {
    skip("git2r not available")
  }
  
  expect_s3_class(getGitInfo("../../DESCRIPTION"), "data.frame")
})


test_that("finds repo", {
  # skip if git2r is not available
  if (!requireNamespace("git2r", quietly = TRUE)) {
    skip("git2r not available")
  }
  
  res <- getRepo("../../DESCRIPTION")
  expect_s4_class(res, "git_repository")
})
