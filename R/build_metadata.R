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

build_metadata <- function(..., metadata_format = "dcterms", validate = FALSE) {
    if (metadata_format == 'dcterms') {
        pairls <- list(...)
        if (any(!names(pairls) %in% dcterms_fields)) {
            stop('All names of parameters must be in Dublin Core')
        }
        if (!'title' %in% names(pairls)) {
            stop('"title" is a required metadata field')
        }
        entry <- XML::newXMLNode('entry', 
                                 namespaceDefinitions = c('http://www.w3.org/2005/Atom',
                                                          dcterms = 'http://purl.org/dc/terms/'))
        dcchild <- function(x,y) {
            dcnode <- XML::newXMLNode(y, x, namespace='dcterms')
        }
        XML::addChildren(entry, mapply(dcchild, pairls, names(pairls)))
        entry <- paste0('<?xml version="1.0" encoding="UTF-8" ?>\n', XML::toString.XMLNode(entry))
        if (validate) {
            # run an XML schema validation
            #valid <- xmlSchemaValidate('http://purl.org/dc/terms/', entry)
        }
        class(entry) <- c(class(entry), 'dataverse_metadata')
        attr(entry,'format') <- metadata_format
        return(entry)
    } else {
        stop("Unrecognized metadata format requested")
    }
}
