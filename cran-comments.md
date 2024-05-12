Description
-----------------------------------------------

This version removes remote resources from vignette per CRAN policy, and makes several other usability improvements. 

Shiro Kuriwaki


Test environments
-----------------------------------------------

1. [win-builder](https://win-builder.r-project.org/QhQR4q21BLc1), development version (`devtools::check_win_devel()`)
2. [R-hub](https://builder.r-hub.io/status/dataverse_0.3.13.tar.gz-a910246e058d4fdea677a3e29278dfbf).
3. [GitHub Actions](https://github.com/IQSS/dataverse-client-r/actions)
  * os: macOS-latest  , r: 'release'
  * os: windows-latest, r: 'devel'
  * os: windows-latest, r: 'release'
  * os: ubuntu-20.04  , r: 'devel'
  * os: ubuntu-20.04  , r: 'release'
4. Local macOS, R 4.2.1


R CMD check results
-----------------------------------------------

* No ERRORs, WARNINGs on any builds.
* In the past, there has been a note about possibly misspelled words "APIs" and "Dataverse".  If they appear on your machines, both spellings are intentional.
