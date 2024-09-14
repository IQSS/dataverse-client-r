#' @param ... Additional arguments passed to an HTTP request function,
#'   such as \code{\link[httr]{GET}}, \code{\link[httr]{POST}}, or
#'   \code{\link[httr]{DELETE}}. By default, HTTP requests use
#'   values cached from previous identical calls. Use
#'   \code{use_cache=FALSE} (or `Sys.setenv(DATAVERSE_USE_CACHE =
#'   FALSE)` if cached API calls are not desired.
