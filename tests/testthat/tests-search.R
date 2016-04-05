context("Search API")

if (Sys.getenv("DATAVERSE_KEY") != "") {

    test_that("simple search query", {
        expect_true(is.data.frame(dataverse_search("Gary King")))
    })

    test_that("named argument search", {
        expect_true(is.data.frame(dataverse_search(author = "Gary King", title = "Ecological Inference")))
    })
    
    test_that("simple search w/type argument", {
        expect_true(is.data.frame(dataverse_search(author = "Gary King", type = "dataset")))
    })

}
