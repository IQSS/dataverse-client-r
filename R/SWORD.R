
# wrap everything around generic SWORD client

dataset_atom <- function(doi, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    if (!grepl("^doi:", doi)) {
        doi <- paste0("doi:", doi)
    } else if (grepl("^DOI:", doi)) {
        doi <- paste0("doi:", strsplit(doi, "DOI:", fixed = TRUE)[[1]][2])
    }
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/edit/study/", doi)
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

sword_dataverse_contents <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataverse <- dataverse_id(dataverse)
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/collection/dataverse/", dataverse)
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

dataset_statement <- function(doi, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    if (!grepl("^doi:", doi)) {
        doi <- paste0("doi:", doi)
    } else if (grepl("^DOI:", doi)) {
        doi <- paste0("doi:", strsplit(doi, "DOI:", fixed = TRUE)[[1]][2])
    }
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/statement/study/", doi)
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

