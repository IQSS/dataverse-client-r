Description
-----------------------------------------------

In response to a January notification from Brian Ripley, the tests are now skipped if the server cannot be contacted.  Unfortunately I couldn't attend to this package quickly enough, and understandably it was archived a few days ago.

All checks and tests are passing on win-builder, Travis, R-hub, and my two local machines.  

We just made another modification (related to the previous rejections this week) to account for different sorting orders that I assume are related to different platforms.  They hadn't appeared in any of our tests.  We also changed a `donttest{}` to a `dontrun{}` example and updated an old url in a vignette that were missed in all these test environments.

I'm sorry these resubmissions have taken more of your time.  Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.0.4
1. Local Win10, R 4.0.4 Patched
1. [win-builder](https://win-builder.r-project.org/E5QE5o3DKIJF/), development version.
1. [Travis CI](https://travis-ci.org/github/IQSS/dataverse-client-r), Ubuntu 18.04 LTS
1. [R-hub](https://builder.r-hub.io/status/dataverse_0.3.7.tar.gz-76e7f9d49abc47f598fe0d8ddedcc450).

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
* There are two NOTEs.  One about the package being archived, and another about possibly misspelled words "APIs" and "Dataverse"; both spellings are intentional.
