#' @importFrom cachem cache_disk
#'
#' @importFrom memoise memoise
.onLoad <- function(libname, pkgname) {
  # a <- Sys.getenv("DATAVERSE_SERVER")
  # if(a == "") {
  #     Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")
  # }

  ## implement API disk cache via 'memoise'
  cache_directory <- file.path(
    tools::R_user_dir(pkgname, "cache"),
    "api_cache"
  )
  get <- api_get_impl
  if (!dir.exists(cache_directory)) {
    status <- dir.create(cache_directory, recursive = TRUE)
    if (!status)
      warning("'dataverse' failed to create API cache")
  }
  if (dir.exists(cache_directory)) {
    # disk cache with max age 30 days
    cache <- cache_disk(cache_directory, max_age = 60 * 60 * 24 * 30)
    get <- memoise(get, cache = cache)
  }
  api_get_memoized <<- get
}
