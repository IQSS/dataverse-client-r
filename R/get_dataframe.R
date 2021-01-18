#' Download dataverse file as a dataframe
#'
#' Use `get_dataframe_by_name` if you know the name of the datafile and the DOI
#'  of the dataset. Use `get_dataframe_by_doi` if you know the DOI of the datafile
#'  itself. Use `get_dataframe_by_id` if you know the numeric ID of the
#'  datafile.
#'
#' @rdname get_dataframe
#'
#' @param filename The name of the file of interest, with file extension, for example
#' `"roster-bulls-1996.tab"`.
#' @param .f The function to used for reading in the raw dataset. This user
#' must choose the appropriate function: for example if the target is a .rds
#' file, then `.f` should be `readRDS` or `readr::read_rds`.
#' @param original A logical, defaulting to TRUE. Whether to read the ingested,
#' archival version of the datafile if one exists. The archival versions are tab-delimited
#' `.tab` files so if `original = FALSE`, `.f` is set to `readr::read_tsv`.
#' If functions to read the original version is available, then `original = TRUE`
#' with a specified `.f` is better.
#'
#' @inheritDotParams get_file
#'
#' @examples
#'
#' # Retrieve data.frame from dataverse DOI and file name
#' df_from_rds_ingested <-
#'   get_dataframe_by_name(
#'     filename = "roster-bulls-1996.tab",
#'     dataset  = "doi:10.70122/FK2/HXJVJU",
#'     server   = "demo.dataverse.org"
#'   )
#'
#' # Retrieve the same data.frame from dataverse + file DOI
#' df_from_rds_ingested_by_doi <-
#'   get_dataframe_by_doi(
#'     filedoi      = "10.70122/FK2/HXJVJU/SA3Z2V",
#'     server       = "demo.dataverse.org"
#'   )
#'
#' # Retrieve ingested file originally a Stata dta
#' df_from_stata_ingested <-
#'   get_dataframe_by_name(
#'     filename   = "nlsw88.tab",
#'     dataset    = "doi:10.70122/FK2/PPIAXE",
#'     server     = "demo.dataverse.org"
#'  )
#'
#'
#' # To use the original file version, or for non-ingested data,
#' # please specify `original = TRUE` and specify a function in .f.
#'
#' # A data.frame is still returned, but the
#' if (requireNamespace("readr", quietly = TRUE)) {
#'   df_from_rds_original <-
#'     get_dataframe_by_name(
#'       filename   = "nlsw88_rds-export.rds",
#'       dataset    = "doi:10.70122/FK2/PPIAXE",
#'       server     = "demo.dataverse.org",
#'       original   = TRUE,
#'       .f         = readr::read_rds
#'    )
#' }
#'
#' if (requireNamespace("haven", quietly = TRUE)) {
#'   df_from_stata_original <-
#'     get_dataframe_by_name(
#'       filename   = "nlsw88.tab",
#'       dataset    = "doi:10.70122/FK2/PPIAXE",
#'       server     = "demo.dataverse.org",
#'       original   = TRUE,
#'       .f         = haven::read_dta
#'    )
#' }
#' @export
get_dataframe_by_name <- function (
  filename,
  dataset       = NULL,
  .f            = NULL,
  original      = FALSE,
  ...
) {
  # retrieve ID
  fileid <- get_fileid.character(x = dataset, file = filename, ...)

  get_dataframe_by_id(fileid, .f, original = original, ...)
}

#' @rdname get_dataframe
#' @export
get_dataframe_by_id <- function(
  fileid,
  .f            = NULL,
  original      = FALSE,
  ...
) {

  # if not ingested, then whether to take the original is not relevant.
  ingested <- is_ingested(fileid, ...)

  if (isFALSE(ingested)) {
    original <- NA
  }

  if (is.null(.f) & isTRUE(ingested) & isFALSE(original)) {
    message("Downloading ingested version of data with readr::read_tsv. To download the original version and remove this message, set original = TRUE.\n")
    .f <- readr::read_tsv
  }

  if (is.null(.f) & (isFALSE(ingested) | isTRUE(original))) {
    stop("read-in function was left NULL, but the target file is not ingested or you asked for the original version. Please supply a .f argument.\n")
  }

  # READ raw data
  raw <- get_file(file = fileid, original = original, ...)

  # save to temp and then read it in with supplied function
  if (!is.null(.f)) {
    get_dataframe_internal(raw, filename = "foo", .f = .f)
  }
}

#' @rdname get_dataframe
#' @inheritParams get_file_by_doi
#' @export
get_dataframe_by_doi <- function (
  filedoi,
  .f            = NULL,
  original      = FALSE,
  ...
) {
  filedoi <- prepend_doi(filedoi)

  # get_file can also take doi now
  get_dataframe_by_id(fileid = filedoi, .f = .f, original = original, ...)
}

#' Write to temp and apply function
#'
#' @keywords internal
get_dataframe_internal <- function (raw, filename, .f) {
  tryCatch(
    {
      tmp <- tempfile(filename)
      writeBin(raw, tmp)
      do.call(.f, list(tmp))
    },
    finally = {
      if (file.exists(tmp)) unlink(tmp)
    }
  )
}
