#' @title Create user
#' @description Create a Dataverse user
#' @details
#' @param password A character vector specifying the password for the new user.
#' @template envars
#' @return A list.
#' @examples
#' \dontrun{}
#' @export
create_user <- function(password, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    u <- paste0("https://", server,"/api/builtin-users?password=", password)
    r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)
}

#' @title Get API Key
#' @description Get a user's API key
#' @details Use a Dataverse server's username and password login to obtain an API key for the user. This can be used if one does not yet have an API key, or desires to reset the key. This function does not require an API \code{key} argument to authenticate, but \code{server} must still be specified.
#' @param user A character vector specifying a Dataverse server username.
#' @param password A character vector specifying the password for this user.
#' @param server A character string specifying a Dataverse server. There are multiple Dataverse installations, but the defaults is to use the Harvard Dataverse. This can be modified atomically or globally using \code{Sys.setenv("DATAVERSE_SERVER" = "dataverse.example.com")}.
#' @return A list.
#' @examples
#' \dontrun{}
#' @export
get_user_key <- function(user, password, server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    u <- paste0("https://", server,"/api/builtin-users/", user, "/api-token?password=", password)
    r <- httr::GET(u, ...)
    httr::stop_for_status(r)
    j <- jsonlite::fromJSON(httr::content(r, "text"))
    j$data$message
}
