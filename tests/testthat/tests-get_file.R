context("Data Access API")

# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/FAN622

test_that("download tab from DOI and filename", {
  actual <- get_file(
    file = "roster-bulls-1996.tab",
    dataset = "doi:10.70122/FK2/FAN622"
  )
  expect_true(is.raw(actual))
  expect_true(1000 < object.size(actual)) # Should be 1+ KB
})

test_that("download tab from file id", {
  actual <- get_file(
    file = 396357
  )
  expect_true(is.raw(actual))
  expect_true(1000 < object.size(actual)) # Should be 1+ KB
})

test_that("download multiple files with file id - no folder", {
  file_ids <- get_dataset("doi:10.70122/FK2/LZAJEQ", server = "demo.dataverse.org")[['files']]$id
  actual <- get_file(
    file_ids,
    format="original",
    server = "demo.dataverse.org")
  expect_true(length(actual) == 2) # two files in the dataset
  expect_true(is.raw(actual[[2]]))
  expect_true(object.size(actual[[2]]) > 300) # Should be >300 B
})

test_that("download multiple files with file id - with folders", {
  file_ids <- get_dataset("doi:10.70122/FK2/V54HGA", server = "demo.dataverse.org")[['files']]$id
  actual <- get_file(file_ids, format="original", server = "demo.dataverse.org")
  expect_true(length(actual) == 2) # two files in the dataset
  expect_true(is.raw(actual[[2]]))
  expect_true(object.size(actual[[2]]) > 70) # Should be >70 B
})
