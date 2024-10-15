test_that("cache management works", {
  expect_true(dir.exists(cache_path()))

  expect_identical(cache_dataset(":latest"), "none")
  expect_identical(cache_dataset("1.2"), "disk")

  info <- cache_info()
  expect_s3_class(info, "data.frame")
  expect_setequal(
    names(info),
    c("size", "isdir", "mode", "mtime", "ctime", "atime", "uid", 
      "gid", "uname", "grname")
  )
})

test_that("'api_get' validates use_cache", {
  testthat::skip_on_cran()

  expect_error(get_url_by_name(
    filename = "nlsw88.tab",
    dataset  = "10.70122/FK2/PPIAXE",
    server   = "demo.dataverse.org",
    use_cache = "BAD VALUE"
  ), ".*argument 'use_cache' is not correct, see \\?use_cache")
})
