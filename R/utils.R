dataverse_id <- function(x, ...) {
    UseMethod('dataverse_id', x)
}

dataverse_id.default <- function(x, ...) {
    x
}

dataverse_id.dataverse <- function(x, ...) {
    x$id
}
