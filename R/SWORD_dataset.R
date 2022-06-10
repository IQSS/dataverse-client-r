#' @title Initiate dataset (SWORD)
#' @description Initiate a SWORD (possibly unpublished) dataset
#' @param dataverse A Dataverse alias or ID number, or an object of class \dQuote{dataverse}, perhaps as returned by \code{\link{service_document}}.
#' @param body A list containing one or more metadata fields. Field names must be valid Dublin Core Terms labels (see details, below). The \samp{title}, \samp{description}, and \samp{creator} fields are required.
#' @template envvars
#' @template dots
#' @details This function is used to initiate a dataset in a (SWORD) Dataverse by supplying relevant metadata. The function is part of the SWORD API (see \href{https://www.ietf.org/rfc/rfc5023.txt}{Atom entry specification}), which is used to upload data to a Dataverse server.
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
#' @return An object of class \dQuote{dataset_atom}.
#' @note There are two ways to create dataset: native API (\code{\link{create_dataset}}) and SWORD API (\code{initiate_sword_dataset}).
#' @references \href{http://dublincore.org/documents/dcmi-terms/}{Dublin Core Metadata Terms}
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_sword_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#' @examples
#' \dontrun{
#' # retrieve your service document (dataverse list)
#' d <- service_document()
#'
#' # create a list of metadata
#' metadat <- list(title = "My Study",
#'                 creator = "Doe, John",
#'                 description = "An example study")
#'
#' # create the dataset in first dataverse
#' dat <- initiate_sword_dataset(d[[2]], body = metadat)
#'
#' # add files to dataset
#' tmp <- tempfile(fileext = ".csv")
#' write.csv(iris, file = tmp)
#' add_file(dat, file = tmp)
#'
#' # publish dataset
#' publish_dataset(dat)
#' }
#' @export
initiate_sword_dataset <- function(dataverse, body, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(dataverse, "dataverse")) {
        dataverse <- dataverse$alias
    } else if (is.numeric(dataverse)) {
        dataverse <- get_dataverse(dataverse)$alias
    }
    u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/collection/dataverse/", dataverse)
    if (is.character(body) && file.exists(body)) {
        b <- httr::upload_file(body)
    } else {
        b <- do.call("build_metadata", c(body, metadata_format = "dcterms"))
    }
    r <- httr::POST(u, httr::authenticate(key, ""), httr::add_headers("Content-Type" = "application/atom+xml"), body = b, ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    structure(parse_atom(httr::content(r, as = "text", encoding = "UTF-8")))
}

#' @title Delete dataset (SWORD)
#' @description Delete a SWORD (possibly unpublished) dataset
#' @details This function is used to delete a dataset by its persistent identifier. It is part of the SWORD API, which is used to upload data to a Dataverse server.
#' @param dataset A dataset DOI (or other persistent identifier).
#' @template envvars
#' @template dots
#' @return If successful, a logical \code{TRUE}, else possibly some information.
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#' @examples
#' \dontrun{
#' # retrieve your service document
#' d <- service_document()
#'
#' # create a list of metadata
#' metadat <- list(title = "My Study",
#'                 creator = "Doe, John",
#'                 description = "An example study")
#'
#' # create the dataset in first dataverse
#' dat <- initiate_sword_dataset(d[[2]], body = metadat)
#'
#' # delete a dataset
#' delete_dataset(dat)
#' }
#' @export
delete_sword_dataset <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(dataset, "dataset_atom")) {
        u <- dataset$links[["edit"]]
    } else if (inherits(dataset, "dataset_statement")) {
        dataset <- prepend_doi(dataset$id)
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit/study/", dataset)
    } else if (is.character(dataset) && grepl("^http", dataset)) {
        if (grepl("edit/study/", dataset)) {
            u <- dataset
        } else {
            stop("'dataset' not recognized.")
        }
    } else {
        dataset <- prepend_doi(dataset)
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit/study/", dataset)
    }

    r <- httr::DELETE(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    cont <- httr::content(r, as = "text", encoding = "UTF-8")
    if (cont == "") {
        return(TRUE)
    } else {
        return(cont)
    }
}

