#' @export
dv_search <- 
function(..., 
         type = c("dataverse", "dataset", "file"),
         subtree = NULL,
         sort = c("name", "date"),
         order = c("asc", "desc"),
         per_page = 10,
         start = NULL,
         show_relevance = FALSE,
         show_facets = FALSE,
         fq = NULL,
         key = Sys.getenv("DATAVERSE_KEY"),
         server = Sys.getenv("DATAVERSE_SERVER"),
         http_opts = NULL) {
    
    # parse `...` search query argument(s)
    ## missing, fine
    ## a length-1 character vector; passed directly as `q`
    ## a named character vector; converted to single character string
    ## a named list of character strings; converted to a single character string
    a <- list(...)
    if (length(a) ) {
        if (length(a) == 1) {
            if (is.null(names(a))) {
                query <- a
            } else {
                query <- paste0(names(a), ":", unname(a))
            }
        } else {
            
        }
    }
    
    # check arguments
    stopifnot(all(type %in% c("dataverse", "dataset", "file")))
    type <- paste(type, sep = ":")
    stopifnot(per_page >0 && per_page <= 1000)
    sort <- match.arg(sort)
    order <- match.arg(order)
    server <- urltools::url_parse(server)$domain
    
    u <- paste0("https://", server, "/api/search")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), )
    httr::stop_for_status(r)
    httr::content(r, "text")
}
