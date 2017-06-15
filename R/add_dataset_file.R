#' @rdname add_dataset_file
#' @title Add or update a file in a dataset
#' @description Add or update a file in a dataset
#' @details From Dataverse v4.6.1, the \dQuote{native} API provides endpoints to add and update files without going through the SWORD workflow. To use SWORD instead, see \code{\link{add_file}}. \code{add_dataset_file} adds a new file to a specified dataset.
#' 
#' \code{update_dataset_file} can be used to replace/update a published file. Note that it only works on published files, so unpublished drafts cannot be updated - the dataset must first either be published (\code{\link{publish_dataset}}) or deleted (\code{\link{delete_dataset}}).
#' 
#' @param file A character string
#' @template ds
#' @param id An integer specifying a file identifier; or, if \code{doi} is specified, a character string specifying a file name within the DOI-identified dataset; or an object of class \dQuote{dataverse_file} as returned by \code{\link{dataset_files}}.
#' @param description Optionally, a character string providing a description of the file.
#' @param force A logical indicating whether to force the update even if the file types differ. Default is \code{TRUE}.
#' @template envvars
#' @template dots
#' @return \code{add_dataset_file} returns the new file ID.
#' @seealso \code{\link{get_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{
#' meta <- list()
#' ds <- create_dataset("mydataverse", body = meta)
#'
#' saveRDS(mtcars, tmp <- tempfile(fileext = ".rds"))
#' f <- add_dataset_file(tmp, dataset = ds, description = "mtcars")
#' 
#' # publish dataset
#' publish_dataset(ds)
#'
#' # update file and republish
#' saveRDS(iris, tmp)
#' update_dataset_file(tmp, dataset = ds, id = f, 
#'                     description = "Actually iris")
#' publish_dataset(ds)
#' 
#' # cleanup
#' unlink(tmp)
#' delete_dataset(ds)
#' }
#' @export
add_dataset_file <- 
function(file, 
         dataset, 
         description = NULL, 
         key = Sys.getenv("DATAVERSE_KEY"), 
         server = Sys.getenv("DATAVERSE_SERVER"), 
         ...) {
    dataset <- dataset_id(dataset)
    
    bod2 <- list()
    if (!is.null(description)) {
        bod2$description <- description
    }
    jsondata <- as.character(jsonlite::toJSON(bod2, auto_unbox = TRUE))
    
    u <- paste0(api_url(server), "datasets/", dataset, "/add")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ..., 
                    body = list(file = httr::upload_file(file),
                                jsonData = jsondata), 
                    encode = "multipart")
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text", encoding = "UTF-8"))
    out$data$files$dataFile$id[1L]
}

#' @rdname add_dataset_file
#' @export
update_dataset_file <- 
function(file, 
         dataset = NULL, 
         id, 
         description = NULL, 
         force = TRUE, 
         key = Sys.getenv("DATAVERSE_KEY"), 
         server = Sys.getenv("DATAVERSE_SERVER"), 
         ...) {
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
    
    bod2 <- list(forceReplace = force)
    if (!is.null(description)) {
        bod2$description <- description
    }
    jsondata <- as.character(jsonlite::toJSON(bod2, auto_unbox = TRUE))
    
    u <- paste0(api_url(server), "files/", id, "/replace")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ..., 
                    body = list(file = httr::upload_file(file),
                                jsonData = jsondata
                                ), 
                    encode = "multipart")
    httr::stop_for_status(r)
    structure(jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"), simplifyDataFrame = FALSE)$data$files[[1L]], class = "dataverse_file")
}
