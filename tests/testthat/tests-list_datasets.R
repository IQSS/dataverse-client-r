# See https://demo.dataverse.org/dataverse/dataverse-client-r

test_that("dataverse root", {
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
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
  # testthat::skip_if_offline("demo.dataverse.org")
  testthat::skip_on_cran()
  expected <-
    structure(
      list(
        title = "dataverse-client-r",
        generator = structure(
          list(),
          uri = "http://www.swordapp.org/",
          version = "2.0"
        ),
        dataverseHasBeenReleased = "true",
        datasets = structure(list(
          title = c(
            "Basketball - Example Dataset",
            "National Longitudinal Study of Young Women - Example Dataset"
          ),
          id = c(
            "https://demo.dataverse.org/dvn/api/data-deposit/v1.1/swordv2/edit/study/doi:10.70122/FK2/V14QR6",
            "https://demo.dataverse.org/dvn/api/data-deposit/v1.1/swordv2/edit/study/doi:10.70122/FK2/HXJVJU",
            "https://demo.dataverse.org/dvn/api/data-deposit/v1.1/swordv2/edit/study/doi:10.70122/FK2/PPIAXE"
          )
        ),
        class = "data.frame",
        row.names = 1:3
      )),
      class = "dataverse_dataset_list"
    )

  dv <- get_dataverse("dataverse-client-r")
  actual <- list_datasets(dv)

  expect_equal(actual$title, expected$title)
  expect_equal(actual$generator, expected$generator)
  expect_equal(class(actual), class(expected))
  expect_setequal(actual$datasets$id, expected$datasets$id) # order does not matter
})
