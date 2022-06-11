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
    on.exit(file.remove(tmpdf), add = TRUE)
    tmp <- tempfile(fileext = ".zip")
    save(x, file = tmpdf)
    stopifnot(!utils::zip(tmp, tmpdf))
    return(tmp)
}
create_zip.list <- function(x, ...) {
    tmpdf <- sapply(seq_along(x), tempfile(fileext = ".zip"))
    on.exit(file.remove(tmpdf), add = TRUE)
    mapply(x, tmpdf, function(x, f) save(x, file = f), SIMPLIFY = TRUE)
    tmp <- tempfile(fileext = ".zip")
    stopifnot(!utils::zip(tmp, tmpdf))
    return(tmp)
}

#' @title Add file (SWORD)
#' @description Add one or more files to a SWORD (possibly unpublished) dataset
#' @details This function is used to add files to a dataset. It is part of the SWORD API, which is used to upload data to a Dataverse server. This means this can be used to view unpublished Dataverses and Datasets.
#'
#' As of Dataverse v4.6.1, the \dQuote{native} API also provides endpoints to add and update files without going through the SWORD workflow. This functionality is provided by \code{\link{add_dataset_file}} and \code{\link{update_dataset_file}}.
#'
#' @param dataset A dataset DOI (or other persistent identifier), an object of class \dQuote{dataset_atom} or \dQuote{dataset_statement}, or an appropriate and complete SWORD URL.
#' @param file A character vector of file names, a data.frame, or a list of R objects.
#' @template envvars
#' @template dots
#' @return An object of class \dQuote{dataset_atom}.
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
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
#' # create the dataset
#' dat <- initiate_sword_dataset("mydataverse", body = metadat)
#'
#' # add files to dataset
#' tmp <- tempfile()
#' write.csv(iris, file = tmp)
#' f <- add_file(dat, file = tmp)
#'
#' # publish dataset
#' publish_dataset(dat)
#'
#' # delete a dataset
#' delete_dataset(dat)
#' }
#' @export
add_file <- function(dataset, file, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(dataset, "dataset_atom")) {
        u <- dataset$links[["edit-media"]]
    } else if (inherits(dataset, "dataset_statement")) {
        dataset <- prepend_doi(dataset$id)
        u <- paste0(api_url(server, prefix = "dvn/api/"), "data-deposit/v1.1/swordv2/edit-media/study/", dataset)
    } else if (is.character(dataset) && grepl("^http", dataset)) {
        if (grepl("edit-media/study/", dataset)) {
            u <- dataset
        } else {
            stop("'dataset' not recognized.")
        }
    } else {
        dataset <- prepend_doi(dataset)
        u <- paste0(api_url(server, prefix = "dvn/api/"), "data-deposit/v1.1/swordv2/edit/study/", dataset)
    }

    # file can be: a character vector of file names, a data.frame, or a list of R objects
    file <- create_zip(file)

    h <- httr::add_headers("Content-Disposition" = paste0("filename=", file),
                           "Content-Type" = "application/zip",
                           "Packaging" = "http://purl.org/net/sword/package/SimpleZip")
    r <- httr::POST(u, httr::authenticate(key, ""), h, body = httr::upload_file(file), ...)
    httr::stop_for_status(r, task = httr::content(r)$message)
    parse_atom(httr::content(r, as = "text", encoding = "UTF-8"))
}

#' @title Delete file (SWORD)
#' @description Delete a file from a SWORD (possibly unpublished) dataset
#' @details This function is used to delete a file from a dataset by its file ID. It is part of the SWORD API, which is used to upload data to a Dataverse server.
#' @param id A file ID, possibly returned by \code{\link{add_file}}, or a complete \dQuote{edit-media/file} URL.
#' @template envvars
#' @template dots
#' @return If successful, a logical \code{TRUE}, else possibly some information.
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
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
#' # create the dataset
#' dat <- initiate_sword_dataset("mydataverse", body = metadat)
#'
#' # add files to dataset
#' tmp <- tempfile()
#' write.csv(iris, file = tmp)
#' f <- add_file(dat, file = tmp)
#'
#' # delete a file
#' ds <- dataset_statement(dat)
#' delete_file(ds$files[[1]]$id)
#'
#' # delete a dataset
#' delete_dataset(dat)
#' }
#' @export
delete_file <- function(id, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (grepl("^http", id)) {
        u <- id
    } else {
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit-media/file/", id)
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
