# R Client for Dataverse 4 Repositories #

[![Dataverse Project logo](http://dataverse.org/files/dataverseorg/files/dataverse_project_logo-hp.png "Dataverse Project")](http://dataverse.org)

The **dataverse** package provides access to [Dataverse 4](http://dataverse.org/) APIs, enabling data search, retrieval, and deposit, thus allowing R users to integrate public data sharing into the reproducible research workflow. **dataverse** is the next-generation iteration of [the **dvn** package](http://cran.r-project.org/package=dvn), which works with Dataverse 3 ("Dataverse Network") applications. **dataverse** includes numerous improvements for data search, retrieval, and deposit, including use of the (currently in development) **sword** package for data deposit and the **UNF** package for data fingerprinting.

Users interested in downloading metadata from archives other than Dataverse may be interested in Kurt Hornik's [OAIHarvester](http://cran.r-project.org/web/packages/OAIHarvester/index.html) and Scott Chamberlain's [oai](https://cran.fhcrc.org/web/packages/oai/index.html), which offer metadata download from any web repository that is compliant with the [Open Archives Initiative](http://www.openarchives.org/) standards. Additionally, [rdryad](http://cran.fhcrc.org/web/packages/rdryad/index.html) uses OAIHarvester to interface with [Dryad](http://datadryad.org/). The [rfigshare](http://cran.r-project.org/web/packages/rfigshare/) package works in a similar spirit to **dataverse** with [http://figshare.com/](http://figshare.com/).

## Installation ##

[![CRAN Version](http://www.r-pkg.org/badges/version/dataverse)](http://cran.r-project.org/package=dataverse)
![Downloads](http://cranlogs.r-pkg.org/badges/dataverse)
[![Travis-CI Build Status](https://travis-ci.org/IQSS/dataverse-client-r.png?branch=master)](https://travis-ci.org/IQSS/dataverse-client-r)

You can (eventually) find a stable release on [CRAN](http://cran.r-project.org/web/packages/dataverse/index.html), or install the latest development version from GitHub using [Hadley's](http://had.co.nz/) [devtools](http://cran.r-project.org/web/packages/devtools/index.html) package:

```R
if(!require("devtools")) {
    install.packages("devtools")
    library("devtools")
}
install_github("iqss/dataverse-client-r")
library("dataverse")
```

## Code Examples ##

Some features of the Dataverse 4 API are public and require no authentication. This means in many cases you can search for and retrieve data without a Dataverse account for that a specific Dataverse installation. But, other features require a Dataverse account for the specific server installation of the Dataverse software, and an API key linked to that account. Instructions for obtaining an account and setting up an API key are available in the [Dataverse User Guide](http://guides.dataverse.org/en/latest/user/account.html). (Note: if your key is compromised, it can be regenerated to preserve security.) Once you have an API key, this should be stored as an environment variable called `DATAVERSE_KEY`. It can be set within R using: 

`Sys.setenv("DATAVERSE_KEY" = "examplekey12345")`

Because [there are many Dataverse installations](http://dataverse.org/), all functions in the R client require specifying what server installation you are interacting with. This can be set by default with an environment variable, `DATAVERSE_SERVER`. This should be the Dataverse server, without the "https" prefix or the "/api" URL path, etc. For example, the Harvard Dataverse can be used by setting: 

`Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")`

Note: The package attempts to compensate for any malformed values, though.

### Data Discovery ###

Coming soon...

### Data and Metadata Retrieval ###

Coming soon...

### Data Deposit ###

Coming soon...

### Native API Features ###

Coming soon...

---

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
