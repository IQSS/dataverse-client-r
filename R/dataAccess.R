#' @rdname files
#' @title Download File(s)
#' @description Download Dataverse File(s)
#' @details This function provides access to data files from a Dataverse entry.
#' @param file An integer specifying a file identifier or, if \code{doi} is specified, a character string specifying a file name within the DOI-identified dataset.
#' @param doi If a DOI (or handle) is supplied, then \code{file} can simply be the filename rather than Dataverse file ID number.
#' @param format A character string specifying a file format. By default, this is \dQuote{original} (the original file format). If \dQuote{RData} or \dQuote{prep} is used, an alternative is returned. If \dQuote{bundle}, a compressed directory containing a bundle of file formats is returned.
#' @param vars A character vector specifying one or more variable names, used to extract a subset of the data.
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' # download file from: 
#' # https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/ARKOTI
#' monogan <- get_dataverse("monogan")
#' monogan_data <- dataverse_contents(monogan)
#' d1 <- get_dataset(monogan_data[[1]])
#' f <- dataverse_file(d1$files$datafile$id[3])
#'
#' # read file as data.frame
#' if (require("rio")) {
#'   tmp <- tempfile(fileext = ".dta")
#'   writeBin(f, tmp)
#'   str(dat <- rio::import(tmp, haven = FALSE))
#'
#'   # check UNF match
#'   #if (require("UNF")) {
#'   #  unf(dat) %unf% d1$files$datafile$UNF[3]
#'   #}
#' }
#' }
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
    
    format <- match.arg(format)
    
    # from doi, get SWORD dataset statement, then get file ID
    if (!is.null(doi)) {
        file <- (function(doi, filename, ...) {
            ds <- try(dataset_statement(doi), silent = TRUE)
            if (inherits(ds, "try-error")) {
                stop("File not accessible via DOI.")
            }
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
        u <- paste0(api_url(server), "access/datafiles/", file)
        r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
        httr::stop_for_status(r)
        r
    } else {
        if (format == "bundle") {
            u <- paste0(api_url(server), "access/datafile/bundle/", file)
            r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
        } else {
            u <- paste0(api_url(server), "access/datafile/", file)
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
        httr::content(r, as = "raw")
    }
}

#' @rdname files
#' @export
get_metadata <- 
function(file, 
         format = c("ddi", "preprocessed"),
         key = Sys.getenv("DATAVERSE_KEY"), 
         server = Sys.getenv("DATAVERSE_SERVER"), 
         ...) {
    format <- match.arg(format)
    u <- paste0(api_url(server), "access/datafile/", file, "/metadata/", format)
    r <- httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...)
    httr::stop_for_status(r)
    r
}


# UNF functions to validate dataset against Dataverse metadata
