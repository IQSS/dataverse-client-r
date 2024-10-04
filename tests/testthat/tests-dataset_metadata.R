# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://demo.dataverse.org/dataset.xhtml?persistentId=doi:10.70122/FK2/HXJVJU

test_that("check metadata format", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  dv        <- get_dataverse("dataverse-client-r")
  contents  <- dataverse_contents(dv)
  ds_index  <- which(sapply(contents, function(x) x$identifier) == "FK2/HXJVJU")
  actual    <- dataset_metadata(contents[[ds_index]])

  expect_equal(actual[["displayName"]], "Citation Metadata")
  expect_equal(actual[["name"]], "citation")
  expect_s3_class(actual[["fields"]], "data.frame")
})

test_that("check versions format", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  dv        <- get_dataverse("dataverse-client-r")
  contents  <- dataverse_contents(dv)
  ds_index  <- which(sapply(contents, function(x) x$identifier) == "FK2/HXJVJU")
  actual    <- dataset_versions(contents[[ds_index]])

  expected_names <- c(
    "citationDate", "createTime", "datasetId", "datasetPersistentId",
    "fileAccessRequest", "files", "id", "lastUpdateTime", "latestVersionPublishingState",
    "license", "metadataBlocks", "publicationDate", "releaseTime",
    "storageIdentifier", "UNF", "versionMinorNumber", "versionNumber",
    "versionState")
  expect_setequal(names(actual[[1]]), expected_names)
  expect_s3_class(actual[[2]], "dataverse_dataset_version")
})
