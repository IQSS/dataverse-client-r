#' @title Create role
#' @description Create a role
#' @details In Dataverse, a role enables complex administration of user access to Dataverse. This can allow you to provide read, write, and administrative access to different users for specific parts of a Dataverse. \code{create_role} creates a new role with the name given by a character string in the \code{role} argument.
#' @template role
#' @template envars
#' @return A list.
#' @seealso \code{\link{get_role}}, \code{\link{delete_role}}
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
#' @description Retrieve a Dataverse role
#' @details Once created using \code{\link{create_role}}, this function can be used to retrieve roles for a Dataverse. \code{\link{delete_role}} can delete a role.
#' @template role
#' @template envars
#' @return A list.
#' @seealso \code{\link{create_role}}, \code{\link{delete_role}}
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
#' @description Delete a Dataverse role
#' @details This function deletes a Dataverse role.
#' @template role
#' @template envars
#' @return A list.
#' @seealso \code{\link{create_role}}, \code{\link{get_role}}
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

#' @title Get Dataverse roles
#' @description
#' @details
#' @template dv
#' @template envars
#' @return
#' @seealso \code{\link{create_role}}
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

