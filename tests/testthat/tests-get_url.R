# Informative error message (PR #30)
test_that("Return just URL", {
  testthat::skip_on_cran()
  expect_equal(
    get_file(c(1734005, 1734006),
             server = "demo.dataverse.org",
             original = TRUE,
             return_url = TRUE),
    list("https://demo.dataverse.org/api/access/datafile/1734005?format=original",
         "https://demo.dataverse.org/api/access/datafile/1734006"))

  expect_equal(
    get_url_by_name(
      filename = "nlsw88.tab",
      dataset  = "10.70122/FK2/PPIAXE",
      server   = "demo.dataverse.org"
    ),
    expected = "httpshttps://demo.dataverse.org/api/access/datafile/1734017?format=original")
})
