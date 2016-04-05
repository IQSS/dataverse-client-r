# dataverse_id method
dataverse_id <- function(x, ...) {
    UseMethod('dataverse_id', x)
}
dataverse_id.default <- function(x, ...) {
    x
}
dataverse_id.dataverse <- function(x, ...) {
    x$id
}

# dataset_id method
dataset_id <- function(x, ...) {
    UseMethod('dataset_id', x)
}
dataset_id.default <- function(x, ...) {
    x
}
dataset_id.character <- function(x, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    x <- prepend_doi(x)
    u <- paste0(api_url(server), "datasets/:persistentId?persistentId=", x)
    r <- tryCatch(httr::GET(u, httr::add_headers("X-Dataverse-key" = key), ...),
                  error = function(e) {
                    stop("Could not retrieve Dataset ID from persistent identifier!")
                  })
    jsonlite::fromJSON(httr::content(r, as = "text", encoding = "UTF-8"))[["data"]][["id"]]
}
dataset_id.dataverse_dataset <- function(x, ...) {
    x$id
}

# get fileid from a dataset DOI or dataset ID
get_fileid <- function(x, ...) {
    UseMethod('get_fileid', x)
}

get_fileid.numeric <- function(x, file, key, server, ...) {
    files <- dataset_files(x, key = key, server = server, ...)
    ids <- unlist(lapply(files, function(x) x[["datafile"]][["id"]]))
    if (is.numeric(file)) {
        w <- which(ids %in% file)
        if (!length(w)) {
            stop("File not found")
        }
        id <- ids[w]
    } else {
        ns <- unlist(lapply(files, `[[`, "label"))
        w <- which(ns %in% file)
        if (!length(w)) {
            stop("File not found")
        }
        id <- ids[w]
    }
    id
}

get_fileid.character <- function(x, file, key, server, ...) {
    files <- dataset_files(prepend_doi(x), key = key, server = server, ...)
    ids <- unlist(lapply(files, function(x) x[["datafile"]][["id"]]))
    if (is.numeric(file)) {
        w <- which(ids %in% file)
        if (!length(w)) {
            stop("File not found")
        }
        id <- ids[w]
    } else {
        ns <- unlist(lapply(files, `[[`, "label"))
        w <- which(ns %in% file)
        if (!length(w)) {
            stop("File not found")
        }
        id <- ids[w]
    }
    id
}

get_fileid.dataverse_file <- function(x, file, key, server, ...) {
    x[["datafile"]][["id"]]
}

# other functions
prepend_doi <- function(dataset) {
    if (grepl("^hdl", dataset)) {
        return(dataset)
    }
    if (!grepl("^doi:", dataset)) {
        dataset <- paste0("doi:", dataset)
    } else if (grepl("^DOI:", dataset)) {
        dataset <- paste0("doi:", strsplit(dataset, "DOI:", fixed = TRUE)[[1]][2])
    } else if (grepl("dx\\.doi\\.org", dataset)) {
        dataset <- paste0("doi:", httr::parse_url(dataset)$path)
    }
    # need to check if it is a handle, and issue warning
    dataset
}

api_url <- function(server, prefix="api/") {
    if (is.null(server) || server == "") {
        stop("'server' is missing with no default set in DATAVERSE_SERVER environment variable.")
    }
    server <- urltools::url_parse(server)
    if(server$port == "") {
        domain <- server$domain
    } else {
        domain <- paste0(server$domain, ":", server$port)
    }
    url <- paste0("https://", domain, "/", prefix)
    return(url)
}

