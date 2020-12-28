#' @rdname files
#'
#' @param archival If a ingested (.tab) version is available, download
#'  the ingested archival version or not?
#' @param fileid A numeric ID internally used for `get_file_by_id`
#'
#' @importFrom xml2 read_xml as_list
#'
#' @export
get_file_by_id <-
  function(fileid,
           dataset = NULL,
           server = Sys.getenv("DATAVERSE_SERVER"),
           format = c("original", "RData", "prep", "bundle"),
           vars = NULL,
           archival = NULL,
           key = Sys.getenv("DATAVERSE_KEY"),
           ...) {
    format <- match.arg(format)

    # single file ID
    stopifnot(is.numeric(fileid))
    stopifnot(length(fileid) == 1)

    # ping get_file_metadata to see if file is ingested
    ping_metadata <- tryCatch(get_file_metadata(fileid, server = server),
                              error = function(e) e)
    is_ingested <- !inherits(ping_metadata, "error") # if error, not ingested

    # update archival if not specified
    if (is.null(archival))
      archival <- FALSE

    # check
    if (archival & !is_ingested)
      stop("You requested an archival version, but the file has no metadata so does not appear ingested.")


    # downloading files sequentially and add the raw vectors to a list
    out <- vector("list", length(fileid))

    # create query -----
    query <- list()
    if (!is.null(vars)) {
      query$vars <- paste0(vars, collapse = ",")
    }
    if (!is.null(format)) {
      query$format <- match.arg(format)
    }

    # if bundle, use custom url ----
    if (format == "bundle") {
      u <- paste0(api_url(server), "access/datafile/bundle/", fileid)
      r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
      out <- httr::content(r, as = "raw")
      return(out)
    }

    # If not bundle, request single file in non-bundle format ----
    u <- paste0(api_url(server), "access/datafile/", fileid)
    # add query if you want to want the original version even though ingested
    if (is_ingested & !archival) {
      r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), query = query, ...)
    } else {
      # do not add query if not an ingestion file
      r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    }

    httr::stop_for_status(r)
    out <- httr::content(r, as = "raw")
    return(out)
  }
