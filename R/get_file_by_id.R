#' @title Download Single File by dataverse ID
#'
#' @rdname files
#'
#' @export
get_file_by_id <-
  function(fileid,
           dataset = NULL,
           format = c("original", "RData", "prep", "bundle"),
           # thumb = TRUE,
           vars = NULL,
           key = Sys.getenv("DATAVERSE_KEY"),
           server = Sys.getenv("DATAVERSE_SERVER"),
           ...) {
    format <- match.arg(format)

    # single file ID
    stopifnot (is.numeric(fileid))
    stopifnot (length(fileid) == 1)


    # downloading files sequentially and add the raw vectors to a list
    out <- vector("list", length(fileid))

    # create query -----
    u <- paste0(api_url(server), "access/datafile/", fileid)
    query <- list()
    if (!is.null(vars)) {
      query$vars <- paste0(vars, collapse = ",")
    }
    if (!is.null(format)) {
      query$format <- match.arg(format)
    }

    # request single file in non-bundle format ----
    # add query if ingesting a tab (detect from original file name)
    # if (length(query) == 1 & grepl("\\.tab$", file[i])) {
    #   r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), query = query, ...)
    # } else {
      # do not add query if not an ingestion file
      r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    # }

    httr::stop_for_status(r)
    out <-  httr::content(r, as = "raw")

    return (out)

  }
