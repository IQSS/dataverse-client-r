# dataverse class

dataverse_id <- function(x, ...) {
    UseMethod('dataverse_id', x)
}
dataverse_id.default <- function(x, ...) {
    x
}
dataverse_id.dataverse <- function(x, ...) {
    x$id
}

print.dataverse <- function(x, ...) {
    cat("Dataverse (", x$id, "): ", x$alias, "\n", sep = "")
    cat("Name:        ", x$name, "\n", sep = "")
    cat("Description: ", x$description, "\n", sep = "")
    cat("Created:     ", x$creationDate, "\n", sep = "")
    cat("Creator:     ", x$creator$identifier, "\n", sep = "")
    invisible(x)
}



# dataverse_dataset class

prepend_doi <- function(dataset) {
    if (grepl("^hdl", dataset)) {
        return(dataset)
    }
    if (!grepl("^doi:", dataset)) {
        dataset <- paste0("doi:", dataset)
    } else if (grepl("^DOI:", dataset)) {
        dataset <- paste0("doi:", strsplit(dataset, "DOI:", fixed = TRUE)[[1]][2])
    }
    # check if it is a complete doi URL
    # check if it is a handle, and issue warning
    dataset
}

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

print.dataverse_dataset <- function(x, ...) {
    cat("Dataset (", x$id, "): ", x$persistentUrl, "\n", sep = "")
    if ("latestVersion" %in% names(x)) {
        print(x$latestVersion)
    } else {
        cat("Version (", x$id, ")", sep = "")
        if ("versionNumber" %in% names(x)) {
            cat(": ", x$versionNumber, ".", x$versionMinorNumber, ", ", x$versionState, "\n", sep = "")
        } else {
            cat("\n")
        }
        if ("releaseTime" %in% names(x)) {
            cat("Release Date: ", x$releaseTime, "\n", sep = "")
        }
        if ("files" %in% names(x)) {
            n <- length(x$files)
            cat(n, ngettext(n, " File:", " Files:"), "\n", sep = "")
            print(x$files)
        }
    }
    invisible(x)    
}

# dataverse_dataset_version class

print.dataverse_dataset_version <- function(x, ...) {
    cat("Version (", x$id, "): ", x$versionNumber, ".", x$versionMinorNumber, ", ", x$versionState, "\n", sep = "")
    cat("Release Date: ", x$releaseTime, "\n", sep = "")
    n <- length(x$files)
    cat(n, ngettext(n, " File:", " Files:"), "\n", sep = "")
    print(x$files)
    invisible(x)    
}

# dataverse_file class

print.dataverse_file <- function(x, ...) {
    cat("File (", x$datafile$id, "): ", x$datafile$filename, "\n", sep = "")
    cat("Dataset version: ", x$datasetVersionId, "\n", sep = "")
    if ("md5" %in% names(x$datafile)) {
        cat("MD5: ", x$datafile$md5, "\n", sep = "")
    }
    cat("Description: ", x$datafile$description, "\n", sep = "")
    invisible(x)
}

# other functions

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
