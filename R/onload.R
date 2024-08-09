#' @importFrom memoise memoise
#' @importFrom rappdirs user_cache_dir
.onLoad <- function(libname, pkgname) {
  disk_cache <- cachem::cache_disk(rappdirs::user_cache_dir("R-dataverse-client"))

  memoised_get_file_by_id <- memoise::memoise(get_file_by_id, cache = disk_cache)
  non_memoised_get_file_by_id <- get_file_by_id

  get_file_by_id  <<- function(...) {
      if ("version" %in% names(list(...))) {
          memoised_get_file_by_id(...)
      } else {
          non_memoised_get_file_by_id(...)
      }
  }
}
