#' @title Get Dataverse facets
#' @description Dataverse metadata facets
#' @details Retrieve a list of Dataverse metadata facets.
#' @template dv
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso To manage Dataverses: \code{\link{create_dataverse}},  \code{\link{delete_dataverse}}, \code{\link{publish_dataverse}}, \code{\link{dataverse_contents}}; to get datasets: \code{\link{get_dataset}}; to search for Dataverses, datasets, or files: \code{\link{dataverse_search}}
#' @examples
#' \dontrun{
#' # download file from:
#' # https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/ARKOTI
#' monogan <- get_dataverse("monogan")
#' (monogan_data <- dataverse_contents(monogan))
#'
#' # get facets
#' get_facets(monogan)
#' }
#' @export
get_facets <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse, key = key, server = server, ...)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/facets")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
}
