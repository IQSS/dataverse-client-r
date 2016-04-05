context("SWORD API")

if (Sys.getenv("DATAVERSE_KEY") != "") {
    test_that("placeholder", {
        expect_true(TRUE)
    })
}
