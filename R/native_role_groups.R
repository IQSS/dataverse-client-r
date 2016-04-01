#' @title Create role group
#' @description Create a role group
#' @details Role groups can be used to organize roles for a Dataverse.
#' @template dv
#' @param alias A character string specifying an alias for the role group.
#' @param name A character string specifying the name of the role group.
#' @param description A character string specifying a description of the role group.
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{dataverse_group}.
#' @seealso \code{\link{list_groups}}, \code{\link{update_group}}, \code{\link{get_group}}, \code{\link{add_roles_to_group}}, \code{\link{delete_group}}
#' @examples
#' \dontrun{
#' # create a group
#' g <- create_group("my_dataverse", "testgroup", "aGroupName", "this is a test group")
#' 
#' # update group details
#' update_group(g, description = "this needs a new description")
#'
#' # get group details
#' get_group(g)
#'
#' # list all groups
#' list_groups("my_dataverse")
#'
#' # delete group
#' delete_group(g)
#' }
#' @export
create_group <- function(dataverse, alias, name, description, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    b <- list(description = description,
              displayName = name,
              aliasInOwner = alias)
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
    j$dataverse <- dataverse
    structure(j, class = "dataverse_group")
}

#' @title Update role group
#' @description \dots
#' @details \dots
#' @template group
#' @param name A character string specifying the name of the role group.
#' @param description A character string specifying a description of the role group.
#' @param dataverse A character string specifying a Dataverse name or an object of class \dQuote{dataverse}. Can be missing if \code{role} is an object of class \dQuote{dataverse_group}.
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{dataverse_group}.
#' @seealso \code{\link{create_group}}, \code{\link{list_groups}}, \code{\link{get_group}}, \code{\link{add_roles_to_group}}, \code{\link{delete_group}}
#' @examples
#' \dontrun{
#' # create a group
#' g <- create_group("my_dataverse", "testgroup", "aGroupName", "this is a test group")
#' 
#' # update group details
#' update_group(g, description = "this needs a new description")
#'
#' # get group details
#' get_group(g)
#'
#' # list all groups
#' list_groups("my_dataverse")
#'
#' # delete group
#' delete_group(g)
#' }
#' @export
update_group <- function(group, name, description, dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    b <- list()
    if (inherits(group, "dataverse_group")) {
        b$groupAliasInOwner <- group$groupAliasInOwner
        if (missing(name)) {
            b$displayName <- group$displayName
        }
        if (missing(description)) {
            b$description <- group$description
        }
        dataverse <- dataverse_id(group$dataverse)
        u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", group$groupAliasInOwner)
    } else {
        b$groupAliasInOwner <- group
        if (!missing(name)) {
            b$displayName <- name
        }
        if (!missing(description)) {
            b$description <- description
        }
        dataverse <- dataverse_id(dataverse)
        u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", group)
    }
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
    j$dataverse <- dataverse
    structure(j, class = "dataverse_group")
}

#' @title List role groups
#' @description Returns a list of role groups for a given dataverse
#' @details Role groups can be used to organize roles for a dataverse.
#' @template dv
#' @template envvars
#' @template dots
#' @return A list of objects of class \dQuote{dataverse_group}.
#' @seealso \code{\link{create_group}}, \code{\link{update_group}}, \code{\link{get_group}}, \code{\link{add_roles_to_group}}, \code{\link{delete_group}}
#' @examples
#' \dontrun{
#' # create a group
#' g <- create_group("my_dataverse", "testgroup", "aGroupName", "this is a test group")
#' 
#' # update group details
#' update_group(g, description = "this needs a new description")
#'
#' # get group details
#' get_group(g)
#'
#' # list all groups
#' list_groups("my_dataverse")
#'
#' # delete group
#' delete_group(g)
#' }
#' @export
list_groups <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"), simplifyDataFrame = FALSE)$data
    lapply(j, function(x) {
        x$dataverse <- dataverse
        class(x) <- "dataverse_group"
        x
    })
}

#' @title Get role group
#' @description \dots
#' @details \dots
#' @template group
#' @param dataverse A character string specifying a Dataverse name or an object of class \dQuote{dataverse}. Can be missing if \code{role} is an object of class \dQuote{dataverse_group}.
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{dataverse_group}.
#' @seealso \code{\link{list_groups}}, \code{\link{create_group}}, \code{\link{update_group}}, \code{\link{add_roles_to_group}}, \code{\link{delete_group}}
#' @examples
#' \dontrun{
#' # create a group
#' g <- create_group("my_dataverse", "testgroup", "aGroupName", "this is a test group")
#' 
#' # update group details
#' update_group(g, description = "this needs a new description")
#'
#' # get group details
#' get_group(g)
#'
#' # list all groups
#' list_groups("my_dataverse")
#'
#' # delete group
#' delete_group(g)
#' }
#' @export
get_group <- function(group, dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(group, "dataverse_group")) {
        dataverse <- dataverse_id(group$dataverse)
        u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", group$groupAliasInOwner)
    } else {
        dataverse <- dataverse_id(dataverse)
        u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", group)
    }
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
    j$dataverse <- dataverse
    structure(j, class = "dataverse_group")
}

#' @title Delete role group
#' @description \dots
#' @details \dots
#' @template group
#' @param dataverse A character string specifying a Dataverse name or an object of class \dQuote{dataverse}. Can be missing if \code{role} is an object of class \dQuote{dataverse_group}.
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' # create a group
#' g <- create_group("my_dataverse", "testgroup", "aGroupName", "this is a test group")
#' 
#' # update group details
#' update_group(g, description = "this needs a new description")
#'
#' # get group details
#' get_group(g)
#'
#' # list all groups
#' list_groups("my_dataverse")
#'
#' # delete group
#' delete_group(g)
#' }
#' @export
delete_group <- function(group, dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(group, "dataverse_group")) {
        dataverse <- dataverse_id(group$dataverse)
        group <- group$groupAliasInOwner
    } else {
        dataverse <- dataverse_id(dataverse)
    }
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", group)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))
    if (out$status == "OK") {
        return(TRUE)
    } else {
        return(FALSE)
    }
}

#' @title Add roles to group
#' @description \dots
#' @details \dots
#' @template group
#' @template role
#' @param dataverse A character string specifying a Dataverse name or an object of class \dQuote{dataverse}. Can be missing if \code{role} is an object of class \dQuote{dataverse_group}.
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' 
#' }
#' @export
add_roles_to_group <- function(group, role, dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    
    if (inherits(group, "dataverse_group")) {
        dataverse <- dataverse_id(group$dataverse)
        group <- group$groupAliasInOwner
    } else {
        dataverse <- dataverse_id(dataverse)
    }
    
    # need support for bulk add
    
    if(is.null(server) || server == "") {
        stop("'server' is missing, but required")
    }
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", group, "/roleAssignees/", role)
    r <- httr::PUT(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
    j
}

#' @title Remove role from group
#' @description \dots
#' @details \dots
#' @template group
#' @template role
#' @param dataverse A character string specifying a Dataverse name or an object of class \dQuote{dataverse}. Can be missing if \code{role} is an object of class \dQuote{dataverse_group}.
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' 
#' }
#' @export
remove_role_from_group <- function(group, role, dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(group, "dataverse_group")) {
        dataverse <- dataverse_id(group$dataverse)
        group <- group$groupAliasInOwner
    } else {
        dataverse <- dataverse_id(dataverse)
    }
    u <- paste0(api_url(server), "dataverses/", dataverse, "/groups/", group, "/roleAssignees/", role)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r, as = "text", encoding = "UTF-8")
}
