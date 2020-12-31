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

#### Keys

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

#### Server

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

The dataverse package provides multiple interfaces to obtain data into
R. Users can supply a file DOI, a dataset DOI combined with a filename,
or a dataverse object. They can read in the file as a raw binary or a
dataset read in with the appropriate R function.

#### Reading data as R objects

Use the `get_dataframe_*` functions, depending on the input you have.
For example, we will read a survey dataset on Dataverse,
[nlsw88.dta](https://demo.dataverse.org/file.xhtml?persistentId=doi:10.70122/FK2/PPKHI1/ZYATZZ)
(`doi:10.70122/FK2/PPKHI1/ZYATZZ`), originally in Stata dta form.

With a file DOI, we can use the `get_dataframe_by_doi` function:

``` r
nlsw <- get_dataframe_by_doi("10.70122/FK2/PPIAXE/MHDB0O", 
                             server = "demo.dataverse.org")
```

    ## Warning in get_dataframe_by_id(fileid = filedoi, FUN = FUN, original = original, : Downloading ingested version of data with read_tsv. To download the original version and remove this warning, set original = TRUE.

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

which by default reads in the ingested file (not the original dta) by
the
[`readr::read_tsv`](https://readr.tidyverse.org/reference/read_delim.html)
function.

Alternatively, we can download the same file by specifying the filename
and the DOI of the “dataset” (in Dataverse, a collection of files is
called a dataset).

``` r
nlsw_tsv <- get_dataframe_by_name(filename = "nlsw88.tab",
                                  dataset = "10.70122/FK2/PPIAXE", 
                                  server = "demo.dataverse.org")
```

    ## Warning in get_dataframe_by_id(fileid, FUN, original = original, ...): Downloading ingested version of data with read_tsv. To download the original version and remove this warning, set original = TRUE.

Now, Dataverse often translates rectangular data into an ingested, or
“archival” version, which is application-neutral and easily-readable.
`read_dataframe_*` defaults to taking this ingested version rather than
using the original, through the argument `original = FALSE`.

This default is safe because you may not have the proprietary software
that was originally used. On the other hand, the data may have lost
information in the process of the ingestation.

Instead, to read the same file but its original version, specify
`original = TRUE` and set a `FUN` argument. In this case, we know that
`nlsw88.tab` is a Stata `.dta` dataset, so we will use the
`haven::read_dta` function.

``` r
nlsw_original <- get_dataframe_by_name(filename = "nlsw88.tab",
                                       dataset = "10.70122/FK2/PPIAXE", 
                                       FUN = haven::read_dta,
                                       original = TRUE,
                                       server = "demo.dataverse.org")
```

Note that even though the file prefix is “.tab”, we use `read_dta`.

Of course, when the dataset is not ingested (such as a Rds file), users
would always need to specify a `FUN` argument for the specific file.

Note the difference between `nls_tsv` and `nls_original`. `nls_original`
preserves the data attributes like value labels, whereas `nls_tsv` has
dropped this or left this in file metadata.

``` r
class(nlsw_tsv$race) # tab ingested version only has numeric data
```

    ## [1] "numeric"

``` r
attr(nlsw_original$race, "labels") # original dta has value labels
```

    ## white black other 
    ##     1     2     3

#### Reading a dataset as a binary file.

In some cases, you may not want to read in the data in your environment,
perhaps because that is not possible (e.g. for a `.docx` file), and you
want to simply write these files your local disk. To do this, use the
more primitive `get_file_*` commands. The arguments are equivalent,
except we no longer need a `FUN` argument

``` r
nlsw_raw <- get_file_by_name(filename = "nlsw88.tab",
                             dataset = "10.70122/FK2/PPIAXE", 
                             server = "demo.dataverse.org")
class(nlsw_raw)
```

    ## [1] "raw"

#### Reading file metadata

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

Dataverse supplies a robust search API to discover Dataverses, datasets,
and files. The simplest searches simply consist of a query string:

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
dataverse_search(author = "Gary King", type = "dataset")
```

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
