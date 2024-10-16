#' @param version A character specifying a version of the dataset.
#'  This can be of the form `"1.1"` or `"1"` (where in `"x.y"`, x is a major
#'  version and y is an optional minor version), or
#'  `":latest"` (the default, the latest published version).
#'  In lieu of this, a dataset's version-specific identification number can be
#'  used for the `dataset` argument. We recommend using the number format so that
#'  the function stores a cache of the data (See \code{\link{cache_dataset}}).
#'  If the user specifies a `key` or `DATAVERSE_KEY` argument, they can access the
#'  draft version by `":draft"` (the current draft) or `":latest"` (which will
#'  prioritize the draft over the latest published version.
