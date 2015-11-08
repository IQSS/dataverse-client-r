#' @export
download_file <- 
function(file, 
         format = c("original", "RData", "prep", "bundle"),
         # thumb = TRUE,
         vars = NULL,
         key = Sys.getenv("DATAVERSE_KEY"), 
         server = Sys.getenv("DATAVERSE_SERVER"), 
         ...) {
    
    server <- urltools::url_parse(server)$domain
    
    if (length(file) > 1) {
        file <- paste0(file, collapse = ",")
        u <- paste0("https://", server, "/api/access/datafiles/", file)
        r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
        httr::stop_for_status(r)
        r
    } else {
        if (format == "bundle") {
            u <- paste0("https://", server, "/api/access/datafile/bundle/", file)
            r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
        } else {
            u <- paste0("https://", server, "/api/access/datafile/", file)
            query <- list()
            if (!is.null(vars)) {
                query$vars <- paste0(vars, collapse = ",")
            } 
            if (!is.null(format)) {
                query$format <- match.arg(format)
            }
            
            # request
            if (length(query)) {
                r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), query = query, ...)
            } else {
                r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
            }
        }
        
        httr::stop_for_status(r)
        r
    }
}

#' @export
get_metadata <- 
function(file, 
         format = c("ddi", "preprocessed"),
         key = Sys.getenv("DATAVERSE_KEY"), 
         server = Sys.getenv("DATAVERSE_SERVER"), 
         ...) {
    format <- match.arg(format)
    u <- paste0("https://", server, "/api/access/datafile/", file, "/metadata/", format)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    r
}


# UNF functions to validate dataset against Dataverse metadata

