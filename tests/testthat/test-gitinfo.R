library(envDocument)

context("gitinfo")

# does git info work?
test_that("git lookup", {

  skip_if_not_installed("git2r")
  
  # don't run this test on CRAN
  skip_on_cran()
  skip_on_ci()
  expect_is(getGitInfo(normalizePath("./test-gitinfo.R")), 
            "data.frame")
})


test_that("finds repo", {
  skip_if_not_installed("git2r")
  
  # don't run this test on CRAN
  skip_on_cran()
  skip_on_ci()
  res <- getRepo(normalizePath("./test-gitinfo.R"))
  expect_is(res, "git_repository")
})
