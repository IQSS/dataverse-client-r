R Client for Dataverse 4 Repositories
================

[![CRAN
Version](https://www.r-pkg.org/badges/version/dataverse)](https://cran.r-project.org/package=dataverse)
![Downloads](https://cranlogs.r-pkg.org/badges/dataverse) [![Travis-CI
Build
Status](https://travis-ci.org/IQSS/dataverse-client-r.png?branch=master)](https://travis-ci.org/IQSS/dataverse-client-r)
[![codecov.io](https://codecov.io/github/IQSS/dataverse-client-r/coverage.svg?branch=master)](https://codecov.io/github/IQSS/dataverse-client-r?branch=master)

[![Dataverse Project
logo](http://dataverse.org/files/dataverseorg/files/dataverse_project_logo-hp.png "Dataverse Project")](http://dataverse.org)

The **dataverse** package provides access to [Dataverse
4](http://dataverse.org/) APIs, enabling data search, retrieval, and
deposit, thus allowing R users to integrate public data sharing into the
reproducible research workflow. **dataverse** is the next-generation
iteration of [the **dvn**
package](https://cran.r-project.org/package=dvn), which works with
Dataverse 3 (“Dataverse Network”) applications. **dataverse** includes
numerous improvements for data search, retrieval, and deposit, including
use of the (currently in development) **sword** package for data deposit
and the **UNF** package for data fingerprinting.

### Getting Started

You can find a stable 2017 release on
[CRAN](https://cran.r-project.org/package=dataverse), or install the
latest development version from GitHub:

``` r
library("dataverse")
```

### Keys

Some features of the Dataverse 4 API are public and require no
authentication. This means in many cases you can search for and retrieve
data without a Dataverse account for that a specific Dataverse
installation. But, other features require a Dataverse account for the
specific server installation of the Dataverse software, and an API key
linked to that account. Instructions for obtaining an account and
setting up an API key are available in the [Dataverse User
Guide](http://guides.dataverse.org/en/latest/user/account.html). (Note:
if your key is compromised, it can be regenerated to preserve security.)
Once you have an API key, this should be stored as an environment
variable called `DATAVERSE_KEY`. It can be set within R using:

``` r
Sys.setenv("DATAVERSE_KEY" = "examplekey12345")
```

### Server

Because [there are many Dataverse installations](http://dataverse.org/),
all functions in the R client require specifying what server
installation you are interacting with. This can be set by default with
an environment variable, `DATAVERSE_SERVER`. This should be the
Dataverse server, without the “https” prefix or the “/api” URL path,
etc. For example, the Harvard Dataverse can be used by setting:

``` r
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")
```

Note: The package attempts to compensate for any malformed values,
though.

Currently, the package wraps the data management features of the
Dataverse API. Functions for other API features - related to user
management and permissions - are not currently exported in the package
(but are drafted in the [source
code](https://github.com/IQSS/dataverse-client-r)).

### Data and Metadata Retrieval

Datasets on Dataverse are directly downloadable by their API, and this
is straightforward especially if the data is not restricted. The
dataverse package provides multiple interfaces. Users can supply a file
DOI, a dataset DOI combined with a filename, or a dataverse object. They
can read in the file as a raw binary or a dataset read in with the
appropriate R function.

#### Reading data as R objects

Use the `get_dataframe_*` functions, depending on the input you have.
For example, we will read a survey dataset on dataverse,
[nlsw88.dta](https://demo.dataverse.org/file.xhtml?persistentId=doi:10.70122/FK2/PPKHI1/ZYATZZ)
(`doi:10.70122/FK2/PPKHI1/ZYATZZ`), originally in Stata dta form.

With a file DOI

``` r
nlsw <- get_dataframe_by_doi("10.70122/FK2/PPIAXE/MHDB0O", 
                             server = "demo.dataverse.org")
```

    ## Warning in get_dataframe_by_id(file = filedoi, FUN = FUN, original = original, : Downloading ingested version of data with read_tsv. To download the original version and remove this warning, set original = TRUE.

    ## Parsed with column specification:
    ## cols(
    ##   idcode = col_double(),
    ##   age = col_double(),
    ##   race = col_double(),
    ##   married = col_double(),
    ##   never_married = col_double(),
    ##   grade = col_double(),
    ##   collgrad = col_double(),
    ##   south = col_double(),
    ##   smsa = col_double(),
    ##   c_city = col_double(),
    ##   industry = col_double(),
    ##   occupation = col_double(),
    ##   union = col_double(),
    ##   wage = col_double(),
    ##   hours = col_double(),
    ##   ttl_exp = col_double(),
    ##   tenure = col_double()
    ## )

Alternatively, we can download the same file by specifying the filename
and the DOI of the “dataset” (in Dataverse, a collection of files is
called a dataset).

``` r
nlsw_tsv <- get_dataframe_by_name(file = "nlsw88.tab",
                                  dataset = "10.70122/FK2/PPIAXE", 
                                  server = "demo.dataverse.org")
```

    ## Warning in get_dataframe_by_id(fileid, FUN, original = original, ...): Downloading ingested version of data with read_tsv. To download the original version and remove this warning, set original = TRUE.

Many file formats are translated into an ingested, or “archival”
version, which is application-neutral and easily-readable.
`read_dataframe` takes this ingested version as a default by deafaulting
`original = FALSE`. This is safer because you may not have the
properietary software that was originally used. On the other hand, using
the ingested version may lead to loss of information.

To read the same file but its original version, specify
`original = TRUE` and set a `FUN` argument. In this case, we know that
`nlsw88.tab` is a Stata `.dta` dataset, so we will use the
`haven::read_dta` function.

``` r
nlsw_original <- get_dataframe_by_name(file = "nlsw88.tab",
                                       dataset = "10.70122/FK2/PPIAXE", 
                                       FUN = haven::read_dta,
                                       original = TRUE,
                                       server = "demo.dataverse.org")
```

Note that even though the file prefix is “.tab”, we use `read_dta`.

Note the difference between `nls_tsv` and `nls_original`. `nls_original`
preserves the data attributes like value labels, whereas `nls_tsv` has
dropped this or left this in file metadata.

``` r
class(nlsw_tsv$race)
class(nlsw_original$race)

head(nlsw_tsv$race)
head(haven::as_factor(nlsw_original$race))
```

    ## [1] "numeric"
    ## [1] "haven_labelled" "vctrs_vctr"     "double"        
    ## [1] 2 2 2 1 1 1
    ## [1] black black black white white white
    ## Levels: white black other

You may know the underlying file ID, which is a single numeric number
unique to the dataset. In this case, the fileid is `1734017`

``` r
nlsw <- get_dataframe_by_id(fileid = 1734017,
                            FUN = haven::read_dta,
                            original = TRUE,
                            server = "demo.dataverse.org")
```

#### Reading a dataset as a binary file.

In some cases, you may not need to render the raw binary file, or you do
not have the functions to do so in R, so you want to write these into
your local disk. To take only the raw files, use the `get_file`
commands. The arguments are equivalent, except we do need a \`FUN\`
argument

``` r
nlsw_raw <- get_file_by_name(file = "nlsw88.tab",
                             dataset = "10.70122/FK2/PPIAXE", 
                             server = "demo.dataverse.org")
class(nlsw_raw)
```

    ## [1] "raw"

The function `get_file_metadata` can also be used similarly. This will
return a metadata format for ingested tabular files in the `ddi` format.
The function `get_dataset` will retrieve the list of files in a dataset.

``` r
get_dataset(dataset = "10.70122/FK2/PPIAXE",
            server = "demo.dataverse.org")
```

    ## Dataset (182162): 
    ## Version: 1.1, RELEASED
    ## Release Date: 2020-12-30T00:00:24Z
    ## License: CC0
    ## 22 Files:
    ##                   label version      id               contentType
    ## 1 nlsw88_rds-export.rds       1 1734016  application/octet-stream
    ## 2            nlsw88.tab       3 1734017 text/tab-separated-values

### Data Discovery

Dataverse supplies a pretty robust search API to discover Dataverses,
datasets, and files. The simplest searches simply consist of a query
string:

``` r
dataverse_search("Gary King")
```

More complicated searches might specify metadata fields:

``` r
dataverse_search(author = "Gary King", title = "Ecological Inference")
```

And searches can be restricted to specific types of objects (Dataverse,
dataset, or file):

``` r
str(dataverse_search(author = "Gary King", type = "dataset"), 1)
```

    ## 10 of 701 results retrieved

    ## 'data.frame':    10 obs. of  27 variables:
    ##  $ name                   : chr  "10 Million International Dyadic Events" "1479 data points of covid19 policy response times" "A Comparative Analysis of Brazil's Foreign Policy Drivers Towards the USA: Comment on Amorim Neto (2011)" "A Framework to Quantify the Signs of Abandonment in Online Digital Humanities Projects" ...
    ##  $ type                   : chr  "dataset" "dataset" "dataset" "dataset" ...
    ##  $ url                    : chr  "https://doi.org/10.7910/DVN/BTMQA0" "https://doi.org/10.7910/DVN/6VMRYG" "https://doi.org/10.7910/DVN/K6H0LV" "https://doi.org/10.34894/YNQOQT" ...
    ##  $ global_id              : chr  "doi:10.7910/DVN/BTMQA0" "doi:10.7910/DVN/6VMRYG" "doi:10.7910/DVN/K6H0LV" "doi:10.34894/YNQOQT" ...
    ##  $ description            : chr  "When the Palestinians launch a mortar attack into Israel, the Israeli army does not wait until the end of the c"| __truncated__ "a data set of 1479 time data points of policy responses to covid19" "This paper looks at the main finding by Amorim Neto (2011), namely that Brazil's power explains why it distance"| __truncated__ "Abstract of paper 0429 presented at the Digital Humanities Conference 2019 (DH2019), Utrecht , the Netherlands "| __truncated__ ...
    ##  $ published_at           : chr  "2014-08-21T00:00:00Z" "2020-09-14T20:25:40Z" "2017-10-30T20:30:58Z" "2020-06-20T00:00:11Z" ...
    ##  $ publisher              : chr  "Gary King Dataverse" "Jose Oriol Lopez Berengueres Dataverse" "Francisco Urdinez Dataverse" "DataverseNL Harvested Dataverse" ...
    ##  $ citationHtml           : chr  "King, Gary; Lowe, Will, 2008, \"10 Million International Dyadic Events\", <a href=\"https://doi.org/10.7910/DVN"| __truncated__ "Stephens, Melodena; Lopez Berengueres, Jose Oriol; Moonesar, Imanuel; Venkatapuram,Sridhar, 2020, \"1479 data p"| __truncated__ "Urdinez, Francisco; Mour&oacute;n, Fernando, 2017, \"A Comparative Analysis of Brazil's Foreign Policy Drivers "| __truncated__ "Meneses, Luis; Martin, Jonathan; Furuta, Richard; Siemens, Ray, 2020, \"A Framework to Quantify the Signs of Ab"| __truncated__ ...
    ##  $ identifier_of_dataverse: chr  "king" "covid19_policy_timing" "furdinez" "dataverseNL_harvested" ...
    ##  $ name_of_dataverse      : chr  "Gary King Dataverse" "Jose Oriol Lopez Berengueres Dataverse" "Francisco Urdinez Dataverse" "DataverseNL Harvested Dataverse" ...
    ##  $ citation               : chr  "King, Gary; Lowe, Will, 2008, \"10 Million International Dyadic Events\", https://doi.org/10.7910/DVN/BTMQA0, H"| __truncated__ "Stephens, Melodena; Lopez Berengueres, Jose Oriol; Moonesar, Imanuel; Venkatapuram,Sridhar, 2020, \"1479 data p"| __truncated__ "Urdinez, Francisco; Mourón, Fernando, 2017, \"A Comparative Analysis of Brazil's Foreign Policy Drivers Towards"| __truncated__ "Meneses, Luis; Martin, Jonathan; Furuta, Richard; Siemens, Ray, 2020, \"A Framework to Quantify the Signs of Ab"| __truncated__ ...
    ##  $ storageIdentifier      : chr  "s3://dvn-cloud:1902.1/FYXLAWZRIA" "s3://10.7910/DVN/6VMRYG" "file" "s3://10.34894/YNQOQT" ...
    ##  $ subjects               :List of 10
    ##  $ fileCount              : int  48 1 3 1 6 2 1 0 1 0
    ##  $ versionId              : int  124550 211215 130184 199743 192022 148741 40034 99077 41546 113568
    ##  $ versionState           : chr  "RELEASED" "RELEASED" "RELEASED" "RELEASED" ...
    ##  $ majorVersion           : int  5 1 1 2 6 1 NA NA NA NA
    ##  $ minorVersion           : int  3 1 0 NA 0 0 NA NA NA NA
    ##  $ createdAt              : chr  "2007-03-30T20:35:23Z" "2020-09-14T19:51:08Z" "2017-10-28T01:22:23Z" "2020-06-22T06:20:18Z" ...
    ##  $ updatedAt              : chr  "2017-03-07T21:32:59Z" "2020-09-15T15:23:44Z" "2017-10-30T20:30:58Z" "2020-06-22T06:20:18Z" ...
    ##  $ contacts               :List of 10
    ##  $ publications           :List of 10
    ##  $ authors                :List of 10
    ##  $ geographicCoverage     :List of 10
    ##  $ keywords               :List of 10
    ##  $ producers              :List of 10
    ##  $ dataSources            :List of 10

The results are paginated using `per_page` argument. To retrieve
subsequent pages, specify `start`.

### Data Archiving

Dataverse provides two - basically unrelated - workflows for managing
(adding, documenting, and publishing) datasets. The first is built on
[SWORD v2.0](http://swordapp.org/sword-v2/). This means that to create a
new dataset listing, you will have first initialize a dataset entry with
some metadata, add one or more files to the dataset, and then publish
it. This looks something like the following:

``` r
# retrieve your service document
d <- service_document()

# create a list of metadata
metadat <- list(title = "My Study",
                creator = "Doe, John",
                description = "An example study")

# create the dataset
ds <- initiate_sword_dataset("mydataverse", body = metadat)

# add files to dataset
tmp <- tempfile()
write.csv(iris, file = tmp)
f <- add_file(ds, file = tmp)

# publish new dataset
publish_sword_dataset(ds)

# dataset will now be published
list_datasets("mydataverse")
```

The second workflow is called the “native” API and is similar but uses
slightly different functions:

``` r
# create the dataset
ds <- create_dataset("mydataverse")

# add files
tmp <- tempfile()
write.csv(iris, file = tmp)
f <- add_dataset_file(file = tmp, dataset = ds)

# publish dataset
publish_dataset(ds)

# dataset will now be published
get_dataverse("mydataverse")
```

Through the native API it is possible to update a dataset by modifying
its metadata with `update_dataset()` or file contents using
`update_dataset_file()` and then republish a new version using
`publish_dataset()`.

### Other Installations

Users interested in downloading metadata from archives other than
Dataverse may be interested in Kurt Hornik’s
[OAIHarvester](https://cran.r-project.org/package=OAIHarvester) and
Scott Chamberlain’s [oai](https://cran.r-project.org/package=oai), which
offer metadata download from any web repository that is compliant with
the [Open Archives Initiative](http://www.openarchives.org/) standards.
Additionally, [rdryad](https://cran.r-project.org/package=rdryad) uses
OAIHarvester to interface with [Dryad](http://datadryad.org/). The
[rfigshare](https://cran.r-project.org/package=rfigshare) package works
in a similar spirit to **dataverse** with <https://figshare.com/>.
