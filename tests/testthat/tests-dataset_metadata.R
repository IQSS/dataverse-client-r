# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/HXJVJU

test_that("download tab from DOI and filename", {
  testthat::skip_if_offline("demo.dataverse.org")
  dv        <- get_dataverse("dataverse-client-r")
  contents  <- dataverse_contents(dv)
  ds_index  <- which(sapply(contents, function(x) x$identifier) == "FK2/HXJVJU")
  actual    <- dataset_metadata(contents[[ds_index]])

  expect_length(actual, 2L)
  expect_equal(actual[[1]], "Citation Metadata")
  expect_s3_class(actual[[2]], "data.frame")
})
