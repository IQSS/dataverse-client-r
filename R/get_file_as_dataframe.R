#' Get file from dataverse and convert it into a dataframe or tibble
#'
#' `get_dataframe_by_id`, if you know the numeric ID of the dataset, or instead
#' `get_dataframe_by_name` if you know the filename and doi. The dataset
#'
#' @rdname get_dataframe
#'
#' @param file to be passed on to get_file
#' @param dataset to be passed on to get_file
#' @param FUN The function to used for reading in the raw dataset. This user
#'   must choose the appropriate function: for example if the target is a .rds
#'   file, then `FUN` should be `readRDS` or `readr::read_rds`.
#' @param original A logical, defaulting to TRUE. Whether to read the ingested,
#' archival version of the dataset if one exists. The archival versions are tab-delimited
#'  `.tab` files so if `original = FALSE`, `FUN` is set to `readr::read_tsv`.
#'  If functions to read the original version is available, then `original = TRUE`
#'  with a specified `FUN` is better.
#' @inheritDotParams get_file
#'
#' @importFrom readr read_tsv
#'
#' @examples
#' library(readr)
#'
#' # load dataset from file name and dataverse DOI
#' csv_tab <- get_dataframe_by_name(
#'   file = "roster-bulls-1996.tab",
#'   dataset = "doi:10.70122/FK2/HXJVJU",
#'   server = "demo.dataverse.org")
#'
#' # or a Stata dta
#' stata_df <- get_dataframe_by_name(
#'   file = "nlsw88.tab",
#'   dataset = "doi:10.70122/FK2/PPIAXE",
#'   server = "demo.dataverse.org")
#'
#' # To use the original version, or for non-ingested data,
#' # please specify `orginal = TRUE` and specify a function in FUN
#'
#' if (requireNamespace("haven", quietly = TRUE)) {
#'   stata_df <- get_dataframe_by_name(
#'     file = "nlsw88.tab",
#'     dataset = "doi:10.70122/FK2/PPIAXE",
#'     server = "demo.dataverse.org",
#'     original = TRUE,
#'     FUN = haven::read_dta)
#' }
#'
#' rds_df <- get_dataframe_by_name(
#'   file = "nlsw88_rds-export.rds",
#'   dataset = "doi:10.70122/FK2/PPIAXE",
#'   server = "demo.dataverse.org",
#'   FUN = readr::read_rds)
#'
#' # equivalently, if you know the DOI
#' stata_df <- get_dataframe_by_doi(
#'   filedoi = "10.70122/FK2/PPIAXE/MHDB0O",
#'   server = "demo.dataverse.org",
#'   original = TRUE,
#'   FUN = haven::read_dta
#' )
#' @export
get_dataframe_by_name <- function(file,
                                  dataset = NULL,
                                  FUN = NULL,
                                  original = FALSE,
                                  ...) {

  # retrieve ID
  fileid <- get_fileid.character(x = dataset,
                                 file = file,
                                 ...)

  get_dataframe_by_id(fileid, FUN, original = original, ...)

}


#' @rdname get_dataframe
#' @importFrom readr read_tsv
#' @export
get_dataframe_by_id <- function(fileid,
                                FUN = NULL,
                                original = FALSE,
                                ...) {

  # if not ingested, then whether to take the original is not relevant.
  ingested <- is_ingested(fileid, ...)

  if (isFALSE(ingested)) {
    original <- NA
  }

  if (is.null(FUN) & isTRUE(ingested) & isFALSE(original)) {
    warning("Downloading ingested version of data with read_tsv. To download the original version and remove this warning, set original = TRUE.\n")
    FUN <- read_tsv
  }

  if (is.null(FUN) & (isFALSE(ingested) | isTRUE(original))) {
    stop("read-in function was left NULL, but the target file is not ingested or you asked for the original version. Please supply a FUN argument.\n")
  }

  # READ raw data
  raw <- get_file(file = fileid, original = original, ...)

  # save to temp and then read it in with supplied function
  if (!is.null(FUN)) {
    get_dataframe_internal(raw, filename = "foo", .f = FUN)
  }
}


#' @rdname get_dataframe
#' @inheritParams get_file_by_doi
#' @export
get_dataframe_by_doi <- function(filedoi,
                                 FUN = NULL,
                                 original = FALSE,
                                 ...) {
  filedoi <- prepend_doi(filedoi)

  # get_file can also take doi now
  get_dataframe_by_id(fileid = filedoi, FUN = FUN, original = original, ...)
}

#' Write to temp and apply function
#'
# @importFrom stringr str_extract
#'
#' @keywords internal
get_dataframe_internal <- function(raw, filename, .f) {
  tmp <- tempfile(filename)
  writeBin(raw, tmp)

  do.call(.f, list(tmp))
}

