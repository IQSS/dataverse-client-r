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

test_that("date range search using fq", {
    expect_true(is.data.frame(dataverse_search("*", fq = "dateSort:[2018-01-01T00:00:00Z+TO+2019-01-01T00:00:00Z]", type = "dataset", key = "", server = "dataverse.harvard.edu")))
})

test_that("publication year using fq", {
    expect_true(is.data.frame(dataverse_search("*", fq = "publicationDate:2018", type = "dataset", key = "", server = "dataverse.harvard.edu")))
})

test_that("filter dataverses by subject using fq", {
    expect_true(is.data.frame(dataverse_search("*", fq = "subject_ss:Social+Sciences", type = "dataverse", key = "", server = "dataverse.harvard.edu")))
})

test_that("empty fq search", {
    expect_length(dataverse_search("*", fq = "dateSort:[2019-02-01T00:00:00Z+TO+2019-01-01T00:00:00Z]", type = "dataset", key = "", server = "dataverse.harvard.edu"), 0)
})
