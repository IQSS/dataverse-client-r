#' @rdname files
#'
#'
#' @title Download File
#'
#' @description Download Dataverse File(s). `get_file` is a general wrapper,
#'  and can take either dataverse objects, file IDs, or a filename and dataverse.
#'  `get_file_by_name` is a shorthand for running `get_file` by
#'  specifying a file name (`filename`) and dataset (`dataset`).
#'  `get_file_by_doi` obtains a file by its file DOI, bypassing the
#'  `dataset` argument.
#'  Internally, all functions download each file by `get_file_by_id`. `get_file_*`
#'  functions return a raw binary file, which cannot be readily analyzed in R.
#'  To use the objects as dataframes, see the `get_dataset_*` functions at \link{get_dataset}
#'
#'
#'
#' @details This function provides access to data files from a Dataverse entry.
#' @param file An integer specifying a file identifier; or a vector of integers
#'  specifying file identifiers; or, if \code{doi} is specified, a character string
#'  specifying a file name within the DOI-identified dataset; or an object of
#'   class \dQuote{dataverse_file} as returned by \code{\link{dataset_files}}.
#' @param format A character string specifying a file format for download.
#'  by default, this is \dQuote{original} (the original file format). If `NULL`,
#'  no query is added, so ingested files are returned in their ingested TSV form.
#'  For tabular datasets, the option \dQuote{bundle} downloads the bundle
#'  of the original and archival versions, as well as the documentation.
#'  See <https://guides.dataverse.org/en/latest/api/dataaccess.html> for details.
#' @param vars A character vector specifying one or more variable names, used to
#'  extract a subset of the data.
#'
#' @template envvars
#' @template dots
#'
#' @return \code{get_file} returns a raw vector (or list of raw vectors,
#'   if \code{length(file) > 1}), which can be saved locally with the `writeBin`
#'   function.  To load datasets into the R environment dataframe, see
#'   \link{get_dataframe_by_name}.
#'
#' @seealso To load the objects as datasets \link{get_dataframe_by_name}.
#'
#' @examples
#' \dontrun{
#'
#' # 1. Using filename and dataverse
#' f1 <- get_file_by_name("gapminder-FiveYearData.tab",
#'                        dataset = "doi:10.70122/FK2/PPKHI1",
#'                        server = "demo.dataverse.org")
#'
#' # 2. Using DOI
#' f2 <- get_file_by_doi("10.70122/FK2/PPKHI1/ZYATZZ",
#'                       server = "demo.dataverse.org")
#'
#' # 3. Two-steps: Find ID from get_dataset
#' d3 <- get_dataset("doi:10.70122/FK2/PPKHI1", server = "demo.dataverse.org")
#' f3 <- get_file(d3$files$id[1], server = "demo.dataverse.org")
#'
#'
#' # 4. Alternatively, based on "dataverse_file" object
#' f4_dvf <- dataset_files("doi:10.70122/FK2/PPKHI1", server = "demo.dataverse.org")
#' f4 <- get_file(f4_dvf[[1]], server = "demo.dataverse.org")
#'
#' # 5. Retrieve multiple raw data in list
#' f5_vec <- get_dataset("doi:10.70122/FK2/PPKHI1",
#'                       server = "demo.dataverse.org")$files$id
#' f5 <- get_file(f5_vec,
#'                server = "demo.dataverse.org")
#' length(f5)
#'
#' # Write binary files.
#' # The appropriate file extension needs to be assigned by the user.
#' writeBin(f1, "gapminder-FiveYearData.tab")
#' writeBin(f5[[1]], "gapminder-FiveYearData.tab")
#'
#' # NOTE: fix so that get_file (with multiple) files
#' # (f5) in example can return a tabulated dataset in original
#'
#' }
#'
#' @export
get_file <-
  function(file,
           dataset = NULL,
           format = c("original", "bundle"),
           server = Sys.getenv("DATAVERSE_SERVER"),
           vars = NULL,
           key = Sys.getenv("DATAVERSE_KEY"),
           archival = NULL,
           ...) {

    format <- match.arg(format)

    # single file ID
    if (is.numeric(file))
      fileid <- file

    # get file ID from 'dataset'. Streamline in feature relying on get_fileid
    if (!is.numeric(file) & inherits(file, "dataverse_file"))
      fileid <- get_fileid.dataverse_file(file, key = key, server = server)

    if (!is.numeric(file) & !inherits(file, "dataverse_file") & is.null(dataset))
      stop("When 'file' is a character (non-global ID), dataset must be specified.")
    if (!is.numeric(file) & !inherits(file, "dataverse_file"))
      fileid <- get_fileid.character(dataset, file, key = key, server = server, ...)


    # Main function. Call get_file_by_id
    out <- vector("list", length(fileid))

    for (i in 1:length(fileid)) {
      out[[i]] <- get_file_by_id(
        fileid = fileid[i],
        dataset = dataset,
        format = format,
        vars = vars,
        key = key,
        server = server,
        archival = archival,
        ...
        )
    }

    # return the raw vector if there's a single file
    if (length(out) == 1) {
      return(out[[1]])
    } else {
      # return a list of raw vectors otherwise
      return(out)
    }
  }


#' @rdname files
#'
#'
#' @param filename Filename of the dataset, with file extension
#'
#' @inheritParams get_file
#'
#' @export
get_file_by_name <- function(filename,
                             dataset,
                             format = c("original", "bundle"),
                             server = Sys.getenv("DATAVERSE_SERVER"),
                             vars = NULL,
                             key = Sys.getenv("DATAVERSE_KEY"),
                             archival = NULL,
                             ...
                             ) {
  format <- match.arg(format)


  # retrieve ID
  fileid <- get_fileid.character(x = dataset,
                                 file = filename,
                                 server = server,
                                 ...)

  get_file_by_id(fileid,
                 format = format,
                 vars = vars,
                 key = key,
                 server = server,
                 archival = archival,
                 ...)

}
