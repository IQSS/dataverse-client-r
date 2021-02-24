Description
-----------------------------------------------

In response to a January notification from Brian Ripley, the tests are now skipped if the server cannot be contacted.  Unfortunately I couldn't attend to this package quickly enough, and understandably it was archived a few days ago.

All checks and tests are passing on win-builder, Travis, and my two local machines.  However it is failing on R-hub with a message I haven't encountered before. I suspect it's specific to R-hub, but haven't found similar posts online.  The error message involves the 'pillar' package (which isn't called) on the `get_dataframe_by_name()` examples (which are wrapped by `\donttest{...}`).

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.0.3
1. Local Win10, R 4.0.4 Patched
1. [win-builder](https://win-builder.r-project.org/U4UPm5oO0b32), development version.
1. [Travis CI](https://travis-ci.org/github/IQSS/dataverse-client-r), Ubuntu 18.04 LTS


*Failing*:

1. [r-hub](https://builder.r-hub.io/status/dataverse_0.3.2.tar.gz-4acdf7c445774c06aad526114a6e1a80)

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds, except for the R-hub problem mentioned above.
* One NOTE about the new package maintainer
