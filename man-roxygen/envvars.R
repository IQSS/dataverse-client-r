#' @param key A character string specifying a Dataverse server API key. If one
#'   is not specified, functions calling authenticated API endpoints will fail.
#'   Keys can be specified atomically or globally using
#'   \code{Sys.setenv("DATAVERSE_KEY" = "examplekey")}.
#' @param server A character string specifying a Dataverse server.
#'   Multiple Dataverse installations exist, with `"dataverse.harvard.edu"` being the
#'   most major. The server can be defined each time within a function, or it can
#'   be set as a default via an environment variable. To set a default, run
#'   `Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")`
#'   or add `DATAVERSE_SERVER = "dataverse.harvard.edu` in one's `.Renviron`
#'   file (`usethis::edit_r_environ()`), with the appropriate domain as its value.
