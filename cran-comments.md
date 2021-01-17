Description
-----------------------------------------------

This submission includes new features and updates to stay compliant with R checks.

A second change is that I am now the package maintainer, taking over from Thomas J. Leeper (thosjleeper@gmail.com).

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.0.3
1. Local Win8, R 4.0.3 Patched
1. r-hub
    1. [Ubuntu Linux 16.04 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapR_0.10.2.9006.tar.gz-71151f2f04454bc18c16430e5d62610b)
    1. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapR_0.10.2.9006.tar.gz-2f619028b765442f9dc1c34373443d2a)
    1. [Windows Server](https://builder.r-hub.io/status/REDCapR_0.10.2.9006.tar.gz-80133501925a411da4c3cf3be8205e29)
1. [win-builder](https://win-builder.r-project.org/xYyWrC1uFjXH), development version.
1. [Travis CI](https://travis-ci.org/github/IQSS/dataverse-client-r), Ubuntu 18.04 LTS


R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.


Downstream dependencies
-----------------------------------------------

No downstream packages are affected.  Only one package depends/imports REDCapR, and it passes my local checks.
    * [codified](https://CRAN.R-project.org/package=codified)
