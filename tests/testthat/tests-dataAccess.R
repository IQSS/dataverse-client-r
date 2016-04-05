context("Data Access API")

test_that("get file metadata from DOI and filename", {
    f1 <- get_metadata("constructionData.tab", "doi:10.7910/DVN/ARKOTI", server = "dataverse.harvard.edu")
    expect_true(is.list(f1))
})

test_that("get file metadata from file id", {
    f1 <- get_metadata(2692202, server = "dataverse.harvard.edu")
    expect_true(is.list(f1))
})

test_that("download file from DOI and filename", {
    f1 <- get_file("constructionData.tab", "doi:10.7910/DVN/ARKOTI", server = "dataverse.harvard.edu")
    expect_true(is.raw(f1))
})

test_that("download file from file id", {
    f2 <- get_file(2692202, server = "dataverse.harvard.edu")
    expect_true(is.raw(f2))
})
