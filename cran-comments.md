Description
-----------------------------------------------

This version fixes an outdated token error reported on Jan 2023. No other changes were made.

Shiro Kuriwaki


Test environments
-----------------------------------------------

1. [win-builder](https://win-builder.r-project.org/Ot5mFV5E8kJW/), development version (`devtools::check_win_devel()`)
2. [R-hub](https://builder.r-hub.io/status/dataverse_0.3.11.tar.gz-799b4dfb137f404b8ddc040354287a81).
3. [GitHub Actions](https://github.com/IQSS/dataverse-client-r/actions)
  * os: macOS-latest    , r: 'release'
  * os: windows-latest  , r: 'devel'
  * os: windows-latest  , r: 'release'
  * os: ubuntu-latest   , r: 'devel'
  * os: ubuntu-latest   , r: 'release'
4. Local macOS, R 4.2.1


R CMD check results
-----------------------------------------------

* No ERRORs, WARNINGs on any builds.
* In the past, there has been a note about possibly misspelled words "APIs" and "Dataverse".  If they appear on your machines, both spellings are intentional.
