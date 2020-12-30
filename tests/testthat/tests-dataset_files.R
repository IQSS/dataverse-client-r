# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/HXJVJU

test_that("download tab from DOI and filename", {
  dv        <- get_dataverse("dataverse-client-r")
  contents  <- dataverse_contents(dv)
  actual    <- dataset_files(contents[[1]])

  expect_length(actual, 2L)
  expect_equal(purrr::map_chr(actual, "label")            , c("roster-bulls-1996.tab", "vector-basketball.svg"))
  expect_equal(purrr::map_lgl(actual, "restricted")       , c(FALSE, FALSE))
  expect_equal(purrr::map_int(actual, "version")          , c(3L, 2L))
  expect_equal(purrr::map_int(actual, "datasetVersionId") , c(182158L, 182158L))
})
