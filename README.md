# R Client for Dataverse 4 Repositories #

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

### Data Discovery ###

Dataverse supplies a pretty robust search API to discover Dataverses, datasets, and files. The simplest searches simply consist of a query string:


```r
library("dataverse")
str(dataverse_search("Gary King"), 1)
```

```
## 10 of 1030 results retrieved
```

```
## 'data.frame':	10 obs. of  11 variables:
##  $ name        : chr  "Gary King" "Gary Cox" "Gov2001" "Solution to the Ecological Inference Problem: Reconstructing Individual Behavior from Aggregate Data" ...
##  $ type        : chr  "dataverse" "dataverse" "dataverse" "dataset" ...
##  $ url         : chr  "https://dataverse.harvard.edu/dataverse/king" "https://dataverse.harvard.edu/dataverse/gcox" "https://dataverse.harvard.edu/dataverse/gov2001" "http://dx.doi.org/10.3886/ICPSR01132.v1" ...
##  $ image_url   : chr  "https://dataverse.harvard.edu/api/access/dvCardImage/11" "https://dataverse.harvard.edu/api/access/dvCardImage/159" "https://dataverse.harvard.edu/api/access/dvCardImage/758" "https://dataverse.harvard.edu/api/access/dsCardImage/36856" ...
##  $ identifier  : chr  "king" "gcox" "gov2001" NA ...
##  $ published_at: chr  "2007-01-12T05:00:00Z" "2008-11-01T04:00:00Z" "2010-04-21T14:59:09Z" "2015-04-09T03:38:56Z" ...
##  $ description : chr  NA NA "This website is a dataverse for Gov 2001/Stat E200: Advanced Quantitative Research Methodology (Gary King). Here you can find r"| __truncated__ "These data make it possible to replicate all numerical results in Gary King (1997), A SOLUTION TO THE ECOLOGICAL INFERENCE PROB"| __truncated__ ...
##  $ global_id   : chr  NA NA NA "doi:10.3886/ICPSR01132.v1" ...
##  $ citationHtml: chr  NA NA NA "King, Gary, 1997, \"Solution to the Ecological Inference Problem: Reconstructing Individual Behavior from Aggregate Data\", <a "| __truncated__ ...
##  $ citation    : chr  NA NA NA "King, Gary, 1997, \"Solution to the Ecological Inference Problem: Reconstructing Individual Behavior from Aggregate Data\", doi"| __truncated__ ...
##  $ authors     :List of 10
```

More complicated searches might specify metadata fields:


```r
str(dataverse_search(author = "Gary King", title = "Ecological Inference"), 1)
```

```
## 10 of 1329 results retrieved
```

