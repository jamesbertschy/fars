## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
library(dplyr)
library(magrittr)
library(fars)
library(maps)


## ------------------------------------------------------------------------
list.files(system.file("extdata", package = "fars"))


## ------------------------------------------------------------------------

make_filename(2013:2015)


## ------------------------------------------------------------------------
setwd(system.file("extdata", package = "fars"))
years <- c(2013, 2014, 2015)
fars_summarize_years(2013:2015)


## ------------------------------------------------------------------------
setwd(system.file("extdata", package = "fars"))
fars_map_state(49, 2014)