#' @title Publish dataset (SWORD)
#' @description Publish a SWORD (possibly unpublished) dataset
#' @details This function is used to publish a dataset by its persistent identifier. This cannot be undone. The function is part of the SWORD API, which is used to upload data to a Dataverse server.
#' @param dataset A dataset DOI (or other persistent identifier), an object of class \dQuote{dataset_atom} or \dQuote{dataset_statement}, or an appropriate and complete SWORD URL.
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_sword_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#' @examples
#' \dontrun{
#' # retrieve your service document
#' d <- service_document()
#'
#' # create a list of metadata
#' metadat <- list(title = "My Study",
#'                 creator = "Doe, John",
#'                 description = "An example study")
#'
#' # create the dataset in first dataverse
#' dat <- initiate_sword_dataset(d[[2]], body = metadat)
#'
#' # publish dataset
#' publish_sword_dataset(dat)
#'
#' # delete a dataset
#' delete_dataset(dat)
#' }
#' @export
publish_sword_dataset <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(dataset, "dataset_atom")) {
        u <- dataset$links[["edit"]]
    } else if (inherits(dataset, "dataset_statement")) {
        dataset <- prepend_doi(dataset$id)
        u <- paste0(api_url(server, prefix = "dvn/api/"), "data-deposit/v1.1/swordv2/edit/study/", dataset)
    } else if (is.character(dataset) && grepl("^http", dataset)) {
        if (grepl("edit/study/", dataset)) {
            u <- dataset
        } else {
            stop("'dataset' not recognized.")
        }
    } else {
        dataset <- prepend_doi(dataset)
        u <- paste0(api_url(server, prefix = "dvn/api/"), "data-deposit/v1.1/swordv2/edit/study/", dataset)
    }

    r <- httr::POST(u, httr::authenticate(key, ""), httr::add_headers("In-Progress" = "false"), ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, as = "text", encoding = "UTF-8")))
    out
}

#' @rdname dataset_atom
#' @title View dataset (SWORD)
#' @description View a SWORD (possibly unpublished) dataset \dQuote{statement}
#' @details These functions are used to view a dataset by its persistent identifier. \code{dataset_statement} will contain information about the contents of the dataset, whereas \code{dataset_atom} contains \dQuote{metadata} relevant to the SWORD API.
#' @param dataset A dataset DOI (or other persistent identifier), an object of class \dQuote{dataset_atom} or \dQuote{dataset_statement}, or an appropriate and complete SWORD URL.
#' @template envvars
#' @template dots
#' @return A list. For \code{dataset_atom}, an object of class \dQuote{dataset_atom}.
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_sword_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#' @examples
#' \dontrun{
#' # retrieve your service document
#' d <- service_document()
#'
#' # retrieve dataset statement (list contents)
#' dataset_statement(d[[2]])
#'
#' # retrieve dataset atom
#' dataset_atom(d[[2]])
#' }
#' @export
dataset_atom <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(dataset, "dataset_atom")) {
        u <- dataset$links[["edit"]]
    } else if (inherits(dataset, "dataset_statement")) {
        dataset <- prepend_doi(dataset$id)
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit/study/", dataset)
    } else if (is.character(dataset) && grepl("^http", dataset)) {
        if (grepl("edit/study/", dataset)) {
            u <- dataset
        } else {
            stop("'dataset' not recognized.")
        }
    } else {
        dataset <- prepend_doi(dataset)
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit/study/", dataset)
    }

    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    out <- parse_atom(rawToChar(r$content))
    out
}

#' @rdname dataset_atom
#' @export
dataset_statement <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(dataset, "dataset_atom")) {
        u <- dataset$links[["statement"]]
    } else if (inherits(dataset, "dataset_statement")) {
        dataset <- prepend_doi(dataset$id)
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/statement/study/", dataset)
    } else if (is.character(dataset) && grepl("^http", dataset)) {
        if (grepl("statement/study/", dataset)) {
            u <- dataset
        } else {
            stop("'dataset' not recognized.")
        }
    } else {
        dataset <- prepend_doi(dataset)
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/statement/study/", dataset)
    }
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    parse_dataset_statement(rawToChar(r$content))
}
