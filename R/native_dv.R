#' @title Get Dataverse
#' @description Retrieve details of a Dataverse
#' @details 
#' @template dv 
#' @template envars
#' @return A list of class \dQuote{dataverse}.
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
#' @details
#' @param dv A character string specifying a Dataverse name.
#' @template envars
#' @return A list.
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
#' @details
#' @template dv
#' @template envars
#' @return A logical.
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
#' @details
#' @template dv
#' @template envars
#' @return A list of class \dQuote{dataverse_contents}
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

#' @title Get Dataverse roles
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

#' @title Create Dataverse role
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

#' @title Get Dataverse facets
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

#' @title Get Dataverse role assignments
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
get_assignments <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/api/dataverses/", dataverse, "/assignments")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"))$data
    structure(lapply(out, `class<-`, "dataverse_role_assignment"))
}

#' @title Assign Dataverse role
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

#' @title Delete Dataverse role assignment
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

#' @title Get Dataverse metadata
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

#' @title Set Dataverse metadata
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

#' @title Publish Dataverse
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
