# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/HXJVJU

test_that("download tab from DOI and filename", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  dv        <- get_dataverse("dataverse-client-r")
  contents  <- dataverse_contents(dv)
  ds_index  <- which(sapply(contents, function(x) x$identifier) == "FK2/HXJVJU")
  actual    <- get_dataset(contents[[ds_index]])
  files     <- actual$files
  expected_dv <- retrieve_info_dataverse("expected-dataverse.yml")

  expect_length(actual                      , 15L)
  expect_equal(actual$id                    , 182158L)
  expect_equal(actual$datasetId             , 1734004L)
  expect_equal(actual$datasetPersistentId   , "doi:10.70122/FK2/HXJVJU")
  expect_equal(actual$storageIdentifier     , "file://10.70122/FK2/HXJVJU")
  expect_equal(actual$versionState          , "RELEASED")
  expect_equal(actual$UNF                   , "UNF:6:hrleySyT6vzwEih3+nhp8A==")
  expect_equal(actual$license$name          , "CC0 1.0")

  expect_equal(nrow(files)                  , 2L)
  expect_equal(ncol(files)                  , 22L)

  expect_setequal(files$label            , c("roster-bulls-1996.tab", "vector-basketball.svg"))
  expect_setequal(files$restricted       , c(FALSE, FALSE))
  expect_setequal(files$version          , c(3L, 2L))
  expect_setequal(files$datasetVersionId , c(actual$id, actual$id))
  expect_setequal(files$directoryLabel   , c(NA, "resources"))
  expect_setequal(files$id               , c(1734005L, 1734006L))
  expect_setequal(files$persistentId     , c("doi:10.70122/FK2/HXJVJU/SA3Z2V", "doi:10.70122/FK2/HXJVJU/FHV8ZB"))
  expect_setequal(files$pidURL           , c("https://doi.org/10.70122/FK2/HXJVJU/SA3Z2V", "https://doi.org/10.70122/FK2/HXJVJU/FHV8ZB"))
  expect_setequal(files$filename         , c("roster-bulls-1996.tab", "vector-basketball.svg"))
  # expect_equal(files$description      , c(NA, "CC-0-from-https://publicdomainvectors.org/en/free-clipart/Basketball-vector-symbol/69448.html"))

})
