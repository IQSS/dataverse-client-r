#' @rdname cache
#' @aliases use_cache
#' @title Utilities for cache management
#' @description The dataverse package uses disk and session caches to improve network performance. Use of the cache is described on this page.
#' @details
#' Use of the cache is determined by the value of the `use_cache =` argument to dataset and other API calls, or by the environment variable `DATAVERSE_USE_CACHE`. Possible values are
#'
#' - `"none"`: do not use the cache. This is the default for datasets that are versioned with `":draft"`, `":latest"`, and `":latest-published"`.
#' - `"session"`: cache API requests for the duration of the *R* session. This is the default for API calls that do not involve file or dataset retrieval.
#' - `"disk": use a permanent disk cache. This is the default for files and explicitly versioned datasets.
#' 
#' @template version
#' @details
#' `cache_dataset()` determines whether a dataset or file should be cached based on the version specification.
#' @return
#' `cache_dataset()` returns `"disk"` if the dataset version is to be cached to disk, `"none"` otherwise.
#' @importFrom checkmate assert_string
#' @examples
#' cache_dataset(":latest")  # "none"
#' cache_dataset("1.2")      # "disk"
#' @export
cache_dataset <- function(version) {
  assert_string(version)
  if (version %in% c(":draft", ":latest", ":latest-published")) {
    "none"
  } else {
    "disk"
  }
}

#' @rdname cache
#' @details
#' `cache_path()` finds or creates the location (directory) on the file system containing the cache.
#'
#' @return
#' `cache_path()` returns the file path to the directory containing the cache.
#'
#' @examples
#' cache_path()
#'
#' @importFrom tools R_user_dir
#' @export
cache_path <- function() {
  cache_path <- file.path(R_user_dir("dataverse", "cache"), "api_cache")
  if (!dir.exists(cache_path)) {
    status <- dir.create(cache_path, recursive = TRUE)
    if (!status)
      warning("'dataverse' failed to create a 'disk' cache")
  }

  cache_path
}

#' @rdname cache
#' @details
#' `cache_info()` queries the cache for information about the name, size, and other attributes of files in the cache. The file name is a 'hash' of the function used to retrieve the file; it is not useful for identifying specific files.
#' @return
#' `cache_info()` returns a data.frame containing names and sizes of files in the cache.
#' @examples
#' cache_info()
#' @export
cache_info <- function() {
  cache_path <- cache_path()
  if (dir.exists(cache_path)) {
    files <- dir(cache_path(), full.names = TRUE)
    info <- file.info(files)
    rownames(info) <- basename(files)
    info
  }
}

#' @rdname cache
#' @details
#' `cache_reset()` clears all downloaded files from the disk cache.
#' @returns
#' `cache_reset()` returns the path to the (now empty) cache, invisibly)
#' @export
cache_reset <- function() {
  cache_path <- cache_path()
  if (dir.exists(cache_path))  
    cache_disk(cache_path)$reset()
  invisible(cache_path)
}

## utility to check valid values of `use_cache =`
#' @importFrom checkmate test_string
assert_use_cache <- function(use_cache) {
  test <-
    test_string(use_cache) &&
    use_cache %in% c("disk", "session", "none")
  if (!test)
    stop("argument 'use_cache' is not correct, see ?use_cache")
}
