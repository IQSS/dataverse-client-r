# See https://demo.dataverse.org/dataverse/dataverse-client-r

test_that("dataverse root", {
  expected <- retrieve_info_dataverse("expected-dataverse-root.yml")
  actual <- get_dataverse(
    dataverse = ":root"
  )
  expect_equal(actual$id                      , expected$id)
  expect_equal(actual$alias                   , expected$alias)
  expect_equal(actual$name                    , expected$name)
  expect_equal(actual$description             , expected$description)
  expect_equal(actual$creationDate            , expected$creationDate) # Notice this is a string
  expect_s3_class(actual$dataverseContacts    , "data.frame")
})

test_that("dataverse for 'dataverse-client-r'", {
  expected <- retrieve_info_dataverse("expected-dataverse.yml")
  actual <- get_dataverse(
    dataverse = "dataverse-client-r"
  )

  expect_equal(actual$id                      , expected$id)
  expect_equal(actual$alias                   , expected$alias)
  expect_equal(actual$name                    , expected$name)
  expect_equal(actual$description             , expected$description)
  expect_equal(actual$creationDate            , expected$creationDate) # Notice this is a string
  expect_s3_class(actual$dataverseContacts    , "data.frame")
})
