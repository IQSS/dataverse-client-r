# See https://demo.dataverse.org/dataverse/dataverse-client-r
# https://doi.org/10.70122/FK2/HXJVJU

# standarize_string <- function (x) {
#   substring(x, 1, 10)
# }
standarize_string <- function (x, start = 1, stop = nchar(x)) {
  x %>%
    base::iconv(
      x     = .,
      from  = "latin1",
      to    = "ASCII//TRANSLIT",
      sub   = "?"
    ) %>%
    sub("KukoA?,SF", "Kukoc,SF") %>%
    substring(start, stop)
}

test_that("roster-by-name", {
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- expected_ds$roster$raw_value

  actual <-
    get_dataframe_by_name(
      filename = expected_ds$roster$label , # A value like "roster-bulls-1996.tab",
      dataset  = dirname(expected_ds$roster$dataFile$persistentId), # A value like "doi:10.70122/FK2/HXJVJU",
      original = TRUE,
      .f       = readr::read_file
    )

  expect_equal(substr(actual, 1, 30), substr(expected_file, 1, 30))
  expect_equal(nchar( actual       ), nchar( expected_file       ))

  # actual        <- standarize_string(actual)
  # expected_file <- standarize_string(expected_file)
  # expect_equal(actual, expected_file)
  expect_equal(standarize_string(actual, 0001,  0100), standarize_string(expected_file, 0001,  0100))
  expect_equal(standarize_string(actual, 0101,  0200), standarize_string(expected_file, 0101,  0200))
  expect_equal(standarize_string(actual, 0201,  0300), standarize_string(expected_file, 0201,  0300))
  expect_equal(standarize_string(actual, 0301,  0400), standarize_string(expected_file, 0301,  0400))
  expect_equal(standarize_string(actual, 0401,  0500), standarize_string(expected_file, 0401,  0500))
  expect_equal(standarize_string(actual, 0501,  0600), standarize_string(expected_file, 0501,  0600))
  expect_equal(standarize_string(actual, 0601,  0700), standarize_string(expected_file, 0601,  0700))
  expect_equal(standarize_string(actual, 0701,  0800), standarize_string(expected_file, 0701,  0800))
  expect_equal(standarize_string(actual, 0801,  0900), standarize_string(expected_file, 0801,  0900))
  expect_equal(standarize_string(actual, 0901,  1000), standarize_string(expected_file, 0901,  1000))
  expect_equal(standarize_string(actual, 1001,  1085), standarize_string(expected_file, 1001,  1085))


  expect_equal(standarize_string(actual), standarize_string(expected_file))
})

test_that("roster-by-doi", {
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- expected_ds$roster$raw_value

  actual <-
    get_dataframe_by_doi(
      filedoi  = expected_ds$roster$dataFile$persistentId, # A value like "doi:10.70122/FK2/HXJVJU/SA3Z2V",
      original = TRUE,
      .f       = readr::read_file
    )

  expect_equal(substr(actual, 1, 30), substr(expected_file, 1, 30))
  expect_equal(nchar( actual       ), nchar( expected_file       ))

  actual        <- standarize_string(actual)
  expected_file <- standarize_string(expected_file)

  expect_equal(actual, expected_file)
})

test_that("roster-by-id", {
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- expected_ds$roster$raw_value

  actual <-
    get_dataframe_by_id(
      fileid   = expected_ds$roster$dataFile$id, # A value like 1734005
      original = TRUE,
      .f       = readr::read_file
    )

  expect_equal(substr(actual, 1, 30), substr(expected_file, 1, 30))
  expect_equal(nchar( actual       ), nchar( expected_file       ))

  actual        <- standarize_string(actual)
  expected_file <- standarize_string(expected_file)

  expect_equal(actual, expected_file)
})

test_that("image-by-name", {
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- expected_ds$image$raw_value

  actual <-
    get_dataframe_by_name(
      filename = expected_ds$image$label , #"vector-basketball.svg",
      dataset  = dirname(expected_ds$image$dataFile$persistentId), #"doi:10.70122/FK2/HXJVJU",
      original = TRUE,
      .f       = readr::read_file
    )

  expect_equal(substr(actual, 1, 30), substr(expected_file, 1, 30))
  expect_equal(nchar( actual       ), nchar( expected_file       ))

  expect_equal(actual, expected_file)
})

test_that("image-by-doi", {
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- expected_ds$image$raw_value

  actual <-
    get_dataframe_by_doi(
      filedoi  = expected_ds$image$dataFile$persistentId, # A value like "doi:10.70122/FK2/HXJVJU/FHV8ZB",
      original = TRUE,
      .f       = readr::read_file
    )

  expect_equal(substr(actual, 1, 30), substr(expected_file, 1, 30))
  expect_equal(nchar( actual       ), nchar( expected_file       ))

  expect_equal(actual, expected_file)
})

test_that("image-by-id", {
  expected_ds <- retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
  expected_file <- expected_ds$image$raw_value

  actual <-
    get_dataframe_by_id(
      fileid   = expected_ds$image$dataFile$id, # A value like 1734006
      original = TRUE,
      .f       = readr::read_file
    )

  expect_equal(substr(actual, 1, 30), substr(expected_file, 1, 30))
  expect_equal(nchar( actual       ), nchar( expected_file       ))

  expect_equal(actual, expected_file)
})
