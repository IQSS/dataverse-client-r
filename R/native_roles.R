#' @title Get role
#' @description Retrieve a Dataverse role
#' @details Once created using \code{\link{create_role}}, this function can be used to retrieve roles for a Dataverse. \code{\link{delete_role}} can delete a role.
#' @template role
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso \code{\link{create_role}}, \code{\link{delete_role}}, \code{\link{assign_role}}, \code{\link{list_roles}}
#' @examples
#' \dontrun{
#' 
#' }
#' @export
get_role <- function(role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    u <- paste0(api_url(server), "roles/", role)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))$data
    j
}

#' @title Delete role
#' @description Delete a Dataverse role
#' @details This function deletes a Dataverse role.
#' @template role
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso \code{\link{create_role}}, \code{\link{get_role}}, \code{\link{assign_role}}, \code{\link{list_roles}}
#' @examples
#' \dontrun{
#' 
#' }
#' @export
delete_role <- function(role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    u <- paste0(api_url(server), "roles/", role)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))$data
    j
}

#' @title Create role group
#' @description \dots
#' @details \dots
#' @template dv
#' @param alias A character string specifying an alias for the role group.
#' @param name A character string specifying the name of the role group.
#' @param description A character string specifying a description of the role group.
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' 
#' }
#' @export
create_group <- function(dataverse, alias, name, description, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    b <- list(description = description,
              displayName = name,
              aliasToOwner = alias)
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))$data
    j
}

#' @title Update role group
#' @description \dots
#' @details \dots
#' @template dv
#' @param alias A character string specifying an alias for the role group.
#' @param name A character string specifying the name of the role group.
#' @param description A character string specifying a description of the role group.
#' @template envvars
#' @template dots
#' @return A list
#' @examples
#' \dontrun{
#' 
#' }
#' @export
update_group <- function(dataverse, alias, name, description, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    b <- list(description = description,
              displayName = name,
              alias = alias)
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", alias)
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))$data
    j
}

#' @title List role groups
#' @description \dots
#' @details \dots
#' @template dv
#' @template envvars
#' @template dots
#' @return A list
#' @examples
#' \dontrun{
#' 
#' }
#' @export
list_groups <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))$data
    j
}

#' @title Get role group
#' @description \dots
#' @details \dots
#' @template dv
#' @param alias
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' 
#' }
#' @export
get_group <- function(dataverse, alias, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", alias)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))$data
    j
}

#' @title Delete role group
#' @description \dots
#' @details \dots
#' @template dv
#' @param alias
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' 
#' }
#' @export
delete_group <- function(dataverse, alias, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", alias)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r, "text")
}

#' @title Add roles to group
#' @description \dots
#' @details \dots
#' @template dv
#' @param alias
#' @template role
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' 
#' }
#' @export
add_roles_to_group <- function(dataverse, alias, role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {

    # need support for bulk add
    
    if(is.null(server) || server == "") {
        stop("'server' is missing, but required")
    }
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", alias, "/roleAssignees/", role)
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))$data
    j
}

#' @title Remove role from group
#' @description \dots
#' @details \dots
#' @template dv
#' @param alias
#' @template role
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' 
#' }
#' @export
remove_role_from_group <- function(dataverse, alias, role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", alias, "/roleAssignees/", role)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r, "text")
}

#' @title List Dataverse roles
#' @description \dots
#' @details \dots
#' @template dv
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso \code{\link{create_role}}, \code{\link{delete_role}}, \code{\link{assign_role}}, \code{\link{get_role}}
#' @examples
#' \dontrun{
#' 
#' }
#' @export
list_roles <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (!missing(dataverse)) {
        dataverse <- dataverse_id(dataverse)
        u <- paste0(api_url(server), "dataverses/", dataverse, "/roles")
        r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
        httr::stop_for_status(r)
        out <- jsonlite::fromJSON(httr::content(r, "text"))$data
        structure(lapply(out, `class<-`, "dataverse_role"))
    } else {
        u <- paste0(api_url(server), "admin/roles")
        r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
        httr::stop_for_status(r)
    }
}

#' @title Create Dataverse role
#' @description \dots
#' @details \dots
#' @template dv
#' @param body A list.
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso \code{\link{list_roles}}, \code{\link{delete_role}}, \code{\link{assign_role}}, \code{\link{get_role}}
#' @examples
#' \dontrun{
#' 
#' }
#' @export
create_role <- function(dataverse, alias, name, description, permissions, 
                         key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    b <- list(alias = alias, name = name, description = description, permissions = permissions)
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/roles")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))$data
    j
}

#' @title Get Dataverse role assignments
#' @description \dots
#' @details \dots
#' @template dv
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' # get role assignments
#' get_assignments("my_dataverse")
#' }
#' @export
get_assignments <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/assignments")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"))$data
    out
}

#' @title Assign Dataverse role
#' @description \dots
#' @details \dots
#' @template dv
#' @param assignee \dots
#' @param role \dots
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso \code{\link{create_role}}, \code{\link{delete_role}}, \code{\link{list_roles}}, \code{\link{get_role}}, \code{\link{get_assignments}}
#' @examples
#' \dontrun{
#' 
#' }
#' @export
assign_role <- function(dataverse, assignee, role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/assignments")
    b <- list(assignee = assignee, role = role)
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))$data
    j
}

#' @title Delete Dataverse role assignment
#' @description \dots
#' @details \dots
#' @template dv
#' @param assignment \dots
#' @template envvars
#' @template dots
#' @return A list
#' @seealso \code{\link{get_role}}, \code{\link{get_assignments}}, \code{\link{assign_role}}
#' @examples
#' \dontrun{
#' 
#' }
#' @export
delete_assignment <- function(dataverse, assignment, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/assignments/", assignment)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}
