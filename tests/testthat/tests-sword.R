context("SWORD API")

# use demo server: demo.dataverse.org

if (Sys.getenv("DATAVERSE_KEY") != "") {
    test_that("placeholder", {
        expect_true(TRUE)
    })
}
