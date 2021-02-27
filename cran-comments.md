Description
-----------------------------------------------

In response to a January notification from Brian Ripley, the tests are now skipped if the server cannot be contacted.  Unfortunately I couldn't attend to this package quickly enough, and understandably it was archived a few days ago.

All checks and tests are passing on win-builder, Travis, and my two local machines.  However it is failing on R-hub with a message I haven't encountered before. I suspect it's specific to R-hub, but haven't found similar posts online.  The error message involves the 'pillar' package (which isn't called) on the `get_dataframe_by_name()` examples (which are wrapped by `\donttest{...}`).

We just made another modification (related to last night's rejection of v0.3.2) to account for different sorting orders that I assume are related to different platforms.  They hadn't appeared in any of our tests.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.0.3
1. Local Win10, R 4.0.4 Patched
1. [win-builder](https://win-builder.r-project.org/4ML5zvxJzOw6/), development version.
1. [Travis CI](https://travis-ci.org/github/IQSS/dataverse-client-r), Ubuntu 18.04 LTS


*Failing on some builds*:

1. [r-hub](https://builder.r-hub.io/status/dataverse_0.3.3.tar.gz-ad235e27f3624c7ca85e8a13ab5e41b0)

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds, except for the R-hub problem mentioned above.
* Depending on the build, there are two NOTEs.  One about the package being archived, and another about possibly misspelled words "APIs" and "Dataverse"; both spellings are intentional.