```
## 'data.frame':	10 obs. of  11 variables:
##  $ name        : chr  "Causal Inference with Complex Survey Designs" "Solution to the Ecological Inference Problem: Reconstructing Individual Behavior from Aggregate Data" "Replication data for: Detecting Model Dependence in Statistical Inference: A Response" "Replication data for: When Can History be Our Guide? The Pitfalls of Counterfactual Inference" ...
##  $ type        : chr  "dataverse" "dataset" "dataset" "dataset" ...
##  $ url         : chr  "https://dataverse.harvard.edu/dataverse/cicsd" "http://dx.doi.org/10.3886/ICPSR01132.v1" "http://hdl.handle.net/1902.1/FGSRBXXIYT" "http://hdl.handle.net/1902.1/DXRXCFAWPK" ...
##  $ image_url   : chr  "https://dataverse.harvard.edu/api/access/dvCardImage/2691323" "https://dataverse.harvard.edu/api/access/dsCardImage/36856" "https://dataverse.harvard.edu/api/access/dsCardImage/88888" "https://dataverse.harvard.edu/api/access/dsCardImage/88892" ...
##  $ identifier  : chr  "cicsd" NA NA NA ...
##  $ published_at: chr  "2015-07-03T19:00:00Z" "2015-04-09T03:38:56Z" "2014-08-21T00:00:00Z" "2014-08-21T00:00:00Z" ...
##  $ global_id   : chr  NA "doi:10.3886/ICPSR01132.v1" "hdl:1902.1/FGSRBXXIYT" "hdl:1902.1/DXRXCFAWPK" ...
##  $ description : chr  NA "These data make it possible to replicate all numerical results in Gary King (1997), A SOLUTION TO THE ECOLOGICAL INFERENCE PROB"| __truncated__ "Inferences about counterfactuals are essential for prediction, answering \"what if\" questions, and estimating causal effects. "| __truncated__ "Inferences about counterfactuals are essential for prediction, answering \"what if\" questions, and estimating causal effects. "| __truncated__ ...
##  $ citationHtml: chr  NA "King, Gary, 1997, \"Solution to the Ecological Inference Problem: Reconstructing Individual Behavior from Aggregate Data\", <a "| __truncated__ "King, Gary; Zeng, Langche, 2007, \"Replication data for: Detecting Model Dependence in Statistical Inference: A Response\", <a "| __truncated__ "King, Gary; Zeng, Langche, 2007, \"Replication data for: When Can History be Our Guide? The Pitfalls of Counterfactual Inferenc"| __truncated__ ...
##  $ citation    : chr  NA "King, Gary, 1997, \"Solution to the Ecological Inference Problem: Reconstructing Individual Behavior from Aggregate Data\", doi"| __truncated__ "King, Gary; Zeng, Langche, 2007, \"Replication data for: Detecting Model Dependence in Statistical Inference: A Response\", hdl"| __truncated__ "King, Gary; Zeng, Langche, 2007, \"Replication data for: When Can History be Our Guide? The Pitfalls of Counterfactual Inferenc"| __truncated__ ...
##  $ authors     :List of 10
```

And searches can be restricted to specific types of objects (Dataverse, dataset, or file):


```r
str(dataverse_search(author = "Gary King", type = "dataset"), 1)
```

```
## 10 of 637 results retrieved
```

```
## 'data.frame':	10 obs. of  11 variables:
##  $ name        : chr  "Gary King" "MTester " "KAUST Phenotyping" "Pietro Rodrigues" ...
##  $ type        : chr  "dataverse" "dataverse" "dataverse" "dataverse" ...
##  $ url         : chr  "https://dataverse.harvard.edu/dataverse/king" "https://dataverse.harvard.edu/dataverse/MTesterPhenoNet" "https://dataverse.harvard.edu/dataverse/KAUST_Pheno" "https://dataverse.harvard.edu/dataverse/pietrorodrigues" ...
##  $ image_url   : chr  "https://dataverse.harvard.edu/api/access/dvCardImage/11" "https://dataverse.harvard.edu/api/access/dvCardImage/2712449" "https://dataverse.harvard.edu/api/access/dvCardImage/2712448" "https://dataverse.harvard.edu/api/access/dvCardImage/2839087" ...
##  $ identifier  : chr  "king" "MTesterPhenoNet" "KAUST_Pheno" "pietrorodrigues" ...
##  $ published_at: chr  "2007-01-12T05:00:00Z" "2015-10-09T02:17:49Z" "2015-10-09T02:12:01Z" "2016-06-01T15:36:01Z" ...
##  $ description : chr  NA "KAUST sub-dataverse for Mark Tester's phenotyping datasets" "Dataverse for phenotyping research by KAUST collaborators." NA ...
##  $ global_id   : chr  NA NA NA NA ...
##  $ citationHtml: chr  NA NA NA NA ...
##  $ citation    : chr  NA NA NA NA ...
##  $ authors     :List of 10
```

The results are paginated using `per_page` argument. To retrieve subsequent pages, specify `start`.


