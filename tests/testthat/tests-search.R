context("Search API")

test_that("simple search query", {
    expect_true(is.data.frame(dataverse_search("Gary King", key = "", server = "dataverse.harvard.edu")))
})

test_that("named argument search", {
    expect_true(is.data.frame(dataverse_search(author = "Gary King", title = "Ecological Inference", key = "", server = "dataverse.harvard.edu")))
})

test_that("simple search w/type argument", {
    expect_true(is.data.frame(dataverse_search(author = "Gary King", type = "dataset", key = "", server = "dataverse.harvard.edu")))
})
