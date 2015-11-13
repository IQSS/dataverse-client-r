#' @title Download File(s)
#' @description Download Dataverse File(s)
#' @details This function provides access to data files from a Dataverse entry.
#' @param file An integer specifying a file identifier or, if \code{doi} is specified, a character string specifying a file name within the DOI-identified dataset.
#' @param doi If a DOI (or handle) is supplied, then \code{file} can simply be the filename rather than Dataverse file ID number.
#' @param format A character string specifying a file format. By default, this is \dQuote{original} (the original file format). If \dQuote{RData} or \dQuote{prep} is used, an alternative is returned. If \dQuote{bundle}, a compressed directory containing a bundle of file formats is returned.
#' @param vars A character vector specifying one or more variable names, used to extract a subset of the data.
#' @template envvars
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}.
#' @return A list.
#' @examples
#' \dontrun{}
#' @export
dataverse_file <- 
function(file, 
         doi = NULL,
         format = c("original", "RData", "prep", "bundle"),
         # thumb = TRUE,
         vars = NULL,
         key = Sys.getenv("DATAVERSE_KEY"), 
         server = Sys.getenv("DATAVERSE_SERVER"), 
         ...) {
    
    server <- urltools::url_parse(server)$domain
    format <- match.arg(format)
    
    # from doi, get SWORD dataset statement, then get file ID
    if (!is.null(doi)) {
        file <- (function(doi, filename, ...) {
            ds <- dataset_statement(doi)
            filelist <- ds[names(ds) == "entry"]
            furl <- sapply(filelist, function(x) {x[["id"]][[1]]})
            furl2 <- sapply(strsplit(urltools::url_parse(furl)$path, "edit-media/file/"), `[`, 2)
            furl3 <- strsplit(furl2, "/")
            filelist2 <- setNames(sapply(furl3, `[`, 1), sapply(furl3, function(x) x[length(x)]))
            fileid <- filelist2[names(filelist2) == filename]
            fileid
        })(doi, file)
    }
    
    if (length(file) > 1) {
        file <- paste0(file, collapse = ",")
        u <- paste0("https://", server, "/api/access/datafiles/", file)
        r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
        httr::stop_for_status(r)
        r
    } else {
        if (format == "bundle") {
            u <- paste0("https://", server, "/api/access/datafile/bundle/", file)
            r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
        } else {
            u <- paste0("https://", server, "/api/access/datafile/", file)
            query <- list()
            if (!is.null(vars)) {
                query$vars <- paste0(vars, collapse = ",")
            } 
            if (!is.null(format)) {
                query$format <- match.arg(format)
            }
            
            # request
            if (length(query)) {
                r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), query = query, ...)
            } else {
                r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
            }
        }
        
        httr::stop_for_status(r)
        r
    }
}

#' @export
get_metadata <- 
function(file, 
         format = c("ddi", "preprocessed"),
         key = Sys.getenv("DATAVERSE_KEY"), 
         server = Sys.getenv("DATAVERSE_SERVER"), 
         ...) {
    format <- match.arg(format)
    u <- paste0("https://", server, "/api/access/datafile/", file, "/metadata/", format)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    r
}


# UNF functions to validate dataset against Dataverse metadata

