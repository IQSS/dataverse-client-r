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

#' @title Add file (SWORD)
#' @description Add one or more files to a SWORD (possibly unpublished) dataset
#' @details This function is used to add files to a dataset. It is part of the SWORD API, which is used to upload data to a Dataverse server. This means this can be used to view unpublished Dataverses and Datasets.
#' @param dataset A dataset DOI (or other persistent identifier).
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#' @examples
#' \dontrun{
#' # retrieve your service document
#' d <- service_document()
#' 
#' # create a list of metadata
#' metadat <- list(title = "My Study",
#'                 creator = "Doe, John",
#'                 creator = "Doe, Jane",
#'                 publisher = "My University",
#'                 date = "2013-09-22",
#'                 description = "An example study",
#'                 subject = "Study",
#'                 subject = "Dataverse",
#'                 subject = "Other",
#'                 coverage = "United States")
#' # create the dataset
#' dat <- initiate_dataset("mydataverse", body = metadat)
#'
#' # add files to dataset
#' tmp <- tempfile()
#' write.csv(iris, file = tmp)
#' add_file(dat, file = tmp)
#'
#' # publish dataset
#' publish_dataset(dat)
#' }
#' @export
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

#' @title Delete file (SWORD)
#' @description Delete a file from a SWORD (possibly unpublished) dataset
#' @details This function is used to delete a file from a dataset by its file ID. It is part of the SWORD API, which is used to upload data to a Dataverse server.
#' @param dataset A dataset DOI (or other persistent identifier).
#' @param id A file ID, possibly returned by \code{\link{add_file}}.
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#' @examples
#' \dontrun{
#' # retrieve your service document
#' d <- service_document()
#' 
#' # view contents of a dataset
#' s <- dataset_statement(d[[2]])
#' 
#' # delete a file
#' 
#' }
#' @export
delete_file <- function(dataset, id, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataset <- prepend_doi(dataset)
    u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit-media/file/", id)
    r <- httr::DELETE(u, httr::authenticate(key, ""), h, ...)
    httr::stop_for_status(r)
    httr::content(r, "text")
}
