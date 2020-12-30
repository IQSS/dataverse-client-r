# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/HXJVJU

test_that("download tab from DOI and filename", {
  dv        <- get_dataverse("dataverse-client-r")
  contents  <- dataverse_contents(dv)
  actual    <- dataset_files(contents[[1]])
  yml       <- yaml::read_yaml(system.file("dataset-basketball/expected-metadata.yml", package = "dataverse"))

  ds_expected <-
    data.frame(
      label              = purrr::map_chr(yml, "label"),
      restricted         = purrr::map_lgl(yml, "restricted"),
      version            = purrr::map_int(yml, "version"),
      datasetVersionId   = purrr::map_int(yml, "datasetVersionId")
    )

  expect_length(actual, 2L)
  expect_equal(purrr::map_chr(actual, "label")            , ds_expected$label)
  expect_equal(purrr::map_lgl(actual, "restricted")       , ds_expected$restricted)
  expect_equal(purrr::map_int(actual, "version")          , ds_expected$version)
  expect_equal(purrr::map_int(actual, "datasetVersionId") , ds_expected$datasetVersionId)
})
