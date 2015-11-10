#' @title
#' @description
#' @details
#' @param password
#' @template envars
#' @return
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

#' @title
#' @description
#' @details
#' @param user
#' @param password
#' @param server
#' @return
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
