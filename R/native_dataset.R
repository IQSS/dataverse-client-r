#' @title Create dataset
#' @description Create dataset within a Dataverse
#' @details This function creates a Dataverse dataset. In Dataverse, a \dQuote{dataset} is the lowest-level structure in which to organize files. For example, a Dataverse dataset might contain the files used to reproduce a published article, including data, analysis code, and related materials. Datasets can be organized into \dQuote{Dataverse} objects, which can be further nested within other Dataverses. For someone creating an archive, this would be the first step to producing said archive (after creating a Dataverse, if one does not already exist). Once files and metadata have been added, the dataset can be publised (i.e., made public) using \code{\link{publish_dataset}}.
#' @template dv
#' @param body A list describing the dataset.
#' @template envars
#' @return An object of class \dQuote{dataverse_dataset}.
#' @seealso \code{\link{get_dataset}}, \code{\link{update_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{}
#' @export
create_dataset <- function(dataverse, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/datasets/")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = body, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title Update dataset
#' @description Update a Dataverse dataset
#' @details This function updates a Dataverse dataset that has already been created using \code{\link{create_dataset}}. This creates a draft version of the dataset or modifies the current draft if one is already in-progress. It does not assign a new version number to the dataset nor does it make it publicly visible (which can be done with \code{\link{publish_dataset}}).
#' @template ds
#' @param body A list describing the dataset.
#' @template envars
#' @return A list.
#' @seealso \code{\link{get_dataset}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{}
#' @export
update_dataset <- function(dataset, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/:draft")
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), body = body, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title Publish dataset
#' @description Publish/release Dataverse dataset
#' @details Use this function to \dQuote{publish} (i.e., publicly release) a draft Dataverse dataset. This creates a publicly visible listing of the dataset, accessible by its DOI, with a numbered version. This action cannot be undone.
#' @template ds
#' @param minor A logical specifying whether the new release of the dataset is a \dQuote{minor} release (\code{TRUE}, by default), resulting in a minor version increase (e.g., from 1.1 to 1.2). If \code{FALSE}, the dataset is given a \dQuote{major} release (e.g., from 1.1 to 2.0).
#'
#' There are no requirements for what constitutes a major or minor release, but a minor release might be used to update metadata (e.g., a new linked publication) or the addition of supplemental files. A major release is best used to reflect a substantial change to the dataset, such as would require a published erratum or a substantial change to data or code.
#' @template envars
#' @return A list.
#' @seealso \code{\link{get_dataset}}, \code{\link{publish_dataverse}}
#' @examples
#' \dontrun{}
#' @export
publish_dataset <- function(dataset, minor = TRUE, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    u <- paste0("https://", server,"/api/datasets/", dataset, "/actions/:publish?type=", if (minor) "minor" else "major")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title Get dataset
#' @description Retrieve Dataverse dataset
#' @details This function retrieves details about a Dataverse dataset.
#' @template ds
#' @template version 
#' @template envars
#' @return A list of class \dQuote{dataverse_dataset}.
#' @seealso \code{\link{create_dataset}}, \code{\link{update_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}, \code{\link{dataset_files}}, \code{\link{dataset_metadata}}
#' @examples
#' \dontrun{}
#' @export
get_dataset <- function(dataset, version = ":latest", key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    if (!is.null(version)) {
        u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version)
    } else {
        u <- paste0("https://", server,"/api/datasets/", dataset)
    }
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"))$data
    if ("latestVersion" %in% names(out)) {
        class(out$latestVersion) <- "dataverse_dataset_version"
    }
    if ("metadataBlocks" %in% names(out) && "citation" %in% out$metadata) {
        class(out$metadata$citation) <- "dataverse_dataset_citation"
    }
    structure(out, class = "dataverse_dataset")
}

#' @title Delete draft dataset
#' @description Delete a dataset draft
#' @details This function can be used to delete a draft (unpublished) Dataverse dataset. Once published, a dataset cannot be deleted. An existing draft can instead be modified using \code{\link{update_dataset}}.
#' @template ds
#' @template envars
#' @return A logical.
#' @seealso \code{\link{get_dataset}}, \code{\link{create_dataset}}, \code{\link{update_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{}
#' @export
delete_dataset <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    # can only delete a "draft" dataset
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/:draft")
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title Dataset versions
#' @description View versions of a dataset
#' @details This returns a list of objects of all versions of a dataset, including metadata. This can be used as a first step for retrieving older versions of files or datasets.
#' @template ds
#' @template envars
#' @return A list of class \dQuote{dataverse_dataset_version}.
#' @seealso \code{\link{get_dataset}}, \code{\link{dataset_files}}, \code{\link{publish_dataset}}
#' @examples
#' \dontrun{}
#' @export
dataset_versions <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- httr::content(r)$data
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
#' @template envars
#' @return A list of objects of class \dQuote{dataverse_file}.
#' @seealso \code{\link{get_dataset}}
#' @examples
#' \dontrun{}
#' @export
dataset_files <- function(dataset, version = ":latest", key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version, "/files")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"), simplifyDataFrame = FALSE)$data
    structure(lapply(out, `class<-`, "dataverse_file"))
}

#' @title Metadata block
#' @description Get a named metadata block for a dataset
#' @details This function returns a named metadata block for a dataset. This is already returned by \code{\link{get_dataset}}, but this function allows you to retrieve just a specific block of metadata, such as citation information.
#' @template ds
#' @template version 
#' @param block A character string specifying a metadata block to retrieve. By default this is \dQuote{citation}. Other values may be available, depending on the dataset, such as \dQuote{geospatial} or \dQuote{socialscience}.
#' @template envars
#' @return A list of form dependent on the specific metadata block retrieved.
#' @seealso \code{\link{get_dataset}}
#' @examples
#' \dontrun{}
#' @export
dataset_metadata <- function(dataset, version = ":latest", block = "citation", key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    if (!is.null(block)) {
        u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version, "/metadata/", block)
    } else {
        u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version, "/metadata")
    }
    
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}
