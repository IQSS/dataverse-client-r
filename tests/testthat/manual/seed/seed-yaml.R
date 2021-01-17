import::from("magrittr", "%>%")
dv        <- get_dataverse("dataverse-client-r")
contents  <- dataverse_contents(dv)
ds_1      <- dataset_files(contents[[1]]) %>%
  rlang::set_names(c("roster", "image")) # Manually add friendly names to each file

# ---- seed-dataverses ---------------------------------------------------
get_dataverse(":root") %>%
  base::append(c("testing_name" = ":root")) %>%
  yaml::write_yaml("inst/expected-dataverse-root.yml")

dv %>%
  base::append(c("testing_name" = "dataverse-client-r")) %>%
  yaml::write_yaml("inst/expected-dataverse.yml")


# ---- seed-basketball-files ---------------------------------------------------
file_csv <-
  get_dataframe_by_name(
    filename = "roster-bulls-1996.tab",
    dataset  = "doi:10.70122/FK2/HXJVJU",
    original = TRUE,
    .f       = readr::read_file
  )

ds_1$roster$raw_value <-
  get_dataframe_by_name(
    # filename = "roster-bulls-1996.tab",
    filename = ds_1$roster$label,
    dataset  = dirname(ds_1$roster$dataFile$persistentId),
    original = TRUE,
    .f       = readr::read_file
  )

ds_1$image$raw_value <-
  paste0( # The yaml needs a terminal new line to mirror the real content.
    get_dataframe_by_name(
      # filename = "roster-bulls-1996.tab",
      filename = ds_1$image$label,
      dataset  = dirname(ds_1$image$dataFile$persistentId),
      original = TRUE,
      .f       = readr::read_file
    ),
    "\n"
  )

ds_1 %>%
  # rlang::set_names(c("roster", "image")) %>% # Manually add friendly names to each file
  yaml::write_yaml("inst/dataset-basketball/expected-metadata.yml")


# ---- save-expected-dataframe -------------------------------------------------
ds_1$roster %>%
  {
    get_dataframe_by_name(
      filename = .$label,
      dataset  = dirname(.$dataFile$persistentId)
    )
  } %>%
  readr::write_rds("inst/dataset-basketball/dataframe-from-tab.rds")

# ---- practice-retrieving-from-file ------------------------------------------------------
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

