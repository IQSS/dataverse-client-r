print.dataset_atom <- function(x, ...) {
    cat("ID: ", x$id, "\n", sep = "")
    cat("Generator: ", paste0(x$generator, collapse = " "), "\n", sep = "")
    cat("Treatment: ", x$treatment, "\n", sep = "")
    cat("Links:\n")
    for (i in seq_along(x$links)) {
        cat(" ", formatC(names(dat2$links))[i], ": ", unname(x$links[[i]]), "\n", sep = "")
    }
    cat("Citation: ", x$bibliographicCitation, "\n\n")
    invisible(x)
}

parse_atom <- function(xml){
    xmllist <- XML::xmlToList(xml)
    links <- lapply(xmllist[names(xmllist) == "link"], function(x) as.vector(x[1]))
    links <- setNames(links, sapply(xmllist[names(xmllist) == "link"], `[`, 2))
    names(links)[grep("statement$", names(links))] <- "statement"
    names(links)[grep("add$", names(links))] <- "add"
    xmlout <- list(id = xmllist$id,
                   links = links,
                   bibliographicCitation = xmllist$bibliographicCitation,
                   generator = xmllist$generator,
                   treatment = xmllist$treatment[[1]])
    xmlout$xml <- xml
    structure(xmlout, class = "dataset_atom")
}
