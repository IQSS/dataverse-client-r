# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/HXJVJU

test_that("download tab from DOI and filename", {
  dv        <- get_dataverse("dataverse-client-r")
  contents  <- dataverse_contents(dv)
  actual    <- dataset_metadata(contents[[1]])

  expect_length(actual, 2L)
  expect_equal(actual[[1]], "Citation Metadata")
  expect_s3_class(actual[[2]], "data.frame")
})
