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
#'   must choose the appropriate funuction: for example if the target is a .rds
#'   file, then `FUN` should be `readRDS` or `readr::read_rds`.
#' @param archival Whether to read from the ingested, archival version of the
#'  dataset, or whether to read the original. The archival versions are tab-delimited
#'  `.tab` files. If functions to read the original version is available without
#'  loss of information, then `archival = FALSE` is better. If such functions
#'  are not available or the original format is unknown, use `archival = TRUE`.
#' @inheritDotParams get_file
#'
#' @examples
#' library(readr)
#'
# load dataset from file name and dataverse DOI
#' gap_df <- get_dataframe_by_name(
#'   file = "gapminder-FiveYearData.tab",
#'   dataset = "doi:10.70122/FK2/PPKHI1",
#'   server = "demo.dataverse.org",
#'   FUN = read_csv)
#'
#' # or a Stata dta
#' stata_df <- get_dataframe_by_name(
#'   file = "nlsw88.tab",
#'   dataset = "doi:10.70122/FK2/PPKHI1",
#'   server = "demo.dataverse.org",
#'   FUN = haven::read_dta)
#'
#' # or a Rds file
#' rds_df <- get_dataframe_by_name(
#'  file = "nlsw88_rds-export.rds",
#'  dataset = "doi:10.70122/FK2/PPKHI1",
#'  server = "demo.dataverse.org",
#'  FUN = read_rds)
#'
#' # equivalently, if you know the DOI
#' gap_df <- get_dataframe_by_doi(
#'  filedoi = "10.70122/FK2/PPKHI1/ZYATZZ",
#'  server = "demo.dataverse.org",
#'  FUN = read_csv
#' )
#'
#' # or the id
#' # you can also customize the FUN (in this case to supress parse msg)
#' gap_df <- get_dataframe_by_id(
#'   1733998,
#'   server = "demo.dataverse.org",
#'   FUN = function(x) read_csv(x, col_types = cols()))
#'
#' # equivalently, using a dataverse object
#' gap_ds <- dataset_files("doi:10.70122/FK2/PPKHI1",
#'                         server = "demo.dataverse.org")
#'
#' gap_df <- get_dataframe_by_id(
#'   gap_ds[[1]],
#'   server = "demo.dataverse.org",
#'   FUN = function(x) read_csv(x, col_types = cols()))
#'
#' # to use the archival version (and read as TSV)
#' gap_df <- get_dataframe_by_id(
#'   1733998,
#'   server = "demo.dataverse.org",
#'   archival = TRUE,
#'   FUN = function(x) read_tsv(x, col_types = cols()))
#'
#'
#' @export
get_dataframe_by_name <- function(file,
                                  dataset = NULL,
                                  FUN = NULL,
                                  archival = FALSE,
                                  ...) {

  # retrieve ID
  fileid <- get_fileid.character(x = dataset,
                                 file = file,
                                 ...)

  get_dataframe_by_id(fileid, FUN, archival = archival, ...)

}


#' @rdname get_dataframe
#' @export
get_dataframe_by_id <- function(fileid,
                                FUN = NULL,
                                archival = FALSE,
                                ...) {

  raw <- get_file(file = fileid, archival = archival, ...)

  # default of get_file
  if (is.null(FUN)) {
    warning("function was not supplied so returning the raw binary file.")
    return(raw)
  }

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
                                 archival = FALSE,
                                 ...) {
  filedoi <- prepend_doi(filedoi)

  # get_file can also take doi now
  get_dataframe_by_id(file = filedoi, FUN = FUN, archival = archival, ...)
}

#' Write to temp and apply function
#'
#' @importFrom stringr str_extract
#'
#' @keywords internal
get_dataframe_internal <- function(raw, filename, .f) {
  tmp <- tempfile(filename)
  writeBin(raw, tmp)

  do.call(.f, list(tmp))
}

