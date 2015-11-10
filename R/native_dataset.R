#' @title
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

#' @title
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
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/:draft")
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), body = body, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
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
    u <- paste0("https://", server,"/api/datasets/", dataset, "/actions/:publish?type=", if (minor) "minor" else "major")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
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

print.dataverse_dataset <- function(x, ...) {
    cat("Dataset (", x$id, "): ", x$persistentUrl, "\n", sep = "")
    cat("Version: ", x$latestVersion$versionNumber, ".", x$latestVersion$versionNumber, "\n", sep = "")
    cat("Version State: ", x$latestVersion$versionState, "\n", sep = "")
    cat("Release Date: ", x$latestVersion$releaseTime, "\n", sep = "")
    n <- nrow(x$latestVersion$files)
    cat(n, ngettext(n, " File:", " Files:"), "\n", sep = "")
    print(x$latestVersion$files)
    cat("\n")
    invisible(x)    
}

#' @title
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
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/:draft")
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
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
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
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
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
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
    u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version, "/files")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"), simplifyDataFrame = FALSE)$data
    structure(lapply(out, `class<-`, "dataverse_file"))
}

print.dataverse_file <- function(x, ...) {
    cat("File (", x$dataFile$id, "): ", x$dataFile$filename, "\n", sep = "")
    cat("MD5: ", x$dataFile$md5, "\n", sep = "")
    cat("Description: ", x$dataFile$description, "\n\n", sep = "")
    invisible(x)
}

#' @title
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
    if (!is.null(block)) {
        u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version, "/metadata/", block)
    } else {
        u <- paste0("https://", server,"/api/datasets/", dataset, "/versions/", version, "/metadata")
    }
    
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}
