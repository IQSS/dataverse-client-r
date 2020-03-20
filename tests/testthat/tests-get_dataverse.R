# See https://demo.dataverse.org/dataverse/dataverse-client-r

test_that("dataverse root", {
  actual <- get_dataverse(
    dataverse = ":root"
  )
  expect_equal(actual$id, 1L)
  expect_equal(actual$alias, "demo")
  expect_equal(actual$name, "Demo Dataverse")
  expect_s3_class(actual$dataverseContacts, "data.frame")
  expect_match(actual$description, "^.+This Dataverse is for demo purposes only\\..+$")
  expect_equal(actual$creationDate, "2015-04-16T17:46:00Z") # Notice this is a string
})

test_that("dataverse for 'dataverse-client-r'", {
  actual <- get_dataverse(
    dataverse = "dataverse-client-r"
  )
  expect_equal(actual$id, 396355)
  expect_equal(actual$alias, "dataverse-client-r")
  expect_equal(actual$name, "dataverse-client-r")
  expect_equal(actual$affiliation, "IQSS")
  expect_s3_class(actual$dataverseContacts, "data.frame")
  expect_match(actual$description, "^Dataverse for testing.+$")
  expect_equal(actual$creationDate, "2020-01-02T04:18:06Z") # Notice this is a string
})
