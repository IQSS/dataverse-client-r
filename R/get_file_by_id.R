#' @rdname files
#'
#' @param original A logical, defaulting to TRUE. If a ingested (.tab) version is
#' available, download the original version instead of the ingested? If there was
#' no ingested version, is set to NA. Note in `get_dataframe_*`,
#' `original` is set to FALSE by default. Either can be changed.
#' @param fileid A numeric ID internally used for `get_file_by_id`. Can be a vector for multiple files.
#' @param progress Whether to show a progress bar of the download.
#'   If not specified, will be set to `TRUE` for a file larger than 100MB. To fix
#'   a value, set `FALSE` or `TRUE`.
#' @param return_url Instead of downloading the file, return the URL for download.
#'  Defaults to `FALSE`.
#'
#' @export
get_file_by_id <- function(
  fileid,
  dataset         = NULL,
  format          = c("original", "bundle"),
  vars            = NULL,
  original        = TRUE,
  progress        = NULL,
  return_url      = FALSE,
  key             = Sys.getenv("DATAVERSE_KEY"),
  server          = Sys.getenv("DATAVERSE_SERVER"),
  ...
) {
    format <- match.arg(format)

    if (length(fileid) != 1L) {
      stop("The `fileid` parameter must be single element.")
    } else if (!(inherits(fileid, "numeric") | inherits(fileid, "integer") | inherits(fileid, "character"))) {
      stop("The `fileid` data type must be numeric, integer, or character.")
    }
    # `dataset` place holder.
    checkmate::assert_character(format  , any.missing = FALSE, len = 1)
    # `vars` place holder.
    checkmate::assert_logical(  original, any.missing = TRUE , len = 1)
    checkmate::assert_character(key     , any.missing = FALSE, len = 1)
    checkmate::assert_character(server  , any.missing = FALSE, len = 1)

    # must be a number OR doi string in the form of "doi:"
    use_persistent_id <- !is.numeric(fileid)
    if (use_persistent_id) {
      if (!grepl(x = fileid, pattern = "^doi:"))
        stop("A 'persistent' fileid must be prefixed with 'doi:'. It was `", fileid, "`.")
    } else {
      if (!checkmate::check_integerish(fileid))
        stop("A 'non-persistent' fileid must be a whole number.  It was `", fileid, "`.")
    }

    # ping get_file_metadata to see if file is ingested
    ingested <- is_ingested(fileid, server = server, key = key)

    # if progress = NULL, determine progress by size
    if (is.null(progress)) {
      bytesize <- get_filesize(fileid, server = server, key = key)
      if (isTRUE(bytesize > 1e8)) {
        progress <- TRUE
      } else {
        progress <- FALSE
      }
    }

    # update archival if not specified
    if (isFALSE(ingested))
      original <- NA

    # create query -----
    query <- list()

    # variables
    if (!is.null(vars))
      query$vars <- paste0(vars, collapse = ",")

    # format only matters in ingested datasets,
    # For non-ingested files (e.g. rds/docx), we need to NOT specify a format
    # also for bundle, only change url
    if (ingested & format != "bundle")
      query$format <- match.arg(format)

    # if the original is not desired, we need to NOT specify a format
    if (ingested & (isFALSE(original) || is.na(original) || is.null(original)))
      query$format <- NULL

    # part of URL depending on DOI, bundle, or file
    if (use_persistent_id) {
      u_part <- "access/datafile/:persistentId?persistentId="
    } else if (format == "bundle") {
      u_part <- "access/datafile/bundle/"
    } else if (format == "original") {
      u_part <- "access/datafile/"
    } else {
      stop("The `format` value should be 'bundle' or 'original', or a doi needs to be passed to `fileid`.")
    }

    # If not bundle, request single file in non-bundle format ----
    u <- paste0(api_url(server), u_part, fileid)
    if (return_url) {
      return(httr::modify_url(u, query = query))
    }
    # add a progress bar; 'NULL' if progress is not TRUE. 'NULL' arguments
    # are not seen by httr::GET()
    progress_bar <- if (isTRUE(progress)) httr::progress(type = "down")
    api_get(u, query = query, progress_bar, ..., key = key, as = "raw")
  }

#' @rdname files
#' @param filedoi A DOI for a single file (not the entire dataset), of the form
#'  `"10.70122/FK2/PPIAXE/MHDB0O"` or `"doi:10.70122/FK2/PPIAXE/MHDB0O"`.
#'  Can be a vector for multiple files.
#'
#' @export
get_file_by_doi <- function(
  filedoi,
  dataset         = NULL,
  format          = c("original", "bundle"),
  vars            = NULL,
  original        = TRUE,
  return_url      = FALSE,
  key             = Sys.getenv("DATAVERSE_KEY"),
  server          = Sys.getenv("DATAVERSE_SERVER"),
  ...
) {
  get_file_by_id(
    fileid      = prepend_doi(filedoi),
    dataset     = dataset,
    format      = format,
    vars        = vars,
    key         = key,
    server      = server,
    original    = original,
    return_url  = return_url,
    ...
  )
}
