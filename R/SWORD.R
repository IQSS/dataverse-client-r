
# print.dataverse_dataset_atom <- function(x, ...) {}
parse_atom <- function(xml){
    xmllist <- XML::xmlToList(xml)
    links <- lapply(xmllist[names(xmllist) == "link"], function(x) as.vector(x[1]))
    links <- setNames(links, sapply(xmllist[names(xmllist) == "link"], `[`, 2))
    xmlout <- list(id = xmllist$id,
                   links = links,
                   bibliographicCitation = xmllist$bibliographicCitation,
                   generator = xmllist$generator,
                   treatment = xmllist$treatment[[1]])
    xmlout$xml <- xml
    structure(xmlout, class = "dataverse_dataset_atom")
}


# print.dataverse_sword_collection <- function(x, ...) {}
# print.dataverse_sword_service_document <- function(x, ...) {}
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
                       class = "dataverse_sword_collection")
        out[[length(out) + 1]] <- s
    }
    out <- setNames(out, `[<-`(names(out), n, "sword_collection"))
    structure(out, class = "dataverse_sword_service_document")
}

# @param 
# @param body A list containing one or more metadata fields. Field names must be valid Dublin Core Terms labels (see details, below). The \samp{title} field is required.
#' Allowed fields are:
#' \dQuote{abstract}, \dQuote{accessRights}, \dQuote{accrualMethod},
#' \dQuote{accrualPeriodicity}, \dQuote{accrualPolicy}, \dQuote{alternative},
#' \dQuote{audience}, \dQuote{available}, \dQuote{bibliographicCitation},
#' \dQuote{conformsTo}, \dQuote{contributor}, \dQuote{coverage}, \dQuote{created},
#' \dQuote{creator}, \dQuote{date}, \dQuote{dateAccepted}, \dQuote{dateCopyrighted},
#' \dQuote{dateSubmitted}, \dQuote{description}, \dQuote{educationLevel}, \dQuote{extent},
#' \dQuote{format}, \dQuote{hasFormat}, \dQuote{hasPart}, \dQuote{hasVersion},
#' \dQuote{identifier}, \dQuote{instructionalMethod}, \dQuote{isFormatOf},
#' \dQuote{isPartOf}, \dQuote{isReferencedBy}, \dQuote{isReplacedBy}, \dQuote{isRequiredBy},
#' \dQuote{issued}, \dQuote{isVersionOf}, \dQuote{language}, \dQuote{license},
#' \dQuote{mediator}, \dQuote{medium}, \dQuote{modified}, \dQuote{provenance},
#' \dQuote{publisher}, \dQuote{references}, \dQuote{relation}, \dQuote{replaces},
#' \dQuote{requires}, \dQuote{rights}, \dQuote{rightsHolder}, \dQuote{source},
#' \dQuote{spatial}, \dQuote{subject}, \dQuote{tableOfContents}, \dQuote{temporal},
#' \dQuote{title}, \dQuote{type}, and \dQuote{valid}.
# @references \href{http://dublincore.org/documents/dcmi-terms/}{Dublin Core Metadata Terms}
# @link \href{http://swordapp.github.io/SWORDv2-Profile/SWORDProfile.html\#protocoloperations_creatingresource_entry}{Atom entry specification}
# @examples
# \dontrun{
# 
# metadat <- list(title = "My Study",
#                 creator = "Doe, John",
#                 creator = "Doe, Jane",
#                 publisher = "My University",
#                 date = "2013-09-22",
#                 description = "An example study",
#                 subject = "Study",
#                 subject = "Dataverse",
#                 subject = "Other",
#                 coverage = "United States")
# create_dataset("mydataverse", body = metadat)
# }

# note that there are two ways to create dataset: native API (`create_dataset`) and SWORD API (`initiate_dataset`)
initiate_dataset <- function(dataverse, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(dataverse, "sword_collection")) {
        u <- dataverse$url
    } else {
        if (inherits(dataverse, "dataverse")) {
            dataverse <- x$alias
        }
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/collection/dataverse/", dataverse)
    }
    if (is.character(body) && file.exists(body)) {
        b <- httr::upload_file(body)
    } else {
        b <- do.call("build_metadata", c(body, metadata_format = "dcterms", validate = FALSE))
    }
    r <- httr::POST(u, httr::authenticate(key, ""), httr::add_headers("Content-Type" = "application/atom+xml"), body = b, ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    # clean up response structure
    out
}

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
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    # clean up response structure
    out
}

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


create_zip <- function(x, ...) {
    UseMethod("create_zip", x)
}
create_zip.character <- function(x, ...) {
    f <- file.exists(x)
    if (any(!f)) {
        stop(paste0(ngettext(f, "One file does not", paste0(sum(f), " files do not"))), "exist: ", paste0(x[which(f)], collapse = ", "))
    } else {
        tmp <- tempfile(fileext = ".zip")
        stopifnot(!utils::zip(tmp, x))
        return(tmp)
    }
}
create_zip.data.frame <- function(x, ...) {
    tmpdf <- tempfile(fileext = ".zip")
    on.exit(file.remove(tmpdf))
    tmp <- tempfile(fileext = ".zip")
    save(x, file = tmpdf)
    stopifnot(!utils::zip(tmp, tmpdf))
    return(tmp)
}
create_zip.list <- function(x, ...) {
    tmpdf <- sapply(seq_along(x), tempfile(fileext = ".zip"))
    on.exit(file.remove(tmpdf))
    mapply(x, tmpdf, function(x, f) save(x, file = f), SIMPLIFY = TRUE)
    tmp <- tempfile(fileext = ".zip")
    stopifnot(!utils::zip(tmp, tmpdf))
    return(tmp)
}

add_file <- function(dataset, file, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- prepend_doi(dataset)
    u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit-media/study/", dataset)
    
    # file can be: a character vector of file names, a data.frame, or a list of R objects
    file <- create_zip(file)
    
    h <- httr::add_headers("Content-Disposition" = paste0("filename=", file), 
                           "Content-Type" = "application/zip",
                           "Packaging" = "http://purl.org/net/sword/package/SimpleZip")
    r <- httr::POST(u, httr::authenticate(key, ""), h, ...)
    httr::stop_for_status(r)
    httr::content(r, "text")
}

delete_file <- function(dataset, id, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- prepend_doi(dataset)
    u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit-media/file/", id)
    r <- httr::DELETE(u, httr::authenticate(key, ""), h, ...)
    httr::stop_for_status(r)
    httr::content(r, "text")
}

delete_dataset <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- prepend_doi(dataset)
    u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit/study/", dataset)
    r <- httr::DELETE(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    httr::content(r, "text")
}

publish_dataset <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- prepend_doi(dataset)
    u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit/study/", dataset)
    r <- httr::POST(u, httr::authenticate(key, ""), httr::add_headers("In-Progress" = "false"), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

dataset_atom <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- prepend_doi(dataset)
    u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit/study/", dataset)
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- parse_atom(httr::content(r, "text"))
    out
}

dataset_statement <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- prepend_doi(dataset)
    u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/statement/study/", dataset)
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}
