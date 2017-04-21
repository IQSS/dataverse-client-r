#' @title Create dataset
#' @description Create dataset within a Dataverse
#' @details This function creates a Dataverse dataset. In Dataverse, a \dQuote{dataset} is the lowest-level structure in which to organize files. For example, a Dataverse dataset might contain the files used to reproduce a published article, including data, analysis code, and related materials. Datasets can be organized into \dQuote{Dataverse} objects, which can be further nested within other Dataverses. For someone creating an archive, this would be the first step to producing said archive (after creating a Dataverse, if one does not already exist). Once files and metadata have been added, the dataset can be publised (i.e., made public) using \code{\link{publish_dataset}}.
#' @template dv
#' @param body A list describing the dataset.
#' @template envvars
#' @template dots
#' @return An object of class \dQuote{dataverse_dataset}.
#' @seealso \code{\link{get_dataset}}, \code{\link{update_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{
#' meta <- list()
#' ds <- create_dataset("mydataverse", body = meta)
#'
#' # cleanup
#' delete_dataset(ds)
#' }
#' @export
create_dataset <- function(dataverse, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/datasets/")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = body, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r)
}
