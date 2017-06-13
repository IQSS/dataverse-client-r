#' @export
print.dataset_atom <- function(x, ...) {
    cat("ID: ", x$id, "\n", sep = "")
    cat("Generator: ", paste0(x$generator, collapse = " "), "\n", sep = "")
    cat("Treatment: ", x$treatment, "\n", sep = "")
    cat("Links:\n")
    for (i in seq_along(x$links)) {
        cat(" ", formatC(names(x$links))[i], ": ", unname(x$links[[i]]), "\n", sep = "")
    }
    cat("Citation: ", x$bibliographicCitation, "\n\n")
    invisible(x)
}

parse_atom <- function(xml){
    xmllist <- xml2::as_list(xml2::read_xml(xml))
    links <- lapply(xmllist[names(xmllist) == "link"], attr, "href")
    names(links) <- unlist(lapply(xmllist[names(xmllist) == "link"], attr, "rel"))
    names(links)[grep("statement$", names(links))] <- "statement"
    names(links)[grep("add$", names(links))] <- "add"
    xmlout <- list(id = xmllist$id[[1L]],
                   links = links,
                   bibliographicCitation = xmllist$bibliographicCitation[[1L]],
                   generator = attributes(xmllist$generator),
                   treatment = xmllist$treatment[[1]])
    xmlout$xml <- xml
    structure(xmlout, class = "dataset_atom")
}
