# See https://demo.dataverse.org/dataverse/dataverse-client-r

test_that("dataverse root", {
  testthat::skip_if_offline("demo.dataverse.org")
  expected <- retrieve_info_dataverse("expected-dataverse-root.yml")

  # The code below can be encapsulated in a separate function, if many dataverses are tested.
  actual <- get_dataverse(dataverse = expected$testing_name)
  expect_equal(actual$id                      , expected$id)
  expect_equal(actual$alias                   , expected$alias)
  expect_equal(actual$name                    , expected$name)
  expect_equal(actual$description             , expected$description)
  expect_equal(actual$creationDate            , expected$creationDate) # Notice this is a string
  expect_s3_class(actual$dataverseContacts    , "data.frame")
})

test_that("dataverse for 'dataverse-client-r'", {
  testthat::skip_if_offline("demo.dataverse.org")
  expected <- retrieve_info_dataverse("expected-dataverse.yml")

  # The code below can be encapsulated in a separate function, if many dataverses are tested.
  actual <- get_dataverse(dataverse = expected$testing_name)
  expect_equal(actual$id                      , expected$id)
  expect_equal(actual$alias                   , expected$alias)
  expect_equal(actual$name                    , expected$name)
  expect_equal(actual$description             , expected$description)
  expect_equal(actual$creationDate            , expected$creationDate) # Notice this is a string
  expect_s3_class(actual$dataverseContacts    , "data.frame")
})
