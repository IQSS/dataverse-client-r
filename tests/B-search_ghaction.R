## ----knitr_options, echo=FALSE, results="hide"----------------------------------------------
options(width = 120)
knitr::opts_chunk$set(results = "hold")


## -------------------------------------------------------------------------------------------
library("dataverse")
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")
dataverse_search("Gary King")[c("name")]


## -------------------------------------------------------------------------------------------
dataverse_search("Gary King", start = 6, per_page = 20)[c("name")]


## -------------------------------------------------------------------------------------------
ei <- dataverse_search(author = "Gary King", title = "Ecological Inference", type = "dataset", per_page = 20)
# fields returned
names(ei)
# names of datasets
ei$name

