test_that("cache management works", {
  expect_true(dir.exists(cache_path()))

  expect_identical(cache_dataset(":latest"), "none")
  expect_identical(cache_dataset("1.2"), "disk")

  info <- cache_info()
  expect_s3_class(info, "data.frame")
  ## subset of column names common across platforms; see ?file.info
  ## 'uname' not available in Windows <= R 4.4.1
  colnames <- c("size", "isdir", "mode", "mtime", "ctime", "atime")
  expect_true(all(colnames %in% names(info)))
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
