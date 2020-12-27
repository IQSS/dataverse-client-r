#' @title Download Single File by dataverse ID
#'
#' @rdname files
#'
#' @param use_ingested If a ingested (.tab) version is available, download
#'  the ingested version or not? If `format = "original"`, this is forced
#'  to `FALSE`
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
           use_ingested = NULL,
           key = Sys.getenv("DATAVERSE_KEY"),
           ...) {
    format <- match.arg(format)

    # single file ID
    stopifnot(is.numeric(fileid))
    stopifnot(length(fileid) == 1)

    # detect file type to determine if something is ingested
    xml <- read_xml(get_file_metadata(fileid, server = server))
    filename <- as_list(xml)$codeBook$fileDscr$fileTxt$fileName[[1]]
    is_ingested <- grepl(x = filename, pattern = "\\.tab$")

    # update use_ingested if not specified
    if (is_ingested & is.null(use_ingested))
      use_ingested <- FALSE

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
    if (is_ingested & !use_ingested) {
      r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), query = query, ...)
    } else {
      # do not add query if not an ingestion file
      r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    }

    httr::stop_for_status(r)
    out <-  httr::content(r, as = "raw")

    return (out)

  }
