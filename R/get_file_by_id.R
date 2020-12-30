#' @rdname files
#'
#' @param original A logical, defaulting to TRUE. If a ingested (.tab) version is
#' available, download the original version instead of the ingested? If there was
#' no ingested version, is set to NA. Note in `get_dataframe_*`,
#' `original` is set to FALSE by default can be changed.
#' @param fileid A numeric ID internally used for `get_file_by_id`
#'
#'
#' @export
get_file_by_id <-
  function(fileid,
           dataset = NULL,
           server = Sys.getenv("DATAVERSE_SERVER"),
           format = c("original", "bundle"),
           vars = NULL,
           original = TRUE,
           key = Sys.getenv("DATAVERSE_KEY"),
           ...) {
    format <- match.arg(format)

    # single file ID
    stopifnot(length(fileid) == 1)

    # must be a number OR doi string in the form of "doi:"
    if (is.numeric(fileid))
      use_persistentID <- FALSE
    if (grepl(x = fileid, pattern = "^doi:"))
      use_persistentID <- TRUE


    # ping get_file_metadata to see if file is ingested
    is_ingested <- is_ingested(fileid, server = server)

    # update archival if not specified
    if (isFALSE(is_ingested))
      original <- NA

    # create query -----
    query <- list()
    if (!is.null(vars))
      query$vars <- paste0(vars, collapse = ",")

    # format only matters in ingested datasets,
    # For non-ingested files (rds/docx), we need to NOT specify a format
    # also for bundle, only change url
    if (is_ingested & format != "bundle")
      query$format <- match.arg(format)

    # if the original is not desired, we need to NOT specify a format
    if (is_ingested & (isFALSE(original) | is.na(original)))
      query$format <- NULL


    # part of URL depending on DOI, bundle, or file
    if (format == "bundle")
      u_part <- "access/datafile/bundle/"

    if (format == "original")
      u_part <- "access/datafile/"

    if (use_persistentID)
      u_part <- "access/datafile/:persistentId/?persistentId="

    # If not bundle, request single file in non-bundle format ----
    u <- paste0(api_url(server), u_part, fileid)
    r <- httr::GET(u,
                   httr::add_headers("X-Dataverse-key" = key),
                   query = query,
                   ...)

    httr::stop_for_status(r)
    httr::content(r, as = "raw")
  }


#' @rdname files
#' @param filedoi A DOI for a single file (not the entire dataset), of the form
#'  `"10.70122/FK2/PPKHI1/ZYATZZ"` or `"doi:10.70122/FK2/PPKHI1/ZYATZZ"`
#'
#' @export
get_file_by_doi <- function(filedoi,
                            dataset = NULL,
                            server = Sys.getenv("DATAVERSE_SERVER"),
                            format = c("original", "bundle"),
                            vars = NULL,
                            original = TRUE,
                            key = Sys.getenv("DATAVERSE_KEY"),
                            ...) {

  get_file_by_id(
    fileid = prepend_doi(filedoi),
    dataset = dataset,
    format = format,
    vars = vars,
    key = key,
    server = server,
    original = original,
    ...
  )

}
