#' @title Get dataset
#' @description Retrieve Dataverse dataset
#' @details This function retrieves details about a Dataverse dataset.
#' @template ds
#' @template version 
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{dataverse_dataset}.
#' @seealso \code{\link{create_dataset}}, \code{\link{update_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}, \code{\link{dataset_files}}, \code{\link{dataset_metadata}}
#' @examples
#' \dontrun{
#' # download file from: 
#' # https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/ARKOTI
#' monogan <- get_dataverse("monogan")
#' monogan_data <- dataverse_contents(monogan)
#' d1 <- get_dataset(monogan_data[[1]])
#' f <- get_file(d1$files$datafile$id[3])
#' }
#' @export
get_dataset <- function(dataset, version = ":latest", key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- dataset_id(dataset)
    if (!is.null(version)) {
        u <- paste0(api_url(server), "datasets/", dataset, "/versions/", version)
    } else {
        u <- paste0(api_url(server), "datasets/", dataset)
    }
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
    if ("latestVersion" %in% names(out)) {
        class(out$latestVersion) <- "dataverse_dataset_version"
    }
    if ("metadataBlocks" %in% names(out) && "citation" %in% out$metadata) {
        class(out$metadata$citation) <- "dataverse_dataset_citation"
    }
    # cleanup response
    f <- out$files$dataFile
    out$files$dataFile <- NULL
    out$files <- cbind(out$files, f)
    structure(out, class = "dataverse_dataset")
}
