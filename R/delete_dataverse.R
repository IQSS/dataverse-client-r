#' @title Delete Dataverse
#' @description Delete a dataverse
#' @details This function deletes a Dataverse.
#' @template dv
#' @template envvars
#' @template dots
#' @return A logical.
#' @examples
#' \dontrun{
#' dv <- create_dataverse("mydataverse")
#' delete_dataverse(dv)
#' }
#' @seealso To manage Dataverses: \code{\link{create_dataverse}}, \code{\link{publish_dataverse}}, \code{\link{dataverse_contents}}; to get datasets: \code{\link{get_dataset}}; to search for Dataverses, datasets, or files: \code{\link{dataverse_search}}
#' @export
delete_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse, key = key, server = server, ...)
    u <- paste0(api_url(server), "dataverses/", dataverse)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    httr::content(r, as = "text", encoding = "UTF-8")
}
