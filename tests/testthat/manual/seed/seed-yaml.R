import::from("magrittr", "%>%")
dv        <- get_dataverse("dataverse-client-r")
contents  <- dataverse_contents(dv)
ds_1      <- dataset_files(contents[[1]])

ds_1 %>%
  rlang::set_names(c("roster", "image")) %>%
  yaml::write_yaml("inst/dataset-basketball/expected-metadata.yml")

# retrieve-from-file ------------------------------------------------------
y <- yaml::read_yaml(system.file("dataset-basketball/expected-metadata.yml", package = "dataverse"))

y$roster

# Reference: https://jennybc.github.io/purrr-tutorial/ls01_map-name-position-shortcuts.html
ds_expected <-
  y %>%
  purrr::map_dfr(
    magrittr::extract,
    c("label", "restricted", "version", "datasetVersionId")
  )

# This way doesn't require a dplyr dependency
ds_expected <-
  data.frame(
    label              = purrr::map_chr(y, "label"),
    restricted         = purrr::map_lgl(y, "restricted"),
    version            = purrr::map_int(y, "version"),
    datasetVersionId   = purrr::map_int(y, "datasetVersionId")
  )

