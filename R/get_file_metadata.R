#' Retrieve a ddi metadata file
#'
#'
#' @param format Defaults to \dQuote{ddi} for metadata files
#' @inheritParams get_file
#' @return A character vector containing a DDI
#'  metadata file.
#'
#' @examples
#'
#' \dontrun{
#'  ddi_raw <- get_file_metadata(file = "nlsw88.tab",
#'                               dataset = "10.70122/FK2/PPIAXE",
#'                               server = "demo.dataverse.org")
#'  xml2::read_xml(ddi_raw)
#' }
#'
#' @export
get_file_metadata <-
  function(file,
           dataset = NULL,
           format = c("ddi", "preprocessed"),
           key = Sys.getenv("DATAVERSE_KEY"),
           server = Sys.getenv("DATAVERSE_SERVER"),
           ...) {

    # get file ID from doi
    persistentID <- FALSE
    if (!is.numeric(file)) {
      if (inherits(file, "dataverse_file")) {
        file <- get_fileid(file)
      } else if (grepl(x = file, pattern = "^doi:")) {
        # if file-specific DOI, then use DOI
        persistentID <- TRUE
      } else if (is.null(dataset)) {
        stop("When 'file' is a character string, dataset must be specified. Or, use a global fileid instead.")
      } else {
        file <- get_fileid(dataset, file, key = key, server = server, ...)
      }
    }

    format <- match.arg(format)

    # different URL depending on if you have persistentId
    if (persistentID) {
      u <- paste0(api_url(server), "access/datafile/:persistentId/metadata/", format, "/?persistentId=", file)
    } else {
      u <- paste0(api_url(server), "access/datafile/", file, "/metadata/", format)
    }

    api_get(u, ..., key = key)
  }
