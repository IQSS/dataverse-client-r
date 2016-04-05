library("testthat")
local({
    library("dataverse")
    dv_server <- Sys.getenv("DATAVERSE_SERVER")
    on.exit(Sys.setenv("DATAVERSE_SERVER" = dv_server))
    Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")
    #test_check("dataverse")
})
