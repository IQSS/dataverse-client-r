
# wrap everything around generic SWORD client

service_document <- function(key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/service-document")
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out$workspace
}

create_dataset <- function(dataverse, atom, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/collection/dataverse/", dataverse)
    r <- httr::POST(u, httr::authenticate(key, ""), httr::add_headers("Content-Type" = "application/atom+xml"), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

list_datasets <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/collection/dataverse/", dataverse)
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

add_file <- function(dataset, file, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- prepend_doi(dataset)
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/edit-media/study/", dataset)
    
    # possibly accommodate multiple files and/or data.frames
    # see: https://github.com/ropensci/dvn/blob/master/R/dvAddFile.r
    
    h <- httr::add_headers("Content-Disposition" = paste0("filename=", file), 
                           "Content-Type" = "application/zip",
                           "Packaging" = "http://purl.org/net/sword/package/SimpleZip")
    r <- httr::POST(u, httr::authenticate(key, ""), h, ...)
    httr::stop_for_status(r)
    httr::content(r, "text")
}

delete_file <- function(dataset, id, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- prepend_doi(dataset)
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/edit-media/file/", id)
    r <- httr::DELETE(u, httr::authenticate(key, ""), h, ...)
    httr::stop_for_status(r)
    httr::content(r, "text")
}

delete_dataset <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- prepend_doi(dataset)
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/edit/study/", dataset)
    r <- httr::DELETE(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    httr::content(r, "text")
}

publish_dataset <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- prepend_doi(dataset)
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/edit/study/", dataset)
    r <- httr::POST(u, httr::authenticate(key, ""), httr::add_headers("In-Progress" = "false"), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

publish_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/edit/dataverse/", dataverse)
    r <- httr::POST(u, httr::authenticate(key, ""), httr::add_headers("In-Progress" = "false"), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

dataset_atom <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- prepend_doi(dataset)
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/edit/study/", dataset)
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

dataset_statement <- function(dataset, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    server <- urltools::url_parse(server)$domain
    dataset <- prepend_doi(dataset)
    u <- paste0("https://", server,"/dvn/api/data-deposit/v1.1/swordv2/statement/study/", dataset)
    r <- httr::GET(u, httr::authenticate(key, ""), ...)
    httr::stop_for_status(r)
    out <- xml2::as_list(xml2::read_xml(httr::content(r, "text")))
    out
}

