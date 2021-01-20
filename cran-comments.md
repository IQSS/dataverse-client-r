Description
-----------------------------------------------

In response to a notification from Brian Ripley, the tests are now skipped if the server cannot be contacted.  The package was accepted by CRAN yesterday, and today failed the Solaris tests.  For some reason on just that build, the SSL certificates were expired.

Thank you for taking the time to review my submission (especially so soon after the previous one), and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.0.3
1. Local Win10, R 4.0.3 Patched
1. [r-hub](https://builder.r-hub.io/status/dataverse_0.3.0.tar.gz-905624c45a92467eb688858acab1a13)
1. [win-builder](https://win-builder.r-project.org/xYyWrC1uFjXH), development version.
1. [Travis CI](https://travis-ci.org/github/IQSS/dataverse-client-r), Ubuntu 18.04 LTS


R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
* One NOTE about the new package maintainer
