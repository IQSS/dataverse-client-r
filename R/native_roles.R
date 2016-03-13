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

#' @title List Dataverse roles
#' @description List roles associated with a Dataverse
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
        out <- jsonlite::fromJSON(httr::content(r, "text"))$data
        structure(lapply(out, `class<-`, "dataverse_role"))
    }
}

#' @title Create Dataverse role
#' @description Create a Dataverse role
#' @details In Dataverse, roles provide one or more users with permissions. Rather than granting several permissions to each user, you can create a role that carries specific permissions and then freely change the roles to which each user is assigned. See \href{http://guides.dataverse.org/en/latest/user/dataverse-management.html#dataverse-permissions}{the Dataverse User Guide} for more details.
#' @template dv
#' @param alias \dots
#' @param name \dots
#' @param description \dots
#' @param permissions \dots
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso \code{\link{list_roles}}, \code{\link{delete_role}}, \code{\link{assign_role}}, \code{\link{get_role}}
#' @examples
#' \dontrun{
#' # create a new role
#' r <- create_role("mydataverse", "exampleRole", "role name", "description here")
#' }
#' @export
create_role <- function(dataverse, alias, name, description, permissions, 
                        key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    
    dataverse <- dataverse_id(dataverse)
    b <- list(alias = alias, name = name, description = description)
    if (!missing(permissions)) {
        permissions <- permissions
    }
    u <- paste0(api_url(server), "dataverses/", dataverse, "/roles")
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))$data
    structure(j, class = "dataverse_role")
}

#' @title Get role assignments
#' @description Get list of role assignments for a Dataverse
#' @details \dots
#' @template dv
#' @template envvars
#' @template dots
#' @return A list of objects of class \dQuote{dataverse_role_assignment}.
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
    out <- jsonlite::fromJSON(httr::content(r, "text"), simplifyDataFrame = FALSE)$data
    lapply(out, function(x) {
        x$dataverse <- dataverse
        class(x) <- "dataverse_role_assignment"
        x
    })
}

#' @title Assign Dataverse role
#' @description Assign a Dataverse role to a user
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
#' @description Deletes a Dataverse role assignment
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
