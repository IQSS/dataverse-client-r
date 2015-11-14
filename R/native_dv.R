#' @title Get Dataverse
#' @description Retrieve details of a Dataverse
#' @details This function retrieves a Dataverse from a Dataverse server. To see the contents of the Dataverse, use \code{\link{dataverse_contents}} instead.
#' @template dv 
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{dataverse}.
#' @seealso To manage Dataverses: \code{\link{create_dataverse}},  \code{\link{delete_dataverse}}, \code{\link{publish_dataverse}}, \code{\link{dataverse_contents}}; to get datasets: \code{\link{get_dataset}}; to search for Dataverses, datasets, or files: \code{\link{dataverse_search}}
#' @examples
#' \dontrun{}
#' @export
get_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"))
    structure(out$data, class = "dataverse")
}

#' @title Create Dataverse
#' @description Create a new Dataverse
#' @details This function can create a new Dataverse. In the language of Dataverse, a user has a \dQuote{root} Dataverse into which they can create further nested Dataverses and/or \dQuote{datasets} that contain, for example, a set of files for a specific project. Creating a new Dataverse can therefore be a useful way to organize other related Dataverses or sets of related datasets. 
#' 
#' For example, if one were involved in an ongoing project that generated monthly data. One may want to store each month's data and related files in a separate \dQuote{dataset}, so that each has its own persistent identifier (e.g., DOI), but keep all of these datasets within a named Dataverse so that the project's files are kept separate the user's personal Dataverse records. The flexible nesting of Dataverses allows for a number of possible organizational approaches.
#' 
#' @param dv A character string specifying a Dataverse name.
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso \code{\link{get_dataverse}},  \code{\link{delete_dataverse}}, \code{\link{publish_dataverse}}, \code{\link{create_dataset}}
#' @examples
#' \dontrun{}
#' @export
create_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    u <- paste0("https://", server,"/api/dataverses/", dataverse)
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title Delete Dataverse
#' @description Delete a dataverse
#' @details This function deletes a Dataverse.
#' @template dv
#' @template envvars
#' @template dots
#' @return A logical.
#' @seealso \code{\link{create_dataverse}},  \code{\link{get_dataverse}}, \code{\link{publish_dataverse}}, \code{\link{delete_dataset}}
#' @examples
#' \dontrun{}
#' @export
delete_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title List contents
#' @description List the contents of a Dataverse
#' @details This function lists the contents of a Dataverse. Contents might include one or more \dQuote{datasets} and/or further Dataverses that themselves contain Dataverses and/or datasets. To view the file contents of a single Dataset, use \code{\link{get_dataset}}.
#' @template dv
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{dataverse_contents}
#' @seealso \code{\link{create_dataverse}},  \code{\link{get_dataverse}}, \code{\link{publish_dataverse}}, \code{\link{dataverse_search}}, \code{\link{get_dataset}}, \code{\link{delete_dataset}}
#' @examples
#' \dontrun{}
#' @export
dataverse_contents <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/contents")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"), simplifyDataFrame = FALSE)
    structure(lapply(out$data, function(x) {
        `class<-`(x, if (x$type == "dataset") "dataverse_dataset" else "dataverse")
    }), class = "dataverse_contents")
}

#' @title Get Dataverse facets
#' @description Dataverse metadata facets
#' @details Retrieve a list of Dataverse metadata facets.
#' @template dv
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{}
#' @export
get_facets <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/facets")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)$data
}

#' @title Dataverse metadata
#' @description Get metadata for a named Dataverse.
#' @details This function returns a list of metadata for a named Dataverse. Use \code{\link{dataverse_contents}} to list Dataverses and/or datasets contained within a Dataverse or use \code{\link{dataset_metadata}} to get metadata for a specific dataset.
#' @template dv
#' @template envvars
#' @template dots
#' @return A list
#' @seealso \code{\link{set_dataverse_metadata}}
#' @examples
#' \dontrun{}
#' @export
dataverse_metadata <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/metadatablocks")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)$data
}

#' @title Set Dataverse metadata
#' @description Set Dataverse metadata
#' @details This function sets the value of metadata fields for a Dataverse. Use \code{\link{update_dataset}} to set the metadata fields for a dataset instead.
#' @template dv
#' @param body A list.
#' @param root A logical.
#' @template envvars
#' @template dots
#' @return A list
#' @seealso \code{\link{dataverse_metadata}}
#' @examples
#' \dontrun{}
#' @export
set_dataverse_metadata <- function(dataverse, body, root = TRUE, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/metadatablocks/", tolower(as.character(root)))
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)$data
}

#' @title Publish Dataverse
#' @description Publish/release a draft Dataverse
#' @details This function makes a Dataverse publicly visible. This cannot be undone.
#' @template dv
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso To manage Dataverses: \code{\link{create_dataverse}},  \code{\link{delete_dataverse}}, \code{\link{publish_dataverse}}, \code{\link{dataverse_contents}}
#' @examples
#' \dontrun{}
#' @export
publish_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/actions/:publish")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)$data
}
