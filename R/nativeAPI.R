#' @title
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
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

print.dataverse <- function(x, ...) {
    cat("Dataverse:   ", x$alias, "\n", sep = "")
    cat("ID:          ", x$id, "\n", sep = "")
    cat("Name:        ", x$name, "\n", sep = "")
    cat("Description: ", x$description, "\n", sep = "")
    cat("Created:     ", x$creationDate, "\n", sep = "")
    cat("Creator:     ", x$creator$identifier, "\n", sep = "")
    invisible(x)
}

#' @title
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
create_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse)
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
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

#' @title
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
list_contents <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
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

#' @title
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
get_roles <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/roles")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"))$data
    structure(lapply(out, `class<-`, "dataverse_role"))
}

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
create_role <- function(dataverse, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/roles")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = body, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
get_facets <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/facets")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
get_role_assignments <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/assignments")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"))$data
    structure(lapply(out, `class<-`, "dataverse_role_assignment"))
}

#' @title
#' @description
#' @details
#' @template dv
#' @assignee
#' @role
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
assign_role <- function(dataverse, assignee, role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/assignments")
    b <- list(assignee = assignee, role = role)
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
#' @description
#' @details
#' @template dv
#' @assignment
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
delete_assignment <- function(dataverse, assignment, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/assignments/", assignment)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
get_metadata <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/metadatablocks")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
#' @description
#' @details
#' @template dv
#' @param root
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
set_metadata <- function(dataverse, root = TRUE, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/metadatablocks/", tolower(as.character(root)))
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
publish_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/actions/:publish")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}
