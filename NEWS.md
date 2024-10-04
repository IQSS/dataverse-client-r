# dataverse

# CHANGES in dataverse 0.3.14

* Implement a simple cache for API (including file download) calls, improving performance and reliability (#112, #135)
* Improve recommendation for rdata loading (#107, #127)
* `get_file_by_*()` can now return the download URL to be used in external functions or programs, useful for large files (#128, implemented in #129 @JBGruber and @kuriwaki)
* Removes remote resource from vignette and move them to ghactions (#131)

# CHANGES in dataverse 0.3.12 and 0.3.13

* Update expired token (#123)

# CHANGES in dataverse 0.3.11

* Allow for downloading from draft datasets (#115, @Danny-dK)
* Fix add dataset bug introduced in a recent version (#116)

# CHANGES in dataverse 0.3.10

* Add progress bar for all downloads (#108)
* Minor documentation improvements (#64, #107)
* Faster method for detecting ingest (#113) and robustness to ingested files without a metadata file due to errors (#80)
* No longer relies on `foreign` (#34)

# CHANGES in dataverse 0.3.9

* Change maintainer to @kuriwaki

# CHANGES in dataverse 0.3.8 (2021-04-14 CRAN)

Core Features

* Adapt to Dataverse 5.4.1 (#94 @kuriwaki)

Testing

* Doesn't rely on CRAN for daily tests of API functions (#96)
* Upgrade testthat to 3.0 edition (#97)
* Move to GitHub Actions, and away from Travis-CI.  (#98)  Three GitHub Actions are defined for testing: 
  * thorough testing related to PRs and the main branch,
  * straight-forward tests for each push to the dev branch, and
  * straight-forward tests run daily at 3am

# CHANGES in dataverse 0.3.3

* More verbose error messages returned on httr failure. (#31 @EdJeeOnGithub)

# CHANGES in dataverse 0.3.1

* Avoids tests in R Check if the dataverse server is not available (#77)
* Avoids potential mixup of dataset ordering within a retrieved dataverse (#83)

# CHANGES in dataverse 0.3.0 (2021-01-17 CRAN)

New Methods

* Add new `get_dataframe_*()` methods (#48, #66)

Small updates

* Make filter queries (fq) work in `dataverse_search` (#36 @adam3smith)
* Update maintainer to Will Beasley (wibeasley@hotmail.com) (#38)
* More robust file retrieval (#39 @kuriwaki)
* Tests use https://demo.dataverse.org/dataverse/dataverse-client-r/. (#40)
* Fixes most get_file errors by removing query argument (#33 @kuriwaki)
* Fix getting multiple files by id in `get_file()` (#47 @adam3smith)
* Temporary files created by `get_file()` are automatically deleted.

# CHANGES dataverse 0.2.1 (2018-03-05 CRAN)

* Export `initiate_sword_dataset()`. (h/t Justin de Benedictis-Kessner)
* Pass `key`, `server`, and `...` arguments to internal `get_dataverse()` and `get_dataset()` calls.
* Tests now run with an explicit empty API key.
* Fixed a bug in internal function `parse_dataset()`, related to capitalization. (#17)
* Vignette uses 'remotes' package in place of the archived 'ghit' package. (#24 @wibeasley)
* Updated config for Travis-CI, such as switch to xenial Ubuntu release, specify repo's org, and specify covr parameters. (#25 @wibeasley)

# CHANGES in dataverse 0.1.24 (2017-06-15, CRAN v0.2.0)

* Added an `update_dataset_file()` function and improved associated documentation. (#10)

# CHANGES in dataverse 0.1.23

* Added a provisional `add_dataset_file()` function. (#10)
* Reorganized some code.
* Noted that user-related functions are not implemented (yet). (#1)

# CHANGES in dataverse 0.1.22

* Change vignette workflow so that vignettes are pre-built. (#1)
* Removed **XML** dependency, updating all code to **xml2** instead.
* Removed **urltools** dependency.
* Finished the "Data Archiving" vignette. (#1)
* Fixed some bugs in `dataverse_search()`
* `get_file()` now unzips its results when multiple files are requested and returns them as a raw vector.
* Finished the "Data Retrieval" vignette. (#1)
* Document `dataverse_search()` in a vignette. (#1)

# CHANGES in dataverse 0.1.21

* Update README.

# CHANGES in dataverse 0.1.20

* Update roxygen.
* Add `print.dataverse_file()` method. (#12)
* Added a `dataverse_id.character()` method. (#12)

# CHANGES in dataverse 0.1.18

* Fixed a bug in `api_url()` related to parsing of the Dataverse server URL that was affected by an API change in **urltools**. (h/t John Little)

# CHANGES in dataverse 0.1.1

* Initial commit
