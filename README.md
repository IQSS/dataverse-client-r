# R Client for Dataverse 4 Repositories

[![Dataverse Project logo](http://dataverse.org/files/dataverseorg/files/dataverse_project_logo-hp.png "Dataverse Project")](http://dataverse.org)

The **dataverse** package provides access to [Dataverse 4](http://dataverse.org/) APIs, enabling data search, retrieval, and deposit, thus allowing R users to integrate public data sharing into the reproducible research workflow. **dataverse** is the next-generation iteration of [the **dvn** package](https://cran.r-project.org/package=dvn), which works with Dataverse 3 ("Dataverse Network") applications. **dataverse** includes numerous improvements for data search, retrieval, and deposit, including use of the (currently in development) **sword** package for data deposit and the **UNF** package for data fingerprinting.

Some features of the Dataverse 4 API are public and require no authentication. This means in many cases you can search for and retrieve data without a Dataverse account for that a specific Dataverse installation. But, other features require a Dataverse account for the specific server installation of the Dataverse software, and an API key linked to that account. Instructions for obtaining an account and setting up an API key are available in the [Dataverse User Guide](http://guides.dataverse.org/en/latest/user/account.html). (Note: if your key is compromised, it can be regenerated to preserve security.) Once you have an API key, this should be stored as an environment variable called `DATAVERSE_KEY`. It can be set within R using: 

```R
Sys.setenv("DATAVERSE_KEY" = "examplekey12345")
```

Because [there are many Dataverse installations](http://dataverse.org/), all functions in the R client require specifying what server installation you are interacting with. This can be set by default with an environment variable, `DATAVERSE_SERVER`. This should be the Dataverse server, without the "https" prefix or the "/api" URL path, etc. For example, the Harvard Dataverse can be used by setting: 

```R
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")
```

Note: The package attempts to compensate for any malformed values, though.

### Data Discovery

Dataverse supplies a pretty robust search API to discover Dataverses, datasets, and files. The simplest searches simply consist of a query string:


```r
library("dataverse")
str(dataverse_search("Gary King"), 1)
```

```
## 10 of 1043 results retrieved
```

```
## 'data.frame':	10 obs. of  17 variables:
##  $ name             : chr  "00698McArthur-King-BoxCoverSheets.pdf" "00698McArthur-King-MemoOfAgreement.pdf" "00698McArthur-King-StudyDescription.pdf" "077_mod1_s2m.tab" ...
##  $ type             : chr  "file" "file" "file" "file" ...
##  $ url              : chr  "https://dataverse.harvard.edu/api/access/datafile/101348" "https://dataverse.harvard.edu/api/access/datafile/101349" "https://dataverse.harvard.edu/api/access/datafile/101350" "https://dataverse.harvard.edu/api/access/datafile/2910738" ...
##  $ file_id          : chr  "101348" "101349" "101350" "2910738" ...
##  $ description      : chr  "Describe contents of each box of a paper data set" "Legal agreement between data depositor and Murray Archive" "Overview: abstract, research methodology, publications, and other info." NA ...
##  $ published_at     : chr  "2009-03-05T00:00:00Z" "2009-03-05T00:00:00Z" "2009-03-05T00:00:00Z" "2016-11-09T22:06:10Z" ...
##  $ file_type        : chr  "Adobe PDF" "Adobe PDF" "Adobe PDF" "Tab-Delimited" ...
##  $ file_content_type: chr  "application/pdf" "application/pdf" "application/pdf" "text/tab-separated-values" ...
##  $ size_in_bytes    : int  503714 360107 16506 318276 NA NA NA NA NA NA
##  $ md5              : chr  "" "" "" "af9a6fa00bf29009e9eb5d366ad64660" ...
##  $ checksum         :'data.frame':	10 obs. of  2 variables:
##  $ dataset_citation : chr  "Charles C. McArthur; Stanley H. King, 2009, \"Harvard Student Study, 1960-1964\", hdl:1902.1/00698, Harvard Dataverse, V2" "Charles C. McArthur; Stanley H. King, 2009, \"Harvard Student Study, 1960-1964\", hdl:1902.1/00698, Harvard Dataverse, V2" "Charles C. McArthur; Stanley H. King, 2009, \"Harvard Student Study, 1960-1964\", hdl:1902.1/00698, Harvard Dataverse, V2" "International Food Policy Research Institute (IFPRI); Savannah Agricultural Research Institute, 2016, \"Medium "| __truncated__ ...
##  $ unf              : chr  NA NA NA "UNF:6:4mZh78EEGxqFLF71f/Nh/A==" ...
##  $ global_id        : chr  NA NA NA NA ...
##  $ citationHtml     : chr  NA NA NA NA ...
##  $ citation         : chr  NA NA NA NA ...
##  $ authors          :List of 10
```

More complicated searches might specify metadata fields:


```r
str(dataverse_search(author = "Gary King", title = "Ecological Inference"), 1)
```

```
## 10 of 1349 results retrieved
```

```
## 'data.frame':	10 obs. of  17 variables:
##  $ name             : chr  "00531Winter-LiberalArts-Clare-Data.tab" "00698McArthur-King-BoxCoverSheets.pdf" "00698McArthur-King-MemoOfAgreement.pdf" "00698McArthur-King-StudyDescription.pdf" ...
##  $ type             : chr  "file" "file" "file" "file" ...
##  $ url              : chr  "https://dataverse.harvard.edu/api/access/datafile/101725" "https://dataverse.harvard.edu/api/access/datafile/101348" "https://dataverse.harvard.edu/api/access/datafile/101349" "https://dataverse.harvard.edu/api/access/datafile/101350" ...
##  $ file_id          : chr  "101725" "101348" "101349" "101350" ...
##  $ description      : chr  "Clare College data in tab delimited format" "Describe contents of each box of a paper data set" "Legal agreement between data depositor and Murray Archive" "Overview: abstract, research methodology, publications, and other info." ...
##  $ published_at     : chr  "2010-05-10T00:00:00Z" "2009-03-05T00:00:00Z" "2009-03-05T00:00:00Z" "2009-03-05T00:00:00Z" ...
##  $ file_type        : chr  "Tab-Delimited" "Adobe PDF" "Adobe PDF" "Adobe PDF" ...
##  $ file_content_type: chr  "text/tab-separated-values" "application/pdf" "application/pdf" "application/pdf" ...
##  $ size_in_bytes    : int  167843 503714 360107 16506 318276 NA 3825612 4012 9054 48213
##  $ md5              : chr  "" "" "" "" ...
##  $ checksum         :'data.frame':	10 obs. of  2 variables:
##  $ unf              : chr  "UNF:3:9ZWOqiilVGnLacm4Qg2EYQ==" NA NA NA ...
##  $ dataset_citation : chr  "David G. Winter; David C. McClelland; Abigail J. Stewart, 2010, \"New Case for the Liberal Arts, 1974-1978\", h"| __truncated__ "Charles C. McArthur; Stanley H. King, 2009, \"Harvard Student Study, 1960-1964\", hdl:1902.1/00698, Harvard Dataverse, V2" "Charles C. McArthur; Stanley H. King, 2009, \"Harvard Student Study, 1960-1964\", hdl:1902.1/00698, Harvard Dataverse, V2" "Charles C. McArthur; Stanley H. King, 2009, \"Harvard Student Study, 1960-1964\", hdl:1902.1/00698, Harvard Dataverse, V2" ...
##  $ global_id        : chr  NA NA NA NA ...
##  $ citationHtml     : chr  NA NA NA NA ...
##  $ citation         : chr  NA NA NA NA ...
##  $ authors          :List of 10
```

And searches can be restricted to specific types of objects (Dataverse, dataset, or file):


```r
str(dataverse_search(author = "Gary King", type = "dataset"), 1)
```

```
## 10 of 523 results retrieved
```

```
## 'data.frame':	10 obs. of  9 variables:
##  $ name        : chr  "10 Million International Dyadic Events" "A Comparative Study between Gurukul System and Western System of Education" "A Lexicial Index of Electoral Democracy" "A Unified Model of Cabinet Dissolution in Parliamentary Democracies" ...
##  $ type        : chr  "dataset" "dataset" "dataset" "dataset" ...
##  $ url         : chr  "http://hdl.handle.net/1902.1/FYXLAWZRIA" "http://dx.doi.org/10.7910/DVN/329UAV" "http://dx.doi.org/10.7910/DVN/29106" "http://dx.doi.org/10.3886/ICPSR01115.v1" ...
##  $ global_id   : chr  "hdl:1902.1/FYXLAWZRIA" "doi:10.7910/DVN/329UAV" "doi:10.7910/DVN/29106" "doi:10.3886/ICPSR01115.v1" ...
##  $ description : chr  "When the Palestinians launch a mortar attack into Israel, the Israeli army does not wait until the end of the c"| __truncated__ "India, in ancient times has witnessed students which used to be like the great king Vikramaditya. He followed t"| __truncated__ "We operationalize electoral democracy as a series of necessary-and-sufficient conditions arrayed in an ordinal "| __truncated__ "The literature on cabinet duration is split between two apparently irreconcilable positions. The ATTRIBUTES THE"| __truncated__ ...
##  $ published_at: chr  "2014-08-21T00:00:00Z" "2016-06-07T13:09:20Z" "2016-08-05T20:42:31Z" "2015-04-09T04:13:54Z" ...
##  $ citationHtml: chr  "King, Gary; Lowe, Will, 2008, \"10 Million International Dyadic Events\", <a href=\"http://hdl.handle.net/1902."| __truncated__ "Mr. Amrish George Frederick, 2016, \"A Comparative Study between Gurukul System and Western System of Education"| __truncated__ "Skaaning, Svend-Erik; John Gerring; Henrikas Bartusevicius, 2015, \"A Lexicial Index of Electoral Democracy\", "| __truncated__ "King, Gary; Alt, James E.; Burns, Nancy; Laver, Michael, 1996, \"A Unified Model of Cabinet Dissolution in Parl"| __truncated__ ...
##  $ citation    : chr  "King, Gary; Lowe, Will, 2008, \"10 Million International Dyadic Events\", hdl:1902.1/FYXLAWZRIA, Harvard Datave"| __truncated__ "Mr. Amrish George Frederick, 2016, \"A Comparative Study between Gurukul System and Western System of Education"| __truncated__ "Skaaning, Svend-Erik; John Gerring; Henrikas Bartusevicius, 2015, \"A Lexicial Index of Electoral Democracy\", "| __truncated__ "King, Gary; Alt, James E.; Burns, Nancy; Laver, Michael, 1996, \"A Unified Model of Cabinet Dissolution in Parl"| __truncated__ ...
##  $ authors     :List of 10
```

The results are paginated using `per_page` argument. To retrieve subsequent pages, specify `start`.


### Data and Metadata Retrieval

The easiest way to access data from Dataverse is to use a persistent identifier (typically a DOI). You can retrieve the contents of a Dataverse dataset:


```r
get_dataset("doi:10.7910/DVN/ARKOTI")
```

```
## Dataset (75170): 
## Version (75170): 1.0, RELEASED
## Release Date: 2015-07-07T02:57:02Z
## License: CC0
## 17 Files:
## 'data.frame':	32 obs. of  17 variables:
##  $ description        : chr  "Salta, Argentina field experiment on e-voting versus traditional voting. Citation: Alvarez, R. Michael, Ines Le"| __truncated__ "National Survey of High School Biology Teachers. Citation: Berkman, Michael and Eric Plutzer. 2010. Evolution, "| __truncated__ "Replication code for Chapter 1 (Obtaining R and Downloading Packages). No additional data required." "Replication code for Chapter 2 (Loading and Manipulating Data). Required data files: hmnrghts.txt, sen113kh.ord"| __truncated__ ...
##  $ label              : chr  "alpl2013.tab" "BPchap7.tab" "chapter01.R" "chapter02.R" ...
##  $ version            : int  2 2 2 2 2 2 2 2 2 2 ...
##  $ datasetVersionId   : int  75170 75170 75170 75170 75170 75170 75170 75170 75170 75170 ...
##  $ categories         :List of 32
##  $ id                 : int  2692294 2692295 2692202 2692206 2692210 2692204 2692205 2692212 2692209 2692208 ...
##  $ filename           : chr  "alpl2013.tab" "BPchap7.tab" "chapter01.R" "chapter02.R" ...
##  $ contentType        : chr  "text/tab-separated-values" "text/tab-separated-values" "text/plain; charset=US-ASCII" "text/plain; charset=US-ASCII" ...
##  $ filesize           : int  210991 61284 1293 5591 5766 1938 2327 4064 7228 6433 ...
##  $ description        : chr  "Salta, Argentina field experiment on e-voting versus traditional voting. Citation: Alvarez, R. Michael, Ines Le"| __truncated__ "National Survey of High School Biology Teachers. Citation: Berkman, Michael and Eric Plutzer. 2010. Evolution, "| __truncated__ "Replication code for Chapter 1 (Obtaining R and Downloading Packages). No additional data required." "Replication code for Chapter 2 (Loading and Manipulating Data). Required data files: hmnrghts.txt, sen113kh.ord"| __truncated__ ...
##  $ storageIdentifier  : chr  "14e664cd3c7-d64f88cca576" "14e664cd409-7a2dc0c380f9" "14e66326932-5c24bd6e6707" "14e663269e2-61fc90d7afec" ...
##  $ originalFileFormat : chr  "application/x-stata" "application/x-stata" NA NA ...
##  $ originalFormatLabel: chr  "Stata Binary" "Stata Binary" "UNKNOWN" "UNKNOWN" ...
##  $ UNF                : chr  "UNF:6:d9ZNXvmiPfiunSAiXRpVfg==" "UNF:6:B3/HJbnzktaX5eEJA2ItiA==" NA NA ...
##  $ rootDataFileId     : int  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ md5                : chr  "2132170a713e5a213ab87dcaea287250" "e8c62465ef6a1a8451a21a43ce7b264e" "cfd66db2e50b3142bcda576cf78dc057" "e9c536034e029450a79ce830e47dd463" ...
##  $ checksum           :'data.frame':	32 obs. of  2 variables:
```

Knowing a file name, you can also access that file (e.g., a Stata dataset) directly in R:


```r
f <- get_file("constructionData.tab", "doi:10.7910/DVN/ARKOTI")

# load it into memory
tmp <- tempfile(fileext = ".dta")
writeBin(as.vector(f), tmp)
dat <- foreign::read.dta(tmp)
```

If you don't know the file name in advance, you can parse the available files returned by `get_dataset()` and retrieve the file using its Dataverse "id" number.


### Data Archiving

The data archiving (or "deposit") workflow is built on [SWORD v2.0](http://swordapp.org/sword-v2/). This means that to create a new dataset listing, you will have first initialize a dataset entry with some metadata, add one or more files to the dataset, and then publish it. This looks something like the following:

```R
# retrieve your service document
d <- service_document()

# create a list of metadata
metadat <- list(title = "My Study",
                creator = "Doe, John",
                description = "An example study")

# create the dataset
dat <- initiate_dataset("mydataverse", body = metadat)

# add files to dataset
tmp <- tempfile()
write.csv(iris, file = tmp)
f <- add_file(dat, file = tmp)

# publish new dataset
publish_dataset(dat)

# dataset will now be published
list_datasets(dat)
```

Dataverse actually implements two ways to release datasets: the SWORD API and the "native" API. Documentation of the latter is forthcoming.

## Installation

[![CRAN Version](https://www.r-pkg.org/badges/version/dataverse)](https://cran.r-project.org/package=dataverse)
![Downloads](https://cranlogs.r-pkg.org/badges/dataverse)
[![Travis-CI Build Status](https://travis-ci.org/IQSS/dataverse-client-r.png?branch=master)](https://travis-ci.org/IQSS/dataverse-client-r)
[![codecov.io](https://codecov.io/github/IQSS/dataverse-client-r/coverage.svg?branch=master)](https://codecov.io/github/IQSS/dataverse-client-r?branch=master)

You can (eventually) find a stable release on [CRAN](https://cran.r-project.org/package=dataverse), or install the latest development version from GitHub:

```R
if (!require("ghit")) {
    install.packages("ghit")
}
ghit::install_github("iqss/dataverse-client-r")
library("dataverse")
```

Users interested in downloading metadata from archives other than Dataverse may be interested in Kurt Hornik's [OAIHarvester](https://cran.r-project.org/package=OAIHarvester) and Scott Chamberlain's [oai](https://cran.r-project.org/package=oai), which offer metadata download from any web repository that is compliant with the [Open Archives Initiative](http://www.openarchives.org/) standards. Additionally, [rdryad](https://cran.r-project.org/package=rdryad) uses OAIHarvester to interface with [Dryad](http://datadryad.org/). The [rfigshare](https://cran.r-project.org/package=rfigshare) package works in a similar spirit to **dataverse** with [https://figshare.com/](https://figshare.com/).

---

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)

