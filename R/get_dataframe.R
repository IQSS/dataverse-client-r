#' Download dataverse file as a dataframe
#'
#'
#' @description Reads in the Dataverse file into the R environment with any
#'  user-specified function, such as `read.csv` or `readr` functions.
#'
#'  Use `get_dataframe_by_name` if you know the name of the datafile and the DOI
#'  of the dataset. Use `get_dataframe_by_doi` if you know the DOI of the datafile
#'  itself. Use `get_dataframe_by_id` if you know the numeric ID of the
#'  datafile. For files that are not datasets, the more generic `get_file` that
#'  downloads the content as a binary is simpler.
#'
#'  The function can read datasets that are unpublished and are still drafts,
#'  as long as the entry has a UNF. See the download vignette for details.
#'
#' @rdname get_dataframe
#'
#' @param filename The name of the file of interest, with file extension, for example
#' `"roster-bulls-1996.tab"`. Can be a vector for multiple files.
#' @param .f The function to used for reading in the raw dataset. The user
#'  must choose the appropriate function: for example if the target is a .rds
#'  file, then `.f` should be `readRDS` or `readr::read_rds`. It can be a custom
#'  function defined by the user. See examples for details.
#'
#' @param original A logical, whether to read the ingested,
#' archival version of the datafile if one exists. If `TRUE`, users should supply
#' a function to use to read in the original. The archival versions are tab-delimited
#' `.tab` files so if `original = FALSE`, `.f` is set to `readr::read_tsv`.
#'
#' @inheritDotParams get_file
#' @template version
#'
#' @return A R object that is returned by the default or user-supplied function
#'  `.f` argument. For example, if `.f = readr::read_tsv()`, the function will
#'  return a dataframe as read in by `readr::read_tsv()`. If the file identifier
#'  is a vector, it will return a list where each slot corresponds to elements of the vector.
#'
#'
#' @examples
#' \dontrun{
#' # 1. For files originally in plain-text (.csv, .tsv), we recommend
#' # retreiving data.frame from dataverse DOI and file name, or the file's DOI.
#'
#' df_tab <-
#'   get_dataframe_by_name(
#'     filename = "roster-bulls-1996.tab",
#'     dataset  = "doi:10.70122/FK2/HXJVJU",
#'     server   = "demo.dataverse.org"
#'   )
#'
#' df_tab <-
#'   get_dataframe_by_doi(
#'     filedoi      = "10.70122/FK2/HXJVJU/SA3Z2V",
#'     server       = "demo.dataverse.org"
#'   )
#'
#' # 2. For files where Dataverse's ingest loses information (Stata .dta, SPSS .sav)
#' # or cannot be ingested (R .rds), we recommend
#' # specifying `original = TRUE` and specifying a read-in function in .f.
#'
#' # Rds files are not ingested so original = TRUE and .f is required.
#' if (requireNamespace("readr", quietly = TRUE)) {
#'   df_from_rds_original <-
#'     get_dataframe_by_name(
#'       filename   = "nlsw88_rds-export.rds",
#'       dataset    = "doi:10.70122/FK2/PPIAXE",
#'       server     = "demo.dataverse.org",
#'       original   = TRUE,
#'       .f         = readr::read_rds
#'     )
#' }
#'
#' # Stata dta files lose attributes such as value labels upon ingest so
#' # reading the original version by a Stata reader such as `haven` is recommended.
#' if (requireNamespace("haven", quietly = TRUE)) {
#'   df_stata_original <-
#'     get_dataframe_by_name(
#'       filename   = "nlsw88.tab",
#'       dataset    = "doi:10.70122/FK2/PPIAXE",
#'       server     = "demo.dataverse.org",
#'       original   = TRUE,
#'       .f         = haven::read_dta
#'     )
#' }
#'
#' # 3. RData files are read in by `base::load()` but cannot be assigned to an
#' # object name. The following shows two possible ways to read in such files.
#' # First, the RData object can be loaded to the environment without object assignment.
#'
#' get_dataframe_by_doi(
#'   filedoi = "10.70122/FK2/PPIAXE/X2FC5V",
#'   server = "demo.dataverse.org",
#'   original = TRUE,
#'   .f = function(x) load(x, envir = .GlobalEnv))
#'
#' # If you are certain each RData contains only one object, one could define a
#' # custom function used in https://stackoverflow.com/a/34926943
#' load_object <- function(file) {
#'   tmp <- new.env()
#'   load(file = file, envir = tmp)
#'   tmp[[ls(tmp)[1]]]
#' }
#'
#' # https://demo.dataverse.org/file.xhtml?persistentId=doi:10.70122/FK2/PPIAXE/X2FC5V
#' as_rda <- get_dataframe_by_id(
#'   file = 1939003,
#'   server = "demo.dataverse.org",
#'   .f = load_object,
#'   original = TRUE)
#' }
#'
#' @export
get_dataframe_by_name <- function(
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
  raw <- get_file(file = fileid, original = original, return_url = FALSE, ...)

  # save to temp and then read it in with supplied function
  if (!is.null(.f)) {
    get_dataframe_internal(raw, filename = "foo", .f = .f)
  }
}

#' @rdname get_dataframe
#' @inheritParams get_file_by_doi
#' @export
get_dataframe_by_doi <- function(
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
get_dataframe_internal <- function(raw, filename, .f) {
  tryCatch({
      tmp <- tempfile(filename)
      writeBin(raw, tmp)
      do.call(.f, list(tmp))
    },
    finally = {
      if (file.exists(tmp)) unlink(tmp)
    }
  )
}
