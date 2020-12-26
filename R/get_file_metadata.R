#' Retrieve a ddi metadata file
#'
#'
#' @param format Defaults to \dQuote{ddi} for metadata files
#' @inheritParams get_file
#' @return A character vector containing a DDI
#'  metadata file.
#'
#' @import xml2
#' @export
get_file_metadata <-
  function(file,
           dataset = NULL,
           format = c("ddi", "preprocessed"),
           key = Sys.getenv("DATAVERSE_KEY"),
           server = Sys.getenv("DATAVERSE_SERVER"),
           ...) {
    # get file ID from doi
    if (!is.numeric(file)) {
      if (inherits(file, "dataverse_file")) {
        file <- get_fileid(file)
      } else if (is.null(dataset)) {
        stop("When 'file' is a character string, dataset must be specified. Or, use a global fileid instead.")
      } else {
        file <- get_fileid(dataset, file, key = key, server = server, ...)
      }
    }
    format <- match.arg(format)
    u <- paste0(api_url(server), "access/datafile/", file, "/metadata/", format)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- httr::content(r, as = "text", encoding = "UTF-8")
    return(out)
  }



get_file_name_from_header <- function(x) {
  gsub("\"", "", strsplit(httr::headers(x)[["content-type"]], "name=")[[1]][2])
}
