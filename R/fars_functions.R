
# setwd(file.path("H:", "Coursera", "Package", "data"))


#' Reading CSV into R
#'
#' @param filename Name filename
#' @return Returns a tibble data frame
#' @details This function reads a csv file and returns a tibble data frame. If the path does not exist it will produce an error message.
#' @author James Bertschy \email{james.bertschy@@gmail.ch}
#' @import dplyr
#' @examples
#' \dontrun{fars_read("accident_2013.csv")}
#' @export

fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}


#' Generate a file name
#'
#' @param year Define year for making filename
#' @return Returns a string name
#' @details This function generates a string accident_year.cs.bz2
#' @author James Bertschy \email{james.bertschy@@gmail.ch}
#' @examples \dontrun{make_filename(2013)}
#' @export

make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}


#' Reading CSV into list
#'
#' @param years A vector
#' @return Returns a list of each year
#' @details This function puts all input table into one list. There will be an error message when the year is not invalid.
#' @author James Bertschy \email{james.bertschy@@gmail.ch}
#' @import dplyr
#' @examples \dontrun{fars_read_years(2013:2015)}
#' @export

fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}


#' Summary of number of observation per month and year
#'
#' @param years a vector
#' @return Returns a tibble summary table
#' @details This function counts the number of observation per month and year
#' @author James Bertschy \email{james.bertschy@@gmail.ch}
#' @import dplyr
#' @import magrittr
#' @examples \dontrun{fars_summarize_years(2013:2015)}
#' @export

fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}


#' Plots a map for a specific state
#'
#' @param year a string
#' @param state.num give number of state
#' @return plots a graph for defined state
#' @details This function plots a graph for definded state.
#' @author James Bertschy \email{james.bertschy@@gmail.ch}
#' @import dplyr
#' @import maps
#' @examples  \dontrun{fars_map_state(29, 2015)}
#' @export

fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}

