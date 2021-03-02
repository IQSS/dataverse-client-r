# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/HXJVJU

test_that("check metadata format", {
  testthat::skip_if_offline("demo.dataverse.org")
  dv        <- get_dataverse("dataverse-client-r")
  contents  <- dataverse_contents(dv)
  ds_index  <- which(sapply(contents, function(x) x$identifier) == "FK2/HXJVJU")
  actual    <- dataset_metadata(contents[[ds_index]])

  expect_length(actual, 2L)
  expect_equal(actual[[1]], "Citation Metadata")
  expect_s3_class(actual[[2]], "data.frame")
})

test_that("check versions format", {
  testthat::skip_if_offline("demo.dataverse.org")
  dv        <- get_dataverse("dataverse-client-r")
  contents  <- dataverse_contents(dv)
  ds_index  <- which(sapply(contents, function(x) x$identifier) == "FK2/HXJVJU")
  actual    <- dataset_versions(contents[[ds_index]])

  expect_length(actual[[1]], 16L)
  expect_s3_class(actual[[2]], "dataverse_dataset_version")
})
