#' Get file from dataverse and convert it into a dataframe or tibble
#'
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
#' gap_df <- get_dataframe_by_name(
#'   file = "gapminder-FiveYearData.tab",
#'   dataset = "doi:10.7910/DVN/GJQNEQ",
#'   server = "dataverse.harvard.edu",
#'   read_function = readr::read_tsv)
#'
#' @export
get_dataframe_by_name <- function(file,
                                  dataset = NULL,
                                  read_function = NULL,
                                  ...) {

  raw_file <- get_file(file = file, dataset = dataset, ...)

  # default of get_file
  if (is.null(read_function))
    return(raw_file)

  # save to temp and then read it in with supplied function
  if (!is.null(read_function)) {
    tmp <- tempfile(file, fileext = stringr::str_extract(file, "\\.[A-z]+$"))
    writeBin(raw_file, tmp)
    return(do.call(read_function, list(tmp)))
  }
}
