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
    xmllist <- xml2::as_list(xml2::read_xml(xml))
    out <- list()
    out$id <- strsplit(xmllist$id[[1L]], "doi:", fixed = TRUE)[[1L]][2]
    out$edit_url <- xmllist$id[[1L]]
    out$title <- xmllist$title[[1L]]
    out$author <- unname(unlist(xmllist$author))
    out$updated <- xmllist[["updated"]][[1L]]
    if (any(names(xmllist) == "entry")) {
        out$files <- list()
        for (i in which(names(xmllist) == "entry")) {
            out$files[[length(out$files) + 1]] <- 
                list(id = regmatches(xmllist[[i]]$id[[1L]], regexpr("(?<=file/).+(?=/)", xmllist[[i]]$id[[1L]], perl = TRUE)),
                     url = xmllist[[i]]$id[[1L]], 
                     title = xmllist[[i]]$title[[1L]],
                     summary = xmllist[[i]]$summary[[1L]],
                     updated = xmllist[[i]]$updated[[1L]])
        }
    }
    for (i in which(names(xmllist) == "category")) {
        tmp <- xmllist[[i]][[1L]]
        if (tolower(tmp) %in% c("true", "false")) {
            tmp <- as.logical(tmp)
        }
        out[[unname(attributes(xmllist[[i]])[["term"]])]] <- tmp
        
    }
    structure(out, class = "dataset_statement")
}
