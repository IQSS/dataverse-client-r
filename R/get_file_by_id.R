#' @title Download Single File by dataverse ID
#'
#' @rdname files
#'
#' @param archival If a ingested (.tab) version is available, download
#'  the ingested archival version or not?
#'
#' @importFrom xml2 read_xml as_list
#'
#' @export
get_file_by_id <-
  function(fileid,
           dataset = NULL,
           server,
           format = c("original", "RData", "prep", "bundle"),
           vars,
           archival = NULL,
           key = Sys.getenv("DATAVERSE_KEY"),
           ...) {
    format <- match.arg(format)

    # single file ID
    stopifnot(is.numeric(fileid))
    stopifnot(length(fileid) == 1)

    # detect file type to determine if something is ingested
    if (!is.null(archival)) {
      xml <- read_xml(get_file_metadata(fileid, server = server))
      filename <- as_list(xml)$codeBook$fileDscr$fileTxt$fileName[[1]]
      is_ingested <- grepl(x = filename, pattern = "\\.tab$")

      if (archival & !is_ingested)
        stop("The file does not have a .tab suffix so does not appear ingested.")
    } else {
      is_ingested <- FALSE
    }

    # update archival if not specified
    if (is.null(archival))
      archival <- FALSE

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

    # request single file in non-bundle format ----
    u <- paste0(api_url(server), "access/datafile/", fileid)
    # add query if you want to want the original version even though ingested
    if (is_ingested & !archival) {
      r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), query = query, ...)
    } else {
      # do not add query if not an ingestion file
      r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    }

    httr::stop_for_status(r)
    out <-  httr::content(r, as = "raw")

    return(out)

  }
