#' @title Search Dataverse server
#' @description Search for Dataverses and datasets
#' @details This function provides an interface for searching for Dataverses, datasets, and/or files within a Dataverse server.
#' @template dv
#' @param ... A length-one character vector specifying a search query, a named character vector of search arguments, or a sequence of named character arguments. The specific fields available may vary by server installation.
#' @param type A character vector specifying one or more of \dQuote{dataverse}, \dQuote{dataset}, and \dQuote{file}, which is used to restrict the search results. By default, all three types of objects are searched for.
#' @param subtree Currently ignored.
#' @param sort A character vector specifying whether to sort results by \dQuote{name} or \dQuote{date}.
#' @param order A character vector specifying either \dQuote{asc} or \dQuote{desc} results order.
#' @param per_page An integer specifying the page size of results.
#' @param start An integer specifying used for pagination.
#' @param show_relevance A logical.
#' @param show_facets A logical.
#' @param fq Currently ignored.
#' @template envvars
#' @param verbose A logical indicating whether to display information about the search query (default is \code{TRUE}).
#' @param http_opts Currently ignored.
#' @return A list.
#' @seealso \code{\link{dataverse_file}}, \code{\link{get_dataverse}}, \code{\link{get_dataset}}, \code{\link{dataverse_contents}}
#' @examples
#' \dontrun{
#' # simple string search
#' dataverse_search("Gary King")
#'
#' # search using named arguments
#' dataverse_search(c(author = "Gary King", title = "Ecological Inference"))
#' dataverse_search(author = "Gary King", title = "Ecological Inference")
#'
#' # search only for datasets
#' dataverse_search(author = "Gary King", type = "dataset")
#' }
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
    a <- list(...)
    if (length(a)) {
        if ((length(a) == 1) & length(a[[1]]) > 1) {
            a <- as.list(a[[1]])
        }
        if (!is.list(a[[1]]) & (is.null(names(a)))) {
            ## a length-1 character vector; passed directly as `q`
            query <- list(q = a)
        } else {
            ## a named list of character strings; converted to a single character string
            query <- list(q = paste0(names(a), ":", unname(unlist(a)), collapse = ","))
        }
    } else {
        ## missing, fine
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
