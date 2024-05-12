#' @title Get Dataverse file download URL
#'
#' @description Get URL. `get_url_*` functions return a download URL as a string
#'  that can be then used in outside functions such as `curl::curl_download()`.
#'
#' @inheritParams get_file
#' @name URLs
#' @export
#' @examples \dontrun{
#' # get URLs
#' get_url_by_name(
#'   filename = "nlsw88.tab",
#'   dataset  = "10.70122/FK2/PPIAXE",
#'   server   = "demo.dataverse.org"
#' )
#' # https://demo.dataverse.org/api/access/datafile/1734017?format=original
#'
#' # For ingested, tab-delimited files
#' get_url_by_name(
#'   filename = "nlsw88.tab",
#'   dataset  = "10.70122/FK2/PPIAXE",
#'   original = FALSE,
#'   server   = "demo.dataverse.org"
#' )
#' # https://demo.dataverse.org/api/access/datafile/1734017
#'
#' # To download to local directory
#' curl::curl_download(
#'  "https://demo.dataverse.org/api/access/datafile/1734017?format=original",
#'  destfile = "nlsw88.dta")
#' }
get_url <- function(
    file,
    dataset     = NULL,
    format      = c("original", "bundle"),
    key         = Sys.getenv("DATAVERSE_KEY"),
    server      = Sys.getenv("DATAVERSE_SERVER"),
    original    = TRUE,
    ...) {

  get_file(
    fileid      = prepend_doi(filedoi),
    dataset     = dataset,
    format      = format,
    key         = key,
    server      = server,
    return_url  = TRUE,
    original    = original,
    ...
  )
}

#' @rdname URLs
#' @export
get_url_by_name <- function(
  filename,
  dataset,
  format        = c("original", "bundle"),
  key           = Sys.getenv("DATAVERSE_KEY"),
  server        = Sys.getenv("DATAVERSE_SERVER"),
  original      = TRUE,
  ...
) {
  format <- match.arg(format)

  get_file_by_name(
    filename,
    dataset,
    format      = format,
    key         = key,
    server      = server,
    original    = original,
    return_url  = TRUE,
    ...
  )
}

#' @rdname URLs
#' @export
get_url_by_id <- function(
    fileid,
    dataset     = NULL,
    format      = c("original", "bundle"),
    key         = Sys.getenv("DATAVERSE_KEY"),
    server      = Sys.getenv("DATAVERSE_SERVER"),
    original    = TRUE,
    ...) {

  format <- match.arg(format)
  get_file_by_id(
    fileid,
    dataset     = NULL,
    format      = c("original", "bundle"),
    key         = key,
    server      = server,
    original    = original,
    return_url  = TRUE,
    ...
  )
}

#' @rdname URLs
#' @export
get_url_by_doi <- function(
    filedoi,
    dataset     = NULL,
    format      = c("original", "bundle"),
    key         = Sys.getenv("DATAVERSE_KEY"),
    server      = Sys.getenv("DATAVERSE_SERVER"),
    original    = TRUE,
    ...) {
  format <- match.arg(format)
  get_file_by_doi(
    filedoi,
    dataset     = NULL,
    format      = c("original", "bundle"),
    key         = key,
    server      = server,
    original    = original,
    return_url  = TRUE,
    ...
  )
}
