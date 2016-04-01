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
#' 
#' d <- create_dataset("mydataverse", body = list())
#' }
#' @export
create_dataset <- function(dataverse, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/datasets/")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = body, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r)
}

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
#' 
#' }
#' @export
update_dataset <- function(dataset, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- dataset_id(dataset)
    u <- paste0(api_url(server), "datasets/", dataset, "/versions/:draft")
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), body = body, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r, as = "text", encoding = "UTF-8")
}

#' @title Publish dataset
#' @description Publish/release Dataverse dataset
#' @template ds
#' @param minor A logical specifying whether the new release of the dataset is a \dQuote{minor} release (\code{TRUE}, by default), resulting in a minor version increase (e.g., from 1.1 to 1.2). If \code{FALSE}, the dataset is given a \dQuote{major} release (e.g., from 1.1 to 2.0).
#' @template envvars
#' @details Use this function to \dQuote{publish} (i.e., publicly release) a draft Dataverse dataset. This creates a publicly visible listing of the dataset, accessible by its DOI, with a numbered version. This action cannot be undone.
#' There are no requirements for what constitutes a major or minor release, but a minor release might be used to update metadata (e.g., a new linked publication) or the addition of supplemental files. A major release is best used to reflect a substantial change to the dataset, such as would require a published erratum or a substantial change to data or code.
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso \code{\link{get_dataset}}, \code{\link{publish_dataverse}}
#' @examples
#' \dontrun{
#' 
#' }
#' @export
publish_dataset <- function(dataset, minor = TRUE, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- dataset_id(dataset)
    u <- paste0(api_url(server), "datasets/", dataset, "/actions/:publish?type=", if (minor) "minor" else "major")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r, as = "text", encoding = "UTF-8")
}

#' @title Delete draft dataset
#' @description Delete a dataset draft
#' @details This function can be used to delete a draft (unpublished) Dataverse dataset. Once published, a dataset cannot be deleted. An existing draft can instead be modified using \code{\link{update_dataset}}.
#' @template ds
#' @template envvars
#' @template dots
#' @return A logical.
#' @seealso \code{\link{get_dataset}}, \code{\link{create_dataset}}, \code{\link{update_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{
#' 
#' }
#' @export
delete_dataset <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    # can only delete a "draft" dataset
    dataset <- dataset_id(dataset)
    u <- paste0(api_url(server), "datasets/", dataset, "/versions/:draft")
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r, as = "text", encoding = "UTF-8")
}

