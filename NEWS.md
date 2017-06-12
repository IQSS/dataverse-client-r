# CHANGES TO dataverse 0.1.21

* Fixed some bugs in `dataverse_search()`
* `get_file()` now unzips its results when multiple files are requested and returns them as a raw vector.
* Finished the "Data Retrieval" vignette. (#1)
* Document `dataverse_search()` in a vignette. (#1)

# CHANGES TO dataverse 0.1.21

* Update README.

# CHANGES TO dataverse 0.1.20

* Update roxygen.
* Add `print.dataverse_file()` method. (#12)
* Added a `dataverse_id.character()` method. (#12)

# CHANGES TO dataverse 0.1.18

* Fixed a bug in `api_url()` related to parsing of the Dataverse server URL that was affected by an API change in **urltools**. (h/t John Little)

# CHANGES TO dataverse 0.1.1

* Initial commit
