#' @rdname get_dataset
#' @title Get dataset metadata
#' @description Retrieve metadata. To actually download a data file,
#'  see \code{\link{get_file}} or \code{\link{get_dataframe_by_name}}.
#'
#' @details
#' \code{get_dataset} retrieves details about a Dataverse dataset.
#'
#' \code{dataset_metadata} returns a named metadata block for a dataset.
#' This is already returned by \code{\link{get_dataset}}, but this function allows
#' you to retrieve just a specific block of metadata, such as citation information.
#'
#' \code{dataset_files} returns a list of files in a dataset, similar to
#' \code{\link{get_dataset}}. The difference is that this returns only a list of
#' \dQuote{dataverse_dataset} objects, whereas \code{\link{get_dataset}} returns
#' metadata and a data.frame of files (rather than a list of file objects).
#'
#'
#' @template ds
#' @template version
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{dataverse_dataset} or a list of a form dependent
#'  on the specific metadata block retrieved. \code{dataset_files} returns a list of
#'  objects of class \dQuote{dataverse_file}.
#' @examples
#' \dontrun{
#' # https://demo.dataverse.org/dataverse/dataverse-client-r
#' Sys.setenv("DATAVERSE_SERVER" = "demo.dataverse.org")
#'
#' # download file from:
#' dv <- get_dataverse("dataverse-client-r")
#' contents <- dataverse_contents(dv)[[1]]
#'
#' dataset_files(contents[[1]])
#' get_dataset(contents[[1]])
#' dataset_metadata(contents[[1]])
#'
#' Sys.unsetenv("DATAVERSE_SERVER")
#' }
#' @seealso \code{\link{get_file}}
#' @export
get_dataset <- function(
  dataset,
  version    = ":latest",
  key        = Sys.getenv("DATAVERSE_KEY"),
  server     = Sys.getenv("DATAVERSE_SERVER"),
  ...
) {
  dataset <- dataset_id(dataset, key = key, server = server, ...)
  if (!is.null(version)) {
    u <- paste0(api_url(server), "datasets/", dataset, "/versions/", version)
  } else {
    u <- paste0(api_url(server), "datasets/", dataset)
  }
  r <- api_get(u, ..., key = key)
  parse_dataset(r)
}

#' @rdname get_dataset
#' @param block A character string specifying a metadata block to retrieve.
#'  By default this is \dQuote{citation}. Other values may be available, depending
#'  on the dataset, such as \dQuote{geospatial} or \dQuote{socialscience}.
#'
#' @export
dataset_metadata <- function(
  dataset,
  version     = ":latest",
  block       = "citation",
  key         = Sys.getenv("DATAVERSE_KEY"),
  server      = Sys.getenv("DATAVERSE_SERVER"),
  ...
 ) {
  dataset <- dataset_id(dataset, key = key, server = server, ...)
  if (!is.null(block)) {
    u <- paste0(api_url(server), "datasets/", dataset, "/versions/", version, "/metadata/", block)
  } else {
    u <- paste0(api_url(server), "datasets/", dataset, "/versions/", version, "/metadata")
  }

  r <- api_get(u, ..., key = key)
  jsonlite::fromJSON(r)[["data"]]
}

#' @rdname get_dataset
#' @export
dataset_files <- function(
  dataset,
  version   = ":latest",
  key       = Sys.getenv("DATAVERSE_KEY"),
  server    = Sys.getenv("DATAVERSE_SERVER"),
  ...
) {
  dataset <- dataset_id(dataset, key = key, server = server, ...)
  u <- paste0(api_url(server), "datasets/", dataset, "/versions/", version, "/files")
  r <- api_get(u, ..., key = key)
  out <- jsonlite::fromJSON(r, simplifyDataFrame = FALSE)$data
  structure(lapply(out, `class<-`, "dataverse_file"))
}
