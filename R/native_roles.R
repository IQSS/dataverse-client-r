# @rdname roles
# @title Roles
# @description Get, create, update, and delete a Dataverse role
# @details In Dataverse, roles provide one or more users with permissions. Rather than granting several permissions to each user, you can create a role that carries specific permissions and then freely change the roles to which each user is assigned. See \href{http://guides.dataverse.org/en/latest/user/dataverse-management.html#dataverse-permissions}{the Dataverse User Guide} for more details.
#
# Once created using \code{\link{create_role}}, \code{\link{delete_role}} can delete a role.
# @template role
# @template dv
# @param alias \dots
# @param name \dots
# @param description \dots
# @param permissions \dots
# @template envvars
# @template dots
# @return A list.
# @examples
# \dontrun{
# # create a new role
# r <- create_role("mydataverse", "exampleRole", "role name", "description here")
# }
# @export
get_role <- function(role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    u <- paste0(api_url(server), "roles/", role)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    j <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
    j
}

# @rdname roles
# @export
delete_role <- function(role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    u <- paste0(api_url(server), "roles/", role)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    j <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
    j
}

# @rdname roles
# @export
list_roles <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (!missing(dataverse)) {
        dataverse <- dataverse_id(dataverse, key = key, server = server, ...)
        u <- paste0(api_url(server), "dataverses/", dataverse, "/roles")
        r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
        httr::stop_for_status(r, task = httr::content(r)$message)
        out <- jsonlite::fromJSON(httr::content(r, "text", encoding = "UTF-8"))$data
        structure(lapply(out, `class<-`, "dataverse_role"))
    } else {
        u <- paste0(api_url(server), "admin/roles")
        r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
        httr::stop_for_status(r, task = httr::content(r)$message)
        out <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
        structure(lapply(out, `class<-`, "dataverse_role"))
    }
}

# @rdname roles
# @export
create_role <- function(dataverse, alias, name, description, permissions,
                        key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {

    dataverse <- dataverse_id(dataverse, key = key, server = server, ...)
    b <- list(alias = alias, name = name, description = description)
    if (!missing(permissions)) {
        permissions <- permissions
    }
    u <- paste0(api_url(server), "dataverses/", dataverse, "/roles")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    j <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
    structure(j, class = "dataverse_role")
}
