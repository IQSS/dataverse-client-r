# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://demo.dataverse.org/dataset.xhtml?persistentId=doi:10.70122/FK2/HXJVJU

test_that("roster-by-name", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- readr::read_rds(system.file("dataset-basketball/dataframe-from-tab.rds", package = "dataverse"))

  actual <-
    get_dataframe_by_name(
      filename = expected_ds$roster$label , # A value like "roster-bulls-1996.tab",
      dataset  = dirname(expected_ds$roster$dataFile$persistentId),#, # A value like "doi:10.70122/FK2/HXJVJU",
      # quieten readr::read_tsv during test
      .f = function(...) readr::read_tsv(..., show_col_types = FALSE)
    )

  expect_equal(actual, expected_file)
})

test_that("roster-by-doi", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- readr::read_rds(system.file("dataset-basketball/dataframe-from-tab.rds", package = "dataverse"))

  actual <-
    get_dataframe_by_doi(
      filedoi  = expected_ds$roster$dataFile$persistentId, # A value like "doi:10.70122/FK2/HXJVJU/SA3Z2V",
      # quieten readr::read_tsv during test
      .f = function(...) readr::read_tsv(..., show_col_types = FALSE)
    )

  expect_equal(actual, expected_file)
})

test_that("roster-by-id", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- readr::read_rds(system.file("dataset-basketball/dataframe-from-tab.rds", package = "dataverse"))

  actual <-
    get_dataframe_by_id(
      fileid   = expected_ds$roster$dataFile$id, # A value like 1734005
      # quieten readr::read_tsv during test
      .f = function(...) readr::read_tsv(..., show_col_types = FALSE)
    )

  expect_equal(actual, expected_file)
})

test_that("load-rdata", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()

  get_dataframe_by_id(
    file = 1939003,
    server = "demo.dataverse.org",
    original = TRUE,
    .f = function(x) load(x, envir = .GlobalEnv))

  expect_s3_class(nlsw88, "tbl")
})
