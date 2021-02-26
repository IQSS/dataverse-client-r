# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/HXJVJU

test_that("roster-by-name", {
  testthat::skip_if_offline("demo.dataverse.org")
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- readr::read_rds(system.file("dataset-basketball/dataframe-from-tab.rds", package = "dataverse"))

  actual <-
    get_dataframe_by_name(
      filename = expected_ds$roster$label , # A value like "roster-bulls-1996.tab",
      dataset  = dirname(expected_ds$roster$dataFile$persistentId)#, # A value like "doi:10.70122/FK2/HXJVJU",
    )

  expect_equal(actual, expected_file)
})

test_that("roster-by-doi", {
  testthat::skip_if_offline("demo.dataverse.org")
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- readr::read_rds(system.file("dataset-basketball/dataframe-from-tab.rds", package = "dataverse"))

  actual <-
    get_dataframe_by_doi(
      filedoi  = expected_ds$roster$dataFile$persistentId, # A value like "doi:10.70122/FK2/HXJVJU/SA3Z2V",
    )

  expect_equal(actual, expected_file)
})

test_that("roster-by-id", {
  testthat::skip_if_offline("demo.dataverse.org")
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- readr::read_rds(system.file("dataset-basketball/dataframe-from-tab.rds", package = "dataverse"))

  actual <-
    get_dataframe_by_id(
      fileid   = expected_ds$roster$dataFile$id, # A value like 1734005
    )

  expect_equal(actual, expected_file)
})
