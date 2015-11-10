#' @title
#' @description
#' @details
#' @template dv
#' @param ...
#' @param type
#' @param subtree
#' @param sort
#' @param order
#' @param per_page
#' @param start
#' @param show_relevance
#' @param show_facets
#' @param fq
#' @template envars
#' @param verbose A logical indicating whether to display information about the search query (default is \code{TRUE}).
#' @param http_opts Currently ignored.
#' @return
#' @examples
#' \dontrun{}
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
         verbose = TRUE,
         http_opts = NULL) {
    
    # parse `...` search query argument(s)
    ## missing, fine
    ## a length-1 character vector; passed directly as `q`
    ## a named character vector; converted to single character string
    ## a named list of character strings; converted to a single character string
    a <- list(...)
    if (length(a)) {
        if ((length(a) == 1) & (is.null(names(a)))) {
            query <- list(q = a)
        } else {
            query <- list(q = paste0(names(a), ":", unname(a), collapse = ","))
        }
    } else {
        query <- NULL
    }
    
    # check arguments
    if(!is.null(type)) {
        stopifnot(all(type %in% c("dataverse", "dataset", "file")))
        type <- paste(type, sep = ":")
    }
    stopifnot(per_page >0 && per_page <= 1000)
    sort <- match.arg(sort)
    order <- match.arg(order)
    server <- urltools::url_parse(server)$domain
    
    u <- paste0("https://", server, "/api/search")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), query = query)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"))
    if(verbose) {
        n_total <- ngettext(out$data$total_count, "result", "results")
        message(sprintf(paste0("%s of %s ", n_total, " retrieved"), out$data$count_in_response, out$data$total_count))
    }
    out$data$items
}
