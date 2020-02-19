# See https://demo.dataverse.org/dataverse/dataverse-client-r

test_that("dataverse root", {
  expected_length_minimum <- 300 # 397 as of Feb 2020

  dv      <- get_dataverse(dataverse = ":root")
  actual  <- dataverse_contents(dv)
  expect_gte(length(actual), expected_length_minimum)
})

test_that("dataverse for 'dataverse-client-r'", {
    expected  <- structure(
    list(
      id = 396356L,
      identifier = "FK2/FAN622",
      persistentUrl = "https://doi.org/10.70122/FK2/FAN622",
      protocol = "doi",
      authority = "10.70122",
      publisher = "Demo Dataverse",
      storageIdentifier = "file://10.70122/FK2/FAN622",
      type = "dataset"
    ),
    class = "dataverse_dataset"
  )

  dv      <- get_dataverse(dataverse = "dataverse-client-r")
  actual  <- dataverse_contents(dv)
  expect_equal(actual[[1]], expected)
})
