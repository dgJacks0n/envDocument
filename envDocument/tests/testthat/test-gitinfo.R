context("gitinfo")

# does git info work?
test_that("git lookup", {
  expect_s3_class(getGitInfo("../../DESCRIPTION"), "data.frame")
})
