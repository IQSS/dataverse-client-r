Description
-----------------------------------------------

This version updates an expired API token for testing purposes, which started
causing errors and prompted a email from the CRAN Team on 2021-12-31.


Because daily tests for the full download is done separately on Github Actions,
this test is not relevant as much for CRAN, so we updated the token and
also skipped the check if on CRAN tests.  We also closed 8 issues and feature
extensions recorded on Github.


Thank you for taking the time to review the submission.

Shiro Kuriwaki


Test environments
-----------------------------------------------

1. [win-builder](https://win-builder.r-project.org/cBi2U5y9gKOq), development version (`devtools::check_win_devel()`)
2. [R-hub](https://builder.r-hub.io/status/dataverse_0.3.9.tar.gz-82f7f1a52ace42ba9f913863a5223946).
3. [GitHub Actions](https://github.com/IQSS/dataverse-client-r/actions)
  * os: macOS-latest    , r: 'release'
  * os: windows-latest  , r: 'devel'
  * os: windows-latest  , r: 'release'
  * os: ubuntu-latest   , r: 'devel'
  * os: ubuntu-latest   , r: 'release'
4. Local macOS, R 4.0.4


R CMD check results
-----------------------------------------------

* No ERRORs, WARNINGs on any builds.
* In the past, there has been a note about possibly misspelled words "APIs" and "Dataverse".  If they appear on your machines, both spellings are intentional.
