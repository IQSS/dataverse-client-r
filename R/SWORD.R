#' @title SWORD Service Document
#' @description Obtain a SWORD service document.
#' @details This function can be used to check authentication against the Dataverse SWORD server. It is typically a first step when creating a new Dataverse, a new Dataset, or modifying an existing Dataverse or Dataset.
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{sword_service_document}, possibly with one or more \dQuote{sword_collection} entries. The latter are SWORD representations of a Dataverse. These can be passed to other SWORD API functions, e.g., for creating a new dataset.
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#' @examples
#' \dontrun{
#' # retrieve your service document
#' d <- service_document()
#' 
#' # list available datasets in first dataverse
#' list_datasets(d[[2]])
#' }
#' @export
service_document <- function(key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/service-document")
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    x <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    w <- x$workspace
    out <- list()
    if ("title" %in% names(w)) {
        out$title <- w$title[[1]]
    }
    n <- which(names(w) == "collection")
    for (i in n) {
        s <- structure(list(name = w[[i]][[1]][[1]],
                            terms_of_use = w[[i]][[2]][[1]],
                            terms_apply = w[[i]][[3]][[1]],
                            package = w[[i]][[4]][[1]],
                            url = attributes(w[[i]])$href),
                       class = "sword_collection")
        out[[length(out) + 1]] <- s
    }
    out <- setNames(out, `[<-`(names(out), n, "sword_collection"))
    structure(out, class = "sword_service_document")
}

print.sword_service_document <- function(x, ...) {
    cat("Title: ", x$title, "\n")
    for (i in which(names(x) == "sword_collection")) {
        print(x[[i]])
    }
    invisible(x)
}

print.sword_collection <- function(x, ...) {
    cat("Dataverse name: ", x$name, "\n", sep = "")
    if (x$terms_apply == "true") {
        cat("Terms of Use:   ", x$terms_of_use, "\n", sep = "")
    }
    cat("SWORD URL:      ", x$url, "\n\n", sep = "")
    invisible(x)
}

#' @title List datasets (SWORD)
#' @description List datasets in a SWORD (possibly unpublished) Dataverse
#' @details This function is used to list datasets in a given Dataverse. It is part of the SWORD API, which is used to upload data to a Dataverse server. This means this can be used to view unpublished Dataverses and Datasets.
#' @param dataverse An object of class \dQuote{sword_collection}, as returned by \code{\link{service_document}}.
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#' @examples
#' \dontrun{
#' # retrieve your service document
#' d <- service_document()
#' 
#' # list available datasets in first dataverse
#' list_datasets(d[[2]])
#' }
#' @export
list_datasets <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(dataverse, "sword_collection")) {
        u <- dataverse$url
    } else {
        if (inherits(dataverse, "dataverse")) {
            dataverse <- x$alias
        }
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/collection/dataverse/", dataverse)
    }
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(r$content))
    # clean up response structure
    #for (i in which(names(out) == "entry")) {
        #class(out[[i]]) <- "dataverse_dataset"
    #}    
    structure(out, class = "dataverse_dataset_list")
}

#' @title Publish Dataverse (SWORD)
#' @description Publish/re-publish a Dataverse via SWORD
#' @details This function is used to publish a (possibly already published) Dataverse. It is part of the SWORD API, which is used to upload data to a Dataverse server.
#' @param dataverse An object of class \dQuote{sword_collection}, as returned by \code{\link{service_document}}.
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#' @export
publish_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(dataverse, "sword_collection")) {
        u <- sub("/collection/", "/edit/", dataverse$url, fixed = TRUE)
    } else {
        if (inherits(dataverse, "dataverse")) {
            dataverse <- x$alias
        }
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit/dataverse/", dataverse)
    }
    r <- httr::POST(u, httr::authenticate(key, ""), httr::add_headers("In-Progress" = "false"), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    # clean up response structure
    out
}
