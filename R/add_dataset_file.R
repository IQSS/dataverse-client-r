#' @rdname add_dataset_file
#' @title Add or update a file in a dataset
#' @description Add or update a file in a dataset
#' @details From Dataverse v4.6.1, the \dQuote{native} API provides endpoints to add and update files without going through the SWORD workflow. To use SWORD instead, see \code{\link{add_file}}.
#' 
#' @param file A character string
#' @template ds
#' @param id An integer specifying a file identifier; or, if \code{doi} is specified, a character string specifying a file name within the DOI-identified dataset; or an object of class \dQuote{dataverse_file} as returned by \code{\link{dataset_files}}.
#' @template envvars
#' @template dots
#' @return An object of class \dQuote{dataverse_dataset}.
#' @seealso \code{\link{get_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{
#' meta <- list()
#' ds <- create_dataset("mydataverse", body = meta)
#'
#' saveRDS(mtcars, tmp <- tempfile(fileext = ".rds"))
#' add_dataset_file(ds, )
#'
#' # cleanup
#' delete_dataset(ds)
#' }
#' @export
add_dataset_file <- function(file, dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- dataset_id(dataset)
    u <- paste0(api_url(server), "datasets/", dataset, "/add")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ..., 
                    body = list(file = httr::upload_file(file)), encode = "multipart")
    httr::stop_for_status(r)
    TRUE
}

#' @rdname create_dataset
#' @export
update_dataset_file <- function(file, dataset = NULL, id, body = NULL, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- dataset_id(dataset)
    
    # get file ID from 'dataset'
    if (!is.numeric(id)) {
        if (inherits(id, "dataverse_file")) {
            id <- get_fileid(id, key = key, server = server)
        } else if (is.null(dataset)) {
            stop("When 'id' is a character string, dataset must be specified. Or, use a global fileid instead.")
        } else {
            id <- get_fileid(dataset, id, key = key, server = server, ...)
        }
    }
    
    u <- paste0(api_url(server), "api/files/", id, "/replace/")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ..., 
                    body = list(file = httr::upload_file(file),
                                jsonData = jsonlite::toJSON(list(forceReplace = TRUE))), 
                    encode = "multipart")
    httr::stop_for_status(r)
    httr::content(r, as = "text", encoding = "UTF-8")
}
