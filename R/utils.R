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
#dataset_id.character <- function(x, ...) {
    # parse DOI to dataset ID using SWORD API, possibly
#}
dataset_id.dataverse_dataset <- function(x, ...) {
    x$id
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
