#' @rdname create_dataset
#' @title Create or update a dataset
#' @description Create or update dataset within a Dataverse
#' @details \code{create_dataset} creates a Dataverse dataset. In Dataverse, a \dQuote{dataset} is the lowest-level structure in which to organize files. For example, a Dataverse dataset might contain the files used to reproduce a published article, including data, analysis code, and related materials. Datasets can be organized into \dQuote{Dataverse} objects, which can be further nested within other Dataverses. For someone creating an archive, this would be the first step to producing said archive (after creating a Dataverse, if one does not already exist). Once files and metadata have been added, the dataset can be publised (i.e., made public) using \code{\link{publish_dataset}}.
#'
#' \code{update_dataset} updates a Dataverse dataset that has already been created using \code{\link{create_dataset}}. This creates a draft version of the dataset or modifies the current draft if one is already in-progress. It does not assign a new version number to the dataset nor does it make it publicly visible (which can be done with \code{\link{publish_dataset}}).
#'
#' @template dv
#' @template ds
#' @param body A list describing the dataset.
#' @template envvars
#' @template dots
#' @return An object of class \dQuote{dataverse_dataset}.
#' @seealso \code{\link{get_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{
#' meta <- list()
#' ds <- create_dataset("mydataverse", body = meta)
#'
#' meta2 <- list()
#' update_dataset(ds, body = meta2)
#'
#' # cleanup
#' delete_dataset(ds)
#' }
#' @export
create_dataset <- function(dataverse, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse, key = key, server = server, ...)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/datasets/")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = body, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @rdname create_dataset
#' @export
update_dataset <- function(dataset, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- dataset_id(dataset, key = key, server = server, ...)
    u <- paste0(api_url(server), "datasets/", dataset, "/versions/:draft")
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), body = body, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r, as = "text", encoding = "UTF-8")
}
