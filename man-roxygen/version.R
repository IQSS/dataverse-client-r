#' @param version A character string specifying a version of the dataset.
#'  This can be of the form `"1.1"` or `"1"` (where in `"x.y"`, x is a major version and y is an optional minor version),
#'  `":latest"` (the latest draft, if it exists, or the latest published version),
#'  `":latest-published"` (the latest published version, ignoring any draft), or
#'   `":draft"` (the current draft),
#'  In lieu of this, a dataset's version-specific identification number can be used for the \code{dataset} argument.
#'  We recommend using the number format so that the function stores a cache of the data (See \link{cache}).
