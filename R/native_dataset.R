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
    structure(out, class = "dataverse_dataset")
}

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
    dataset <- dataset_id(dataset)
    u <- paste0(api_url(server), "datasets/", dataset, "/versions")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- httr::content(r, as = "text", encoding = "UTF-8")$data
    lapply(out, function(x) {
        x <- `class<-`(x, "dataverse_dataset_version")
        x$files <- lapply(x$files, `class<-`, "dataverse_file")
        x
    })
}

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
