dcterms_fields <- c("abstract","accessRights","accrualMethod","accrualPeriodicity",
                    "accrualPolicy","alternative","audience","available",
                    "bibliographicCitation","conformsTo","contributor","coverage",
                    "created","creator","date","dateAccepted","dateCopyrighted",
                    "dateSubmitted","description","educationLevel","extent","format",
                    "hasFormat","hasPart","hasVersion","identifier","instructionalMethod",
                    "isFormatOf","isPartOf","isReferencedBy","isReplacedBy","isRequiredBy",
                    "issued","isVersionOf","language","license","mediator","medium",
                    "modified","provenance","publisher","references","relation","replaces",
                    "requires","rights","rightsHolder","source","spatial","subject",
                    "tableOfContents","temporal","title","type","valid")

build_metadata <- function(..., metadata_format = "dcterms") {
    if (metadata_format == 'dcterms') {
        pairls <- list(...)
        if (any(!names(pairls) %in% dcterms_fields)) {
            stop('All names of parameters must be in Dublin Core')
        }
        if (!'title' %in% names(pairls)) {
            stop('"title" is a required metadata field')
        }
        entry <- xml2::read_xml('<entry xmlns="http://www.w3.org/2005/Atom" xmlns:dcterms="http://purl.org/dc/terms/"></entry>')
        dcchild <- function(nodevalue, nodename) {
            add <- paste0("dcterms:", nodename)
            child <- xml2::xml_add_child(entry, .value = add)
            xml2::xml_text(child) <- nodevalue
            TRUE
        }
        mapply(dcchild, pairls, names(pairls))
        structure(as.character(entry), class = c("character", "dataverse_metadata"), format = "metadata_format")
    } else {
        stop("Unrecognized metadata format requested")
    }
}
