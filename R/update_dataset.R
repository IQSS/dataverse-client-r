#' @title Update dataset
#' @description Update a Dataverse dataset
#' @details This function updates a Dataverse dataset that has already been created using \code{\link{create_dataset}}. This creates a draft version of the dataset or modifies the current draft if one is already in-progress. It does not assign a new version number to the dataset nor does it make it publicly visible (which can be done with \code{\link{publish_dataset}}).
#' @template ds
#' @param body A list describing the dataset.
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso \code{\link{get_dataset}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{
#' meta1 <- list()
#' ds <- create_dataset("mydataverse", body = meta1)
#' 
#' meta2 <- list()
#' update_dataset(ds, body = meta2)
#'
#' # cleanup
#' delete_dataset(ds)
#' }
#' @export
update_dataset <- function(dataset, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- dataset_id(dataset)
    u <- paste0(api_url(server), "datasets/", dataset, "/versions/:draft")
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), body = body, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r, as = "text", encoding = "UTF-8")
}
