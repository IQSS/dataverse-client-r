Description
-----------------------------------------------

This version (0.3.14) removes remote resources from vignette per CRAN policy, and makes several other usability improvements. 

Shiro Kuriwaki


Test environments
-----------------------------------------------

1. [win-builder](https://win-builder.r-project.org/FQhpeR7xF2O1), development version (`devtools::check_win_devel()`)
2. [GitHub Actions](https://github.com/IQSS/dataverse-client-r/actions/runs/9054158346)
  * os: macOS-latest  , r: 'release'
  * os: windows-latest, r: 'devel'
  * os: windows-latest, r: 'release'
  * os: ubuntu-20.04  , r: 'devel'
  * os: ubuntu-20.04  , r: 'release'
3. Local macOS, R 4.3.3


R CMD check results
-----------------------------------------------

* No ERRORs, WARNINGs on any builds.
* In the past, there has been a note about possibly misspelled words "APIs" and "Dataverse".  If they appear on your machines, both spellings are intentional.
