# @title Create user
# @description Create a Dataverse user
# @details Create a new Dataverse user.
# @param password A character vector specifying the password for the new user.
# @template envvars
# @template dots
# @return A list.
# @seealso \code{\link{get_user_key}}
# @examples
# \dontrun{
# create_user("password")
# }
# @export
create_user <- function(password, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    u <- paste0(api_url(server), "builtin-users?password=", password)
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    httr::content(r, as = "text", encoding = "UTF-8")
}

#' @title Get API Key
#' @description Get a user's API key
#' @details Use a Dataverse server's username and password login to obtain an
#'  API key for the user. This can be used if one does not yet have an API key,
#'  or desires to reset the key. This function does not require an API \code{key}
#'  argument to authenticate, but \code{server} must still be specified.
#' @param user A character vector specifying a Dataverse server username.
#' @param password A character vector specifying the password for this user.
#' @param server The Dataverse instance. See `get_file`.
#'
#' @template dots
#'
#' @return A list.
#' @examples
#' \dontrun{
#'  # Replace Username and password with personal login
#'  get_user_key("username", "password", server = "dataverse.harvard.edu")
#' }
#' @export
get_user_key <- function(user, password, server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    u <- paste0(api_url(server), "builtin-users/", user, "/api-token?password=", password)
    r <- httr::GET(u, ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    j <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))
    j$data$message
}
