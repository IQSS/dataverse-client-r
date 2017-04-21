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
    } else if (inherits(dataverse, "dataverse")) {
        dataverse <- dataverse$alias
        u <- paste0(api_url(server, prefix="dvn/api/"), "data-deposit/v1.1/swordv2/edit/dataverse/", dataverse)
    } else {
        # publish via native API
        dataverse <- dataverse_id(dataverse)
        u <- paste0(api_url(server), "dataverses/", dataverse, "/actions/:publish")
        r <- httr::POST(u, httr::add_headers("X-Dataverse-key" = key), ...)
        httr::stop_for_status(r)
        return(httr::content(r)$data)
    }
    # publish via sword API
    r <- httr::POST(u, httr::authenticate(key, ""), httr::add_headers("In-Progress" = "false"), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, as = "text", encoding = "UTF-8")))
    # clean up response structure
    out
}
