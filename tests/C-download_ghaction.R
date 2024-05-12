## ----knitr_options, echo=FALSE, results="hide"----------------------------------------------
options(width = 120)
knitr::opts_chunk$set(results = "hold")


## -------------------------------------------------------------------------------------------
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")


## -------------------------------------------------------------------------------------------
library("dataverse")
library("tibble") # to see dataframes in tidyverse-form


## ----echo=FALSE, message=FALSE,include=FALSE------------------------------------------------
energy <- get_dataframe_by_name(
  filename = "comprehensiveJapanEnergy.tab",
  dataset = "10.7910/DVN/ARKOTI",
  server = "dataverse.harvard.edu")


## ----eval=FALSE-----------------------------------------------------------------------------
## energy <- get_dataframe_by_name(
##   filename = "comprehensiveJapanEnergy.tab",
##   dataset = "10.7910/DVN/ARKOTI",
##   server = "dataverse.harvard.edu")


## -------------------------------------------------------------------------------------------
head(energy)


## -------------------------------------------------------------------------------------------
library(readr)
energy <- get_dataframe_by_name(
  filename = "comprehensiveJapanEnergy.tab",
  dataset = "10.7910/DVN/ARKOTI",
  server = "dataverse.harvard.edu",
  .f = function(x) read.delim(x, sep = "\t"))

head(energy)


## ----message=FALSE--------------------------------------------------------------------------
argentina_tab <- get_dataframe_by_name(
  filename = "alpl2013.tab",
  dataset = "10.7910/DVN/ARKOTI",
  server = "dataverse.harvard.edu")


## -------------------------------------------------------------------------------------------
str(argentina_tab$polling_place)


## -------------------------------------------------------------------------------------------
argentina_dta <- get_dataframe_by_name(
  filename = "alpl2013.tab",
  dataset = "10.7910/DVN/ARKOTI",
  server = "dataverse.harvard.edu",
  original = TRUE,
  .f = haven::read_dta)


## -------------------------------------------------------------------------------------------
str(argentina_dta$polling_place)


## -------------------------------------------------------------------------------------------
str(dataset_metadata("10.7910/DVN/ARKOTI", server = "dataverse.harvard.edu"),
    max.level = 2)


## ----eval = FALSE---------------------------------------------------------------------------
## code3 <- get_file("chapter03.R", "doi:10.7910/DVN/ARKOTI", server = "dataverse.harvard.edu")
## writeBin(code3, "chapter03.R")

