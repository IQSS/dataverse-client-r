#' @rdname role_assignments
#' @title Role assignments
#' @description Get, set, and delete role assignments for a Dataverse
#' @details \code{assign_role} assigns a Dataverse role to a user.
#' @template dv
#' @param assignee \dots
#' @param role \dots
#' @param assignment \dots
#' @template envvars
#' @template dots
#' @return A list of objects of class \dQuote{dataverse_role_assignment}.
#' @examples
#' \dontrun{
#' # get role assignments
#' get_assignments("my_dataverse")
#' }
#' @seealso \code{\link{create_role}}
#' @export
get_assignments <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/assignments")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"), simplifyDataFrame = FALSE)$data
    lapply(out, function(x) {
        x$dataverse <- dataverse
        class(x) <- "dataverse_role_assignment"
        x
    })
}

#' @rdname role_assignments
#' @export
assign_role <- function(dataverse, assignee, role, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/assignments")
    b <- list(assignee = assignee, role = role)
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), body = b, encode = "json", ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))$data
    j
}

#' @rdname role_assignments
#' @export
delete_assignment <- function(dataverse, assignment, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/assignments/", assignment)
    r <- httr::DELETE(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r, as = "text", encoding = "UTF-8")
}
