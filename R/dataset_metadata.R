#' @title Metadata block
#' @description Get a named metadata block for a dataset
#' @details This function returns a named metadata block for a dataset. This is already returned by \code{\link{get_dataset}}, but this function allows you to retrieve just a specific block of metadata, such as citation information.
#' @template ds
#' @template version 
#' @param block A character string specifying a metadata block to retrieve. By default this is \dQuote{citation}. Other values may be available, depending on the dataset, such as \dQuote{geospatial} or \dQuote{socialscience}.
#' @template envvars
#' @template dots
#' @return A list of form dependent on the specific metadata block retrieved.
#' @seealso \code{\link{get_dataset}}
#' @examples
#' \dontrun{
#' monogan <- get_dataverse("monogan")
#' monogan_data <- dataverse_contents(monogan)
#' d1 <- get_dataset(monogan_data[[1]])
#' dataset_versions(d1)
#' dataset_files(d1)
#'
#' # get metadata
#' str(dataset_metadata(d1), 4)
#' }
#' @importFrom utils str
#' @export
dataset_metadata <- function(dataset, version = ":latest", block = "citation", key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- dataset_id(dataset)
    if (!is.null(block)) {
        u <- paste0(api_url(server), "datasets/", dataset, "/versions/", version, "/metadata/", block)
    } else {
        u <- paste0(api_url(server), "datasets/", dataset, "/versions/", version, "/metadata")
    }
    
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- httr::content(r, as = "text", encoding = "UTF-8")
    jsonlite::fromJSON(out)[["data"]]
}
