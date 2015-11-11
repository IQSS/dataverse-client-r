#' @title Create dataset
#' @description
#' @details
#' @template dv
#' @param body
#' @template envars
#' @return
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
#' @description
#' @details
#' @template ds
#' @param body
#' @template envars
#' @return
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
#' @description
#' @details
#' @template ds
#' @param minor
#' @template envars
#' @return
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
#' @description
#' @details
#' @template ds
#' @param version
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
get_dataset <- function(dataset, version = NULL, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    if (!is.null(version)) {
        u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version)
    } else {
        u <- paste0("https://", server,"/api/datasets/", dataset)
    }
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"))
    structure(out$data, class = "dataverse_dataset")
}

#' @title Delete draft dataset
#' @description
#' @details
#' @template ds
#' @template envars
#' @return
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
#' @description
#' @details
#' @template ds
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
list_versions <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title Dataset metadata
#' @description
#' @details
#' @template ds
#' @param version
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
dataset_metadata <- function(dataset, version = ":latest", key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title Dataset files
#' @description
#' @details
#' @template ds
#' @param version
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
list_files <- function(dataset, version = ":latest", key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- dataset_id(dataset)
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version, "/files")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"), simplifyDataFrame = FALSE)$data
    structure(lapply(out, `class<-`, "dataverse_file"))
}

#' @title Dataset metadata block
#' @description
#' @details
#' @template ds
#' @param version
#' @param block
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
get_metadata_block <- function(dataset, version, block, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
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
