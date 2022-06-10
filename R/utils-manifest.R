retrieve_manifest <- function() {
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
  readr::read_csv(path, col_types = col_types)
}


retrieve_file_expected <- function (subdataverse, file_name) {
  path <- system.file(file.path(subdataverse, file_name), package = "dataverse")

  if (!file.exists(path)) {
    stop(
      "The testing file `",
      file_name,
      "` in the (sub)dataverse `",
      subdataverse,
      "` is not found.  Please verify that the manifest is synced with the collection of test files. "
    )
  }

  readr::read_file(path)
}

retrieve_info_dataverse <- function(path) {
  yaml::read_yaml(system.file(path, package = "dataverse"))
}

retrieve_info_dataset <- function(path) {
  yaml::read_yaml(system.file(path, package = "dataverse"))
}

# retrieve_file_expected("dataset-basketball/original", "roster-bulls-1996.csv")
# retrieve_info_dataset("dataset-basketball/expected-metadata.yml")
# retrieve_info_dataverse("expected-dataverse.yml")