### Data and Metadata Retrieval ###

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
##  $ description        : chr  "Salta, Argentina field experiment on e-voting versus traditional voting. Citation: Alvarez, R. Michael, Ines Levin, Julia Pomar"| __truncated__ "National Survey of High School Biology Teachers. Citation: Berkman, Michael and Eric Plutzer. 2010. Evolution, Creationism, and"| __truncated__ "Replication code for Chapter 1 (Obtaining R and Downloading Packages). No additional data required." "Replication code for Chapter 2 (Loading and Manipulating Data). Required data files: hmnrghts.txt, sen113kh.ord, hmnrghts.dta, "| __truncated__ ...
##  $ label              : chr  "alpl2013.tab" "BPchap7.tab" "chapter01.R" "chapter02.R" ...
##  $ version            : int  2 2 2 2 2 2 2 2 2 2 ...
##  $ datasetVersionId   : int  75170 75170 75170 75170 75170 75170 75170 75170 75170 75170 ...
##  $ categories         :List of 32
##  $ id                 : int  2692294 2692295 2692202 2692206 2692210 2692204 2692205 2692212 2692209 2692208 ...
##  $ filename           : chr  "alpl2013.tab" "BPchap7.tab" "chapter01.R" "chapter02.R" ...
##  $ contentType        : chr  "text/tab-separated-values" "text/tab-separated-values" "text/plain; charset=US-ASCII" "text/plain; charset=US-ASCII" ...
##  $ filesize           : int  210991 61284 1293 5591 5766 1938 2327 4064 7228 6433 ...
##  $ description        : chr  "Salta, Argentina field experiment on e-voting versus traditional voting. Citation: Alvarez, R. Michael, Ines Levin, Julia Pomar"| __truncated__ "National Survey of High School Biology Teachers. Citation: Berkman, Michael and Eric Plutzer. 2010. Evolution, Creationism, and"| __truncated__ "Replication code for Chapter 1 (Obtaining R and Downloading Packages). No additional data required." "Replication code for Chapter 2 (Loading and Manipulating Data). Required data files: hmnrghts.txt, sen113kh.ord, hmnrghts.dta, "| __truncated__ ...
##  $ storageIdentifier  : chr  "14e664cd3c7-d64f88cca576" "14e664cd409-7a2dc0c380f9" "14e66326932-5c24bd6e6707" "14e663269e2-61fc90d7afec" ...
##  $ originalFileFormat : chr  "application/x-stata" "application/x-stata" NA NA ...
##  $ originalFormatLabel: chr  "Stata Binary" "Stata Binary" "UNKNOWN" "UNKNOWN" ...
##  $ UNF                : chr  "UNF:6:d9ZNXvmiPfiunSAiXRpVfg==" "UNF:6:B3/HJbnzktaX5eEJA2ItiA==" NA NA ...
##  $ rootDataFileId     : int  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ md5                : chr  "2132170a713e5a213ab87dcaea287250" "e8c62465ef6a1a8451a21a43ce7b264e" "cfd66db2e50b3142bcda576cf78dc057" "e9c536034e029450a79ce830e47dd463" ...
##  $ checksum           :'data.frame':	32 obs. of  2 variables:
```

retrieve metadata:


```r
str(dataset_metadata("doi:10.7910/DVN/ARKOTI"), 1)
```

```
## List of 2
##  $ displayName: chr "Citation Metadata"
##  $ fields     :'data.frame':	7 obs. of  4 variables:
```

and even access files directly in R using the DOI and a filename:


```r
f <- get_file("constructionData.tab", "doi:10.7910/DVN/ARKOTI")

# load it into memory
tmp <- tempfile(fileext = ".dta")
writeBin(as.vector(f), tmp)
dat <- rio::import(tmp, haven = FALSE)
```

If you don't konw the file name in advance, you can parse the available files returned by `get_dataset()`:


```r
d1 <- get_dataset("doi:10.7910/DVN/ARKOTI")
f <- get_file(d1$files$dataFile$id[3])
```

```
## Error in get_file(d1$files$dataFile$id[3]): When 'file' is a character string, dataset must be specified. Or, use a global fileid instead.
```

### Data Deposit ###

The data deposit workflow is build on [SWORD v2.0](http://swordapp.org/sword-v2/). This means that to create a new dataset listing, you will have first initialize a dataset entry with some metadata, add one or more files to the dataset, and then publish it. This looks something like the following:

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

## Installation ##

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

