#' @importFrom cachem cache_disk
#'
#' @importFrom memoise memoise
.onLoad <- function(libname, pkgname) {
  ##
  ## 'memoise' httr::GET calls
  ##

  ## API session cache
  api_get_session_cache <<- memoise(api_get_impl)

  ## API disk cache
  cache_path <- cache_path()
  if (dir.exists(cache_path)) {
    # disk cache, no age or size limits
    cache <- cache_disk(cache_path)
    get_disk <- memoise(api_get_impl, cache = cache)
  }
  api_get_disk_cache <<- get_disk
}
