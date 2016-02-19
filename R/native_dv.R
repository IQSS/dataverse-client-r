#' @title Get Dataverse
#' @description Retrieve details of a Dataverse
#' @details This function retrieves a Dataverse from a Dataverse server. To see the contents of the Dataverse, use \code{\link{dataverse_contents}} instead.
#' @template dv 
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{dataverse}.
#' @seealso To manage Dataverses: \code{\link{create_dataverse}}, \code{\link{delete_dataverse}}, \code{\link{publish_dataverse}}, \code{\link{dataverse_contents}}; to get datasets: \code{\link{get_dataset}}; to search for Dataverses, datasets, or files: \code{\link{dataverse_search}}
#' @examples
#' \dontrun{
#' # download file from: 
#' # https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/ARKOTI
#' monogan <- get_dataverse("monogan")
#' monogan_data <- dataverse_contents(monogan)
#' d1 <- get_dataset(monogan_data[[1]])
#' f <- dataverse_file(d1$files$datafile$id[3])
#' 
#' }
#' @export
get_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"))
    structure(out$data, class = "dataverse")
}

#' @title List contents
#' @description List the contents of a Dataverse
#' @details This function lists the contents of a Dataverse. Contents might include one or more \dQuote{datasets} and/or further Dataverses that themselves contain Dataverses and/or datasets. To view the file contents of a single Dataset, use \code{\link{get_dataset}}.
#' @template dv
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{dataverse_contents}
#' @seealso To manage Dataverses: \code{\link{create_dataverse}}, \code{\link{delete_dataverse}}, \code{\link{publish_dataverse}}; to get datasets: \code{\link{get_dataset}}; to search for Dataverses, datasets, or files: \code{\link{dataverse_search}}
#' @examples
#' \dontrun{
#' # download file from: 
#' # https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/ARKOTI
#' monogan <- get_dataverse("monogan")
#' monogan_data <- dataverse_contents(monogan)
#' d1 <- get_dataset(monogan_data[[1]])
#' f <- dataverse_file(d1$files$datafile$id[3])
#' 
#' }
#' @export
dataverse_contents <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/contents")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    out <- jsonlite::fromJSON(httr::content(r, "text"), simplifyDataFrame = FALSE)
    structure(lapply(out$data, function(x) {
        `class<-`(x, if (x$type == "dataset") "dataverse_dataset" else "dataverse")
    }), class = "dataverse_contents")
}

#' @title Get Dataverse facets
#' @description Dataverse metadata facets
#' @details Retrieve a list of Dataverse metadata facets.
#' @template dv
#' @template envvars
#' @template dots
#' @return A list.
#' @seealso To manage Dataverses: \code{\link{create_dataverse}},  \code{\link{delete_dataverse}}, \code{\link{publish_dataverse}}, \code{\link{dataverse_contents}}; to get datasets: \code{\link{get_dataset}}; to search for Dataverses, datasets, or files: \code{\link{dataverse_search}}
#' @examples
#' \dontrun{
#' 
#' }
#' @export
get_facets <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/facets")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)$data
}

#' @title Dataverse metadata
#' @description Get metadata for a named Dataverse.
#' @details This function returns a list of metadata for a named Dataverse. Use \code{\link{dataverse_contents}} to list Dataverses and/or datasets contained within a Dataverse or use \code{\link{dataset_metadata}} to get metadata for a specific dataset.
#' @template dv
#' @template envvars
#' @template dots
#' @return A list
#' @seealso \code{\link{set_dataverse_metadata}}
#' @examples
#' \dontrun{
#' # download file from: 
#' # https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/ARKOTI
#' monogan <- get_dataverse("monogan")
#' monogan_data <- dataverse_contents(monogan)
#' dataverse_metadata(monogan)
#' 
#' d1 <- get_dataset(monogan_data[[1]])
#' f <- dataverse_file(d1$files$datafile$id[3])
#' 
#' }
#' @export
dataverse_metadata <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/metadatablocks")
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    httr::content(r)$data
}
