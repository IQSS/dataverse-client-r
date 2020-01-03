library("testthat")
library("dataverse")

if (!requireNamespace("yaml", quietly = TRUE)) {
  warning("The 'yaml' package must be present to test the dataverse package.")
} else {
  server  <- Sys.getenv("DATAVERSE_SERVER")
  key     <- Sys.getenv("DATAVERSE_KEY")

  if (server == "" | key == "") {
    config  <- yaml::read_yaml(system.file("constants.yml", package="dataverse"))
    # config  <- yaml::read_yaml("inst/constants.yml")

    Sys.setenv("DATAVERSE_SERVER" = config$server)
    Sys.setenv("DATAVERSE_KEY"    = config$api_token)

    if (as.Date(config$api_token_expiration) < Sys.Date()) {
      stop(
        "The API token expired on `",
        config$api_token_expiration,
        "`, so the tests would probably fail.  ",
        "Please regenerate a new token and update `inst/constants.yml`"
      )
    }
    rm(config)
  }
  rm(server, key)

  message("Using Dataverse server `", Sys.getenv("DATAVERSE_SERVER"), "`.")

  test_check("dataverse")
}
