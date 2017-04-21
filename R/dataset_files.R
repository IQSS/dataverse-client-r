#' @title Dataset files
#' @description List files in a dataset
#' @details This function returns a list of files in a dataset, similar to \code{\link{get_dataset}}. The difference is that this returns only a list of \dQuote{dataverse_dataset} objects, whereas \code{\link{get_dataset}} returns metadata and a data.frame of files (rather than a list of file objects).
#' @template ds
#' @template version 
#' @template envvars
#' @template dots
#' @return A list of objects of class \dQuote{dataverse_file}.
#' @seealso \code{\link{get_dataset}}
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
dataset_files <- function(dataset, version = ":latest", key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- dataset_id(dataset)
    u <- paste0(api_url(server), "datasets/", dataset, "/versions/", version, "/files")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"), simplifyDataFrame = FALSE)$data
    structure(lapply(out, `class<-`, "dataverse_file"))
}
