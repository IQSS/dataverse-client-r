#' @export
print.dataset_statement <- function(x, ...) {
    cat("Dataset:            ", x$title, "\n")
    cat("id:                 ", x$id, "\n")
    if (length(x$author) > 1) {
        cat("authors:\n", paste0(" ", x$author, collapse = "\n"), "\n")
    } else if (length(x$author) == 1) {
        cat("author:             ", x$author, "\n")
    }
    cat("files:              ", length(x$files), "\n")
    cat("updated:            ", format(strptime(x$updated, "%FT%H:%M:%OS")), "\n")
    cat("latestVersionState: ", x$latestVersionState, "\n")
    cat("locked:             ", x$locked, "\n")
    cat("isMinorUpdate:      ", x$isMinorUpdate, "\n\n")
    invisible(x)
}

parse_dataset_statement <- function(xml) {
    xmllist <- XML::xmlToList(xml)
    out <- list()
    out$id <- strsplit(xmllist$id, "doi:", fixed = TRUE)[[1]][2]
    out$edit_url <- xmllist$id
    out$title <- xmllist$title$text
    out$author <- unlist(xmllist$author)
    out$updated <- xmllist[["updated"]]
    if (any(names(xmllist) == "entry")) {
        out$files <- list()
        for (i in which(names(xmllist) == "entry")) {
            out$files[[length(out$files) + 1]] <- 
                list(id = regmatches(xmllist[[i]]$id, regexpr("(?<=file/).+(?=/)", xmllist[[i]]$id, perl = TRUE)),
                     url = xmllist[[i]]$id, 
                     title = xmllist[[i]]$title$text,
                     summary = xmllist[[i]]$summary$text,
                     updated = xmllist[[i]]$updated)
        }
    }
    for (i in which(names(xmllist) == "category")) {
        tmp <- xmllist[[i]]$text
        if (tolower(tmp) %in% c("true", "false")) {
            tmp <- as.logical(tmp)
        }
        out[[unname(xmllist[[i]][[".attrs"]]["term"])]] <- tmp
        
    }
    structure(out, class = "dataset_statement")
}
