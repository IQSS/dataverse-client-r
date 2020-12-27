#' @rdname files
#'
#'
#' @title Download File(s)
#' @description Download Dataverse File(s). `get_file` internally calls
#'  `get_file_by_id`.
#'
#' @details This function provides access to data files from a Dataverse entry.
#' @param file An integer specifying a file identifier; or a vector of integers
#'  specifying file identifiers; or, if \code{doi} is specified, a character string
#'  specifying a file name within the DOI-identified dataset; or an object of
#'   class \dQuote{dataverse_file} as returned by \code{\link{dataset_files}}.
#' @param fileid A numeric ID internally used for `get_file_by_id`
#' @param format A character string specifying a file format for download.
#'  by default, this is \dQuote{original} (the original file format). If `NULL`,
#'  no query is added, so ingested files are returned in their ingested TSV form.
#'  For other formats, see <https://guides.dataverse.org/en/latest/api/dataaccess.html>.
#' @param vars A character vector specifying one or more variable names, used to
#' extract a subset of the data.
#'
#' @template envvars
#' @template dots
#'
#' @return \code{get_file} returns a raw vector (or list of raw vectors,
#'   if \code{length(file) > 1}). To load as a dataframe, see
#'   \link{get_dataframe_by_name}.
#'
#' @seealso To load the objects as datasets \link{get_dataframe_by_name}.
#'
#' @examples
#' \dontrun{
#' # download file from:
#' # https://doi.org/10.7910/DVN/ARKOTI
#'
#' # 1. Two-steps: Find ID from get_dataset
#' d1 <- get_dataset("doi:10.7910/DVN/ARKOTI", server = "dataverse.harvard.edu")
#' f1 <- get_file(d1$files$id[1], server = "dataverse.harvard.edu")
#'
#' # 2. Using filename and dataverse
#' f2 <- get_file("constructionData.tab",
#'                "doi:10.7910/DVN/ARKOTI",
#'                server = "dataverse.harvard.edu")
#'
#' # 3. Based on "dataverse_file" object
#' flist <- dataset_files(2692151, server = "dataverse.harvard.edu")
#' f3 <- get_file(flist[[2]], server = "dataverse.harvard.edu")
#'
#' # 4. Retrieve bundle of raw data in list
#' file_ids <- get_dataset("doi:10.7910/DVN/CXOB4K",
#'                         server = "dataverse.harvard.edu")$files$id
#' f4 <- get_file(file_ids,
#'                server = "dataverse.harvard.edu")
#' length(f4)
#'
#' }
#'
#' @export
get_file <-
  function(file,
           dataset = NULL,
           format = c("original", "RData", "prep", "bundle"),
           vars = NULL,
           key = Sys.getenv("DATAVERSE_KEY"),
           server = Sys.getenv("DATAVERSE_SERVER"),
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
        ...
        )
    }

    # return the raw vector if there's a single file
    if (length(out) == 1) {
      return (out[[1]])
    }
    else {
      # return a list of raw vectors otherwise
      return (out)
    }
  }




