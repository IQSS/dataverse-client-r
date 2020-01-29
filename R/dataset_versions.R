#' @title Dataset versions
#' @description View versions of a dataset
#' @details This returns a list of objects of all versions of a dataset, including metadata. This can be used as a first step for retrieving older versions of files or datasets.
#' @template ds
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{dataverse_dataset_version}.
#' @seealso \code{\link{get_dataset}}, \code{\link{dataset_files}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{
#' # download file from:
#' # https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/ARKOTI
#' monogan <- get_dataverse("monogan")
#' monogan_data <- dataverse_contents(monogan)
#' d1 <- get_dataset(monogan_data[[1]])
#' dataset_versions(d1)
#' dataset_files(d1)
#' }
#' @export
dataset_versions <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- dataset_id(dataset, key = key, server = server, ...)
    u <- paste0(api_url(server), "datasets/", dataset, "/versions")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, as = "text", 
        encoding = "UTF-8"), simplifyDataFrame = FALSE)$data
    lapply(out, function(x) {
        x <- `class<-`(x, "dataverse_dataset_version")
        x$files <- lapply(x$files, `class<-`, "dataverse_file")
        x
    })
}
