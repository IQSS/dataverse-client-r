Description
-----------------------------------------------

The `dataverse` package was archived on 2021-04-21 after we could not attend 
to a failing test in time. Shiro Kuriwaki will be maintainer for this new
submission (for 0.3.9 and going forward), as the automatic `NOTE` will flag. 
We communicated this to the CRAN team 2021-07-18.  
The previous maintainer, Will Beasley, will continue to contribute to the package as author. 

The nature of the test failure was that the APIs were relying on a nightly CRAN build.
After a few unreliable connections after many successful tests, some of the 
servers eventually returned an error. After Brian Ripley's latest instructions, 
we have decided we shouldn't rely  on nightly CRAN builds for testing the package's interactions with servers, even if the servers are reachable.  
All those tests are now skipped on CRAN
(with `testthat::skip_on_cran()`) and instead will run on nightly 
GitHub Actions builds.


Thank you for taking the time to review the submission, and please tell me if 
there's something else I should do for CRAN.  -Shiro Kuriwaki


Test environments
-----------------------------------------------

1. [win-builder](https://win-builder.r-project.org/vt7EiD90tJZd), development version (`devtools::check_win_devel()`)
2. [R-hub]().
3. [GitHub Actions](https://github.com/IQSS/dataverse-client-r/actions)
  * os: macOS-latest    , r: 'release'
  * os: windows-latest  , r: 'devel'
  * os: windows-latest  , r: 'release'
  * os: ubuntu-latest   , r: 'devel'
  * os: ubuntu-latest   , r: 'release'
4. Local macOS, R 4.0.4


R CMD check results
-----------------------------------------------

* One NOTE for a new maintainer. 
* No ERRORs, WARNINGs on any builds.
* In the past, there has been a note about possibly misspelled words "APIs" and "Dataverse".  If they appear on your machines, both spellings are intentional.
