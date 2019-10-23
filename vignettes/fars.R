## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------

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
state_num <- 49
year <- 2014
fars_map_state(state_num, year)

