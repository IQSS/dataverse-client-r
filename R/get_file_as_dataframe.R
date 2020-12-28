#' Get file from dataverse and convert it into a dataframe or tibble
#'
#' `get_dataframe_by_id`, if you know the numeric ID of the dataset, or instead
#' `get_dataframe_by_name` if you know the filename and doi. The dataset
#'
#' @rdname get_dataframe
#'
#' @param file to be passed on to get_file
#' @param dataset to be passed on to get_file
#' @param read_function If supplied a function object, this will write the
#'   raw file to a tempfile and read it back in with the supplied function. This
#'   is useful when you want to start working with the data right away in the R
#'   environment
#' @param archival Whether to read from the ingested, archival version of the
#'  dataset, or whether to read the original. The archival versions are tab-delimited
#'  `.tab` files. If functions to read the original version is available without
#'  loss of information, then `archival = FALSE` is better. If such functions
#'  are not available or the original format is unknown, use `archival = TRUE`.
#' @inheritDotParams get_file
#'
#' @examples
# load dataset from file name and dataverse DOI
#' gap_df <- get_dataframe_by_name(
#'   file = "gapminder-FiveYearData.tab",
#'   dataset = "doi:10.70122/FK2/PPKHI1",
#'   server = "demo.dataverse.org",
#'   read_function = read_csv)
#'
#' # or a Stata dta
#' stata_df <- get_dataframe_by_name(
#'   file = "nlsw88.tab",
#'   dataset = "doi:10.70122/FK2/PPKHI1",
#'   server = "demo.dataverse.org",
#'   read_function = haven::read_dta)
#'
#' # or a Rds file
#' rds_df <- get_dataframe_by_name(
#'  file = "nlsw88_rds-export.rds",
#'  dataset = "doi:10.70122/FK2/PPKHI1",
#'  server = "demo.dataverse.org",
#'  read_function = read_rds)
#'
#' # equivalently, if you know the ID
#' # you can also customize the read_function (in this case to supress parse msg)
#' gap_df <- get_dataframe_by_id(
#'   1733998,
#'   server = "demo.dataverse.org",
#'   read_function = function(x) read_csv(x, col_types = cols()))
#'
#' # equivalently, using a dataverse object
#' gap_ds <- dataset_files("doi:10.70122/FK2/PPKHI1",
#'                         server = "demo.dataverse.org")
#'
#' gap_df <- get_dataframe_by_id(
#'   gap_ds[[1]],
#'   server = "demo.dataverse.org",
#'   read_function = function(x) read_csv(x, col_types = cols()))
#'
#' # to use the archival version (and read as TSV)
#' gap_df <- get_dataframe_by_id(
#'   1733998,
#'   server = "demo.dataverse.org",
#'   archival = TRUE,
#'   read_function = function(x) read_tsv(x, col_types = cols()))
#'
#'
#' @export
get_dataframe_by_name <- function(file,
                                  dataset = NULL,
                                  read_function = NULL,
                                  archival = FALSE,
                                  ...) {

  # retrieve ID
  fileid <- get_fileid.character(x = dataset,
                                 file = file,
                                 ...)

  get_dataframe_by_id(fileid, read_function, archival = archival, ...)

}


#' @rdname get_dataframe
#' @export
get_dataframe_by_id <- function(file,
                                read_function = NULL,
                                archival = FALSE,
                                ...) {

  raw <- get_file(file = file, archival = archival, ...)

  # default of get_file
  if (is.null(read_function))
    return(raw)

  # save to temp and then read it in with supplied function
  if (!is.null(read_function)) {
    get_dataframe_internal(raw, filename = "foo", .f = read_function)
  }
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
