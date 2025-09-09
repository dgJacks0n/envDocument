library(envDocument)

context("gitinfo")

# does git info work?
test_that("git lookup", {

  # only run if git2r is installed and .git directory exists in project root
  skip_if_not_installed("git2r")
  
  skip_if_not(dir.exists(file.path(here::here(), ".git")))
  
  expect_is(getGitInfo(normalizePath("./test-gitinfo.R")), 
            "data.frame")
})


test_that("finds repo", {

  # only run if git2r is installed and .git directory exists in project root
  skip_if_not_installed("git2r")
  
  skip_if_not(dir.exists(file.path(here::here(), ".git")))
  
  res <- getRepo(normalizePath("./test-gitinfo.R"))
  expect_is(res, "git_repository")
})
