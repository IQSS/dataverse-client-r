# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/HXJVJU

test_that("download tab from DOI and filename", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  actual <- get_file(
    file = "roster-bulls-1996.tab",
    dataset = "doi:10.70122/FK2/HXJVJU"
  )
  expect_true(is.raw(actual))
  expect_true(1000 < object.size(actual)) # Should be 1+ KB
})

test_that("download tab from file id", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  actual <- get_file(
    file = 1734005L
  )
  expect_true(is.raw(actual))
  expect_true(1000 < object.size(actual)) # Should be 1+ KB
})

test_that("download multiple files with file id - no folder", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  # file_ids <- get_dataset("doi:10.70122/FK2/LZAJEQ", server = "demo.dataverse.org")[['files']]$id
  file_ids <- get_dataset("doi:10.70122/FK2/HXJVJU", server = "demo.dataverse.org")[['files']]$id
  actual <- get_file(
    file_ids,
    format = "original",
    server = "demo.dataverse.org"
  )
  expect_true(length(actual) == 2) # two files in the dataset
  expect_true(is.raw(actual[[2]]))
  expect_true(object.size(actual[[2]]) > 300) # Should be >300 B
})

test_that("download multiple files with file id - with folders", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  file_ids <- get_dataset("doi:10.70122/FK2/HXJVJU", server = "demo.dataverse.org")[['files']]$id
  actual <- get_file(file_ids, format = "original", server = "demo.dataverse.org")
  expect_true(length(actual) == 2) # two files in the dataset
  expect_true(is.raw(actual[[2]]))
  expect_true(object.size(actual[[2]]) > 70) # Should be >70 B
})


# Informative error message (PR #30)
test_that("More informative error message when file does not exist", {
  testthat::skip_on_cran()
  # wrong server
  expect_error(get_file(2972336, server = "demo.dataverse.org"), regexp = "API")
})

# Informative error message (PR #30)
test_that("Return just URL", {
  testthat::skip_on_cran()
  expect_equal(get_file(c(1734005, 1734006), format = "original", server = "demo.dataverse.org", return_url = TRUE),
               list("https://demo.dataverse.org/api/access/datafile/1734005",
                    "https://demo.dataverse.org/api/access/datafile/1734006"))
})
