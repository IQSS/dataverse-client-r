context("Data Access API")

# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/FAN622

test_that("get file metadata from DOI and filename", {
  actual <- get_file_metadata(
    file    = "roster-bulls-1996.tab",
    dataset = "doi:10.70122/FK2/FAN622"
  )
  expect_true(is.character(actual))
  expect_true(4000 < nchar(actual)) # There should be 4k+ characters
})

test_that("get file metadata from file id", {
  actual <- get_file_metadata(
    file = 396357
  )
  expect_true(is.character(actual))
  expect_true(4000 < nchar(actual)) # There should be 4k+ characters
})

test_that("download file from DOI and filename", {
  actual <- get_file(
    file = "roster-bulls-1996.tab",
    dataset = "doi:10.70122/FK2/FAN622"
  )
  expect_true(is.raw(actual))
  expect_true(1000 < object.size(actual)) # Should be 1+ KB
})

test_that("download file from file id", {
  actual <- get_file(
    file = 396357
  )
  expect_true(is.raw(actual))
  expect_true(1000 < object.size(actual)) # Should be 1+ KB
})
