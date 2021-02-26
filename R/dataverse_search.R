#' @title Search Dataverse server
#' @description Search for Dataverses and datasets
#' @details This function provides an interface for searching for Dataverses, datasets, and/or files within a Dataverse server.
#' @template dv
#' @param \dots A length-one character vector specifying a search query, a named character vector of search arguments, or a sequence of named character arguments. The specific fields available may vary by server installation.
#' @param type A character vector specifying one or more of \dQuote{dataverse}, \dQuote{dataset}, and \dQuote{file}, which is used to restrict the search results. By default, all three types of objects are searched for.
#' @param subtree Currently ignored.
#' @param sort A character vector specifying whether to sort results by \dQuote{name} or \dQuote{date}.
#' @param order A character vector specifying either \dQuote{asc} or \dQuote{desc} results order.
#' @param per_page An integer specifying the page size of results.
#' @param start An integer specifying used for pagination.
#' @param show_relevance A logical indicating whether or not to show details of which fields were matched by the query
#' @param show_facets A logical indicating whether or not to show facets that can be operated on by the \code{fq} parameter
#' @param fq See API documentation.
#' @template envvars
#' @param verbose A logical indicating whether to display information about the search query (default is \code{TRUE}).
#' @param http_opts Currently ignored.
#' @return A list.
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
#' @seealso \code{\link{get_file}}, \code{\link{get_dataverse}}, \code{\link{get_dataset}}, \code{\link{dataverse_contents}}
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
            query <- list(q = a[[1]])
        } else {
            ## a named list of character strings; converted to a single character string
            query <- list(q = paste0(names(a), ":", unname(unlist(a)), collapse = ","))
        }
    } else {
        ## missing, fine
        query <- list()
    }
    # add query arguments from top-level arguments
    ## type
    if (!is.null(type)) {
        type <- match.arg(type, several.ok = TRUE)
        for (i in seq_along(type)) {
            query <- c(query, list(type = type[i]))
        }
    }
    ## subtree
    if (!is.null(subtree)) {
        query[["subtree"]] <- subtree
    }
    ## sort
    query[["sort"]] <- match.arg(sort)
    ## order
    query[["order"]] <- match.arg(order)
    ## per_page
    stopifnot(per_page >0 && per_page <= 1000)
    query[["per_page"]] <- per_page
    ## start
    if (!is.null(start)) {
        if (!is.numeric(start)) {
            stop("'start' must be numeric")
        }
        query[["start"]] <- start
    }
    ## show_relevance
    query[["show_relevance"]] <- show_relevance
    ## show_facets
    query[["show_facets"]] <- show_facets
    ## fq 
    # we're passing the unencoded fq string on to the API using I() as the API doesn't handle encoded strings properly
    if (!is.null(fq)) {
      query[["fq"]] <- I(fq)
    }

    # setup URL
    u <- paste0(api_url(server), "search")

    # execute request
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), query = query)
    httr::stop_for_status(r, task = httr::content(r)$message)
    out <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))
    if (isTRUE(verbose)) {
        n_total <- ngettext(out$data$total_count, "result", "results")
        message(sprintf(paste0("%s of %s ", n_total, " retrieved"), out$data$count_in_response, out$data$total_count))
    }
    out$data$items
}
