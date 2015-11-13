#' @title Create role
#' @description
#' @details
#' @template role
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
create_role <- function(role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    u <- paste0("https://", server,"/api/roles?dvo=", role)
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))
    j
}

#' @title Get role
#' @description
#' @details
#' @template role
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
get_role <- function(role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    u <- paste0("https://", server,"/api/roles/", role)
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))
    j
}

#' @title Delete role
#' @description
#' @details
#' @template role
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
delete_role <- function(role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    u <- paste0("https://", server,"/api/roles/", role)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))
    j
}

#' @title Create role group
#' @description
#' @details
#' @template dv
#' @param alias
#' @param name
#' @param description
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
create_group <- function(dataverse, alias, name, description, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    b <- list(description = description,
              displayName = name,
              aliasToOwner = alias)
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server, "/api/dataverse/", dataverse, "/groups")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))
    j
}

#' @title Update role group
#' @description
#' @details
#' @template dv
#' @param alias
#' @param name
#' @param description
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
update_group <- function(dataverse, alias, name, description, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    b <- list(description = description,
              displayName = name,
              alias = alias)
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server, "/api/dataverse/", dataverse, "/groups/", alias)
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))
    j
}

#' @title List role groups
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
list_groups <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server, "/api/dataverse/", dataverse, "/groups")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))
    j
}

#' @title Get role group
#' @description
#' @details
#' @template dv
#' @param alias
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
get_group <- function(dataverse, alias, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server, "/api/dataverse/", dataverse, "/groups/", alias)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))
    j
}

#' @title Delete role group
#' @description
#' @details
#' @template dv
#' @param alias
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
delete_group <- function(dataverse, alias, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server, "/api/dataverse/", dataverse, "/groups/", alias)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    r
}

#' @title Add roles to group
#' @description
#' @details
#' @template dv
#' @param alias
#' @template role
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
add_roles_to_group <- function(dataverse, alias, role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {

    # need support for bulk add
    
    if(is.null(server) || server == "") {
        stop("'server' is missing, but required")
    }
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server, "/api/dataverse/", dataverse, "/groups/", alias, "/roleAssignees/", role)
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))
    j
}

#' @title Remove role
#' @description
#' @details
#' @template dv
#' @param alias
#' @template role
#' @template envars
#' @return
#' @examples
#' \dontrun{}
#' @export
remove_role_from_group <- function(dataverse, alias, role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server, "/api/dataverse/", dataverse, "/groups/", alias, "/roleAssignees/", role)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))
    j
}

