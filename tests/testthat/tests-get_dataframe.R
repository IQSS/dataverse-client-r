# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/HXJVJU

test_that("roster-original", {
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- expected_ds$roster$raw_value

  actual <-
    get_dataframe_by_name(
      filename = expected_ds$roster$label , #"roster-bulls-1996.tab",
      dataset  = dirname(expected_ds$roster$dataFile$persistentId), #"doi:10.70122/FK2/HXJVJU",
      original = TRUE,
      FUN      = readr::read_file
    )

  expect_equal(substr(actual, 1, 30), substr(expected_file, 1, 30))
  expect_equal(nchar( actual       ), nchar( expected_file       ))

  expect_equal(actual, expected_file)
})

test_that("image-original", {
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- expected_ds$image$raw_value

  actual <-
    get_dataframe_by_name(
      filename = expected_ds$image$label , #"vector-basketball.svg",
      dataset  = dirname(expected_ds$image$dataFile$persistentId), #"doi:10.70122/FK2/HXJVJU",
      original = TRUE,
      FUN      = readr::read_file
    )

  expect_equal(substr(actual, 1, 30), substr(expected_file, 1, 30))
  expect_equal(nchar( actual       ), nchar( expected_file       ))

  expect_equal(actual, expected_file)
})
