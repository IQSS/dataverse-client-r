if (Sys.getenv("DATAVERSE_KEY") != "") {
    context("Native API (authenticated functions)")

    test_that("placeholder", {
        expect_true(TRUE)
    })
}

context("Native API (unauthenticated functions)")

test_that("placeholder", {
    expect_true(TRUE)
})
