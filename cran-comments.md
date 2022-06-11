Description
-----------------------------------------------

This version fixes two bugs in data upload and improves documentation based on user feedback from the repository.

Thank you for taking the time to review the submission.

Shiro Kuriwaki


Test environments
-----------------------------------------------

1. [win-builder](https://win-builder.r-project.org/mLWollyoFa6t), development version (`devtools::check_win_devel()`)
2. [R-hub](https://builder.r-hub.io/status/dataverse_0.3.11.tar.gz-e5f0dad4f4234733a623accfe12a4273).
3. [GitHub Actions](https://github.com/IQSS/dataverse-client-r/actions)
  * os: macOS-latest    , r: 'release'
  * os: windows-latest  , r: 'devel'
  * os: windows-latest  , r: 'release'
  * os: ubuntu-latest   , r: 'devel'
  * os: ubuntu-latest   , r: 'release'
4. Local macOS, R 4.1.2


R CMD check results
-----------------------------------------------

* No ERRORs, WARNINGs on any builds.
* In the past, there has been a note about possibly misspelled words "APIs" and "Dataverse".  If they appear on your machines, both spellings are intentional.
