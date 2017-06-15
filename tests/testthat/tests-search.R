context("Search API")

test_that("simple search query", {
    expect_true(is.data.frame(dataverse_search("Gary King", server = "dataverse.harvard.edu")))
})

test_that("named argument search", {
    expect_true(is.data.frame(dataverse_search(author = "Gary King", title = "Ecological Inference", server = "dataverse.harvard.edu")))
})

test_that("simple search w/type argument", {
    expect_true(is.data.frame(dataverse_search(author = "Gary King", type = "dataset", server = "dataverse.harvard.edu")))
})
