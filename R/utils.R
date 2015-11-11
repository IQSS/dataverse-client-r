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
    cat("Dataverse:   ", x$alias, "\n", sep = "")
    cat("ID:          ", x$id, "\n", sep = "")
    cat("Name:        ", x$name, "\n", sep = "")
    cat("Description: ", x$description, "\n", sep = "")
    cat("Created:     ", x$creationDate, "\n", sep = "")
    cat("Creator:     ", x$creator$identifier, "\n", sep = "")
    invisible(x)
}



# dataverse_dataset class

dataset_id <- function(x, ...) {
    UseMethod('dataset_id', x)
}
dataset_id.default <- function(x, ...) {
    x
}
dataset_id.dataverse_dataset <- function(x, ...) {
    x$id
}

print.dataverse_dataset <- function(x, ...) {
    cat("Dataset (", x$id, "): ", x$persistentUrl, "\n", sep = "")
    cat("Version: ", x$latestVersion$versionNumber, ".", x$latestVersion$versionNumber, "\n", sep = "")
    cat("Version State: ", x$latestVersion$versionState, "\n", sep = "")
    cat("Release Date: ", x$latestVersion$releaseTime, "\n", sep = "")
    n <- nrow(x$latestVersion$files)
    cat(n, ngettext(n, " File:", " Files:"), "\n", sep = "")
    print(x$latestVersion$files)
    cat("\n")
    invisible(x)    
}


# dataverse_file class

print.dataverse_file <- function(x, ...) {
    cat("File (", x$dataFile$id, "): ", x$dataFile$filename, "\n", sep = "")
    cat("MD5: ", x$dataFile$md5, "\n", sep = "")
    cat("Description: ", x$dataFile$description, "\n\n", sep = "")
    invisible(x)
}

