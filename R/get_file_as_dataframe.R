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
#' @inheritDotParams get_file
#'
#' @examples
#' # load dataset from file name and dataverse DOI
#' gap_df <- get_dataframe_by_name(
#'   file = "gapminder-FiveYearData.tab",
#'   dataset = "doi:10.7910/DVN/GJQNEQ",
#'   server = "dataverse.harvard.edu",
#'   read_function = readr::read_csv)
#'
#' # equivalently, if you know the ID
#' gap_df <- get_dataframe_by_id(
#'   3037713,
#'   server = "dataverse.harvard.edu",
#'   read_function = readr::read_csv)
#'
#' # equivalently, using a dataverse object
#' gap_ds <- dataset_files("doi:10.7910/DVN/GJQNEQ",
#'                         server = "dataverse.harvard.edu")
#' gap_df <- get_dataframe_by_id(
#'   gap_ds[[2]],
#'   server = "dataverse.harvard.edu",
#'   read_function = readr::read_csv
#' )
#'
#' # to use the ingested version (and read as TSV)
#' gap_df <- get_dataframe_by_id(
#'    3037713,
#'    server = "dataverse.harvard.edu",
#'    use_ingested = TRUE,
#'    read_function = readr::read_tsv)
#'
#' @export
get_dataframe_by_name <- function(file,
                                  dataset = NULL,
                                  read_function = NULL,
                                  ...) {

  # retrieve ID
  fileid <- get_fileid.character(x = dataset,
                                 file = file,
                                 ...)

  get_dataframe_by_id(fileid, read_function, ...)

}


#' @rdname get_dataframe
#' @export
get_dataframe_by_id <- function(file,
                                read_function = NULL,
                                ...) {

  raw <- get_file(file = file, ...)

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
