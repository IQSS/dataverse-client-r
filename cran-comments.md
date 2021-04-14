Description
-----------------------------------------------

After Brian Ripley's latest instructions, we have decided we shouldn't rely 
on nightly CRAN builds for testing the package's interactions with servers.  
Even if the servers are reachable.  All those tests are now skipped on CRAN
(with `testthat::skip_on_cran()`) and instead will run on nightly 
GitHub Actions builds.

In this specific case, the server software (that our package calls) had 
accidentally released a backwards-incompatible change that our tests caught
on the dev server, fortunately before it was released to production servers.
We are grateful that CRAN helped alert everyone to the problem, but we do not
wish to further burden Brian and the rest of the CRAN team as you
graciously donate to the community.

Thank you for taking the time to review the submission, and please tell me if 
there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.0.4
2. Local Win10, R 4.0.4 Patched
3. [win-builder](), development version.
4. [R-hub](https://builder.r-hub.io/status/dataverse_0.3.8.tar.gz-cdb69dcae8044c28a925dae7004f2e66).
5. [GitHub Actions](https://github.com/IQSS/dataverse-client-r/actions)
  * os: macOS-latest    , r: 'release'
  * os: windows-latest  , r: 'devel'
  * os: windows-latest  , r: 'release'
  * os: ubuntu-latest   , r: 'devel'
  * os: ubuntu-latest   , r: 'release'

R CMD check results
-----------------------------------------------

* No ERRORs, WARNINGs, or NOTEs on any builds.

* In the past, there has been a note about possibly misspelled words "APIs" and "Dataverse".  If they appear on your machines, both spellings are intentional.
