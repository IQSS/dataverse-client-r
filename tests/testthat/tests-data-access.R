context("Data Access API")

test_that("get file metadata from DOI and filename", {
    f1 <- get_file_metadata("constructionData.tab", "doi:10.7910/DVN/ARKOTI", key = "", server = "dataverse.harvard.edu")
    expect_true(is.character(f1))
})

test_that("get file metadata from file id", {
    f1 <- get_file_metadata(2692293, key = "", server = "dataverse.harvard.edu")
    expect_true(is.character(f1))
})

test_that("download file from DOI and filename", {
    f1 <- get_file("constructionData.tab", "doi:10.7910/DVN/ARKOTI", key = "", server = "dataverse.harvard.edu")
    expect_true(is.raw(f1))
})

test_that("download file from file id", {
    f1 <- get_file(2692293, key = "", server = "dataverse.harvard.edu")
    expect_true(is.raw(f1))
})
