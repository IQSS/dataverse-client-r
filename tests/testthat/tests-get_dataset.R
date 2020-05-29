# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/FAN622

test_that("download tab from DOI and filename", {
  dv        <- get_dataverse("dataverse-client-r")
  contents  <- dataverse_contents(dv)
  actual    <- get_dataset(contents[[1]])
  files     <- actual$files

  expect_length(actual                      , 16L)
  expect_equal(actual$id                    , 53155L)
  expect_equal(actual$datasetId             , 396356L)
  expect_equal(actual$datasetPersistentId   , "doi:10.70122/FK2/FAN622")
  expect_equal(actual$storageIdentifier     , "file://10.70122/FK2/FAN622")
  expect_equal(actual$versionState          , "RELEASED")
  expect_equal(actual$UNF                   , "UNF:6:hrleySyT6vzwEih3+nhp8A==")
  expect_equal(actual$license               , "CC0")

  expect_equal(nrow(files)                  , 2L)
  expect_equal(ncol(files)                  , 21L)

  expect_equal(files$label            , c("roster-bulls-1996.tab", "vector-basketball.svg"))
  expect_equal(files$restricted       , c(FALSE, FALSE))
  expect_equal(files$version          , c(2L, 2L))
  expect_equal(files$datasetVersionId , c(53155L, 53155L))
  expect_equal(files$directoryLabel   , c(NA, "resources"))
  expect_equal(files$id               , c(396357L, 769385L))
  expect_equal(files$persistentId     , c("doi:10.70122/FK2/FAN622/FIIFV8", "doi:10.70122/FK2/FAN622/ZZE4B0"))
  expect_equal(files$pidURL           , c("https://doi.org/10.70122/FK2/FAN622/FIIFV8", "https://doi.org/10.70122/FK2/FAN622/ZZE4B0"))
  expect_equal(files$filename         , c("roster-bulls-1996.tab", "vector-basketball.svg"))
  expect_equal(files$description      , c(NA, "CC-0-from-https://publicdomainvectors.org/en/free-clipart/Basketball-vector-symbol/69448.html"))

})
