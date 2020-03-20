retrieve_manifest <- function ( ) {
  # Refresh col_types with: OuhscMunge::readr_spec_aligned(path)
  path  <- system.file("manifest-testing.csv", package = "dataverse")
  col_types <- readr::cols_only(
    `subdataverse`        = readr::col_character(),
    `file_name`           = readr::col_character(),
    `size_bytes`          = readr::col_integer(),
    `location_expected`   = readr::col_character(),
    `compare_cells`       = readr::col_logical(),
    `md5`                 = readr::col_character()
  )
  d <- readr::read_csv(path, col_types = col_types)

  d
}
# retrieve_manifest()

retrieve_file_expected <- function (subdataverse, file_name) {
  path <-
    file.path(subdataverse, file_name) %>%
    system.file(package = "dataverse")

  if (!file.exists(path)) {
    stop(
      "The testing file `",
      file_name,
      "` in the (sub)datavserse `",
      subdataverse,
      "` is not found.  Please verify that the manifest is synced with the collection of test files. "
    )
  }

  readr::read_file(path)
}
# retrieve_file_expected("rosters", "roster-bulls-1996.csv")


# compare_data_frame <- function (d_actual, d_expected) {
#
#   # Compare cell contents
#   testthat::expect_equal(d_actual, d_expected)
# }
