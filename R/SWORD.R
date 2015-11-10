
# wrap everything around generic SWORD client



dataset_atom <- function(doi, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    # parse the DOI so it is prefaced by "doi:"
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/edit/study/", doi)
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

sword_list_contents <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
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
    # parse the DOI so it is prefaced by "doi:"
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/statement/study/", doi)
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

