# See https://demo.dataverse.org/dataverse/dataverse-client-r

test_that("dataverse root", {
  expected <-
    structure(
      list(
        title = "Demo Dataverse",
        generator = structure(
          list(),
          uri = "http://www.swordapp.org/",
          version = "2.0"
        ),
        dataverseHasBeenReleased = "true",
        datasets = structure(
          list(),
          .Names = character(0),
          class = "data.frame",
          row.names = integer(0)
        )
      ),
      class = "dataverse_dataset_list"
    )

  dv     <- get_dataverse(":root")
  actual <- list_datasets(dv)

  expect_equal(actual, expected)
})

test_that("dataverse for 'dataverse-client-r'", {
  expected <-
    structure(
      list(
        title = "dataverse-client-r",
        generator = structure(
          list(),
          uri = "http://www.swordapp.org/",
          version = "2.0"
        ),
        dataverseHasBeenReleased = "false",
        datasets = structure(
          list(
            title = structure(
              1L,
              .Label = "Bulls Roster 1996-1997",
              class = "factor"
            ),
            id = structure(
              1L,
              .Label = "https://demo.dataverse.org/dvn/api/data-deposit/v1.1/swordv2/edit/study/doi:10.70122/FK2/FAN622",
              class = "factor"
            )
          ),
          class = "data.frame",
          row.names = 1L
        )
      ),
      class = "dataverse_dataset_list"
    )

  dv <- get_dataverse("dataverse-client-r")
  actual <- list_datasets(dv)

  expect_equal(actual, expected)
})
