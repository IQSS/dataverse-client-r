library("testthat")
library("dataverse")

key <- Sys.getenv("DATAVERSE_KEY")
if (!is.null(key) && key != "") {
    test_check("dataverse")
}
