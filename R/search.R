#' @title Search Dataverse server
#' @description Search for Dataverses and datasets
#' @details This function provides an interface for searching for Dataverses, datasets, and/or files within a Dataverse server.
#' @template dv
#' @param ... A character string specifying a search query or a named list of search argument.
#' @param type A character vector specifying one or more of \dQuote{dataverse}, \dQuote{dataset}, and \dQuote{file}, which is used to restrict the search results. By default, all three types of objects are searched for.
#' @param subtree
#' @param sort A character vector specifying whether to sort results by \dQuote{name} or \dQuote{date}.
#' @param order A character vector specifying either \dQuote{asc} or \dQuote{desc} results order.
#' @param per_page An integer specifying the page size of results.
#' @param start An integer specifying used for pagination.
#' @param show_relevance A logical.
#' @param show_facets A logical.
#' @param fq
#' @template envvars
#' @param verbose A logical indicating whether to display information about the search query (default is \code{TRUE}).
#' @param http_opts Currently ignored.
#' @return A list.
#' @seealso \code{\link{dataverse_file}}, \code{\link{get_dataverse}}, \code{\link{get_dataset}}, \code{\link{dataverse_contents}}
#' @examples
#' \dontrun{}
#' @export
dataverse_search <- 
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
    
    u <- paste0(api_url(server), "search")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), query = query)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"))
    if(verbose) {
        n_total <- ngettext(out$data$total_count, "result", "results")
        message(sprintf(paste0("%s of %s ", n_total, " retrieved"), out$data$count_in_response, out$data$total_count))
    }
    out$data$items
}
