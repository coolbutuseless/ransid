

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Reset back to terminal defaults
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reset_code <- "\033[39m\033[49m"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert an R colour to a 216-colour ANSI string. Suitable for most terminals
#'
#' Ref: \url{https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit}
#'
#' If all the RGB colour components are equal then the colour is matched to one
#' of 24 grey levels, other wise it is converted to one of 216 standard colours.
#'
#' @param rcolour any R colour e.g. 'red', '#445566'
#'
#' @return ANSI escape string for the given colour as a foreground or background
#'         colour
#'
#' @importFrom grDevices col2rgb
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
col2bg <- function(rcolour) {
  code <- col2code(rcolour)
  paste0("\033[48;5;", code, "m")
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname col2bg
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
col2fg <- function(rcolour) {
  code <- col2code(rcolour)
  paste0("\033[38;5;", code, "m")
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname col2bg
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
col2code <- function(rcolour) {
  cols <- col2rgb(rcolour)

  is_grey        <- cols[1,] == cols[2,] & cols[2,] == cols[3,]
  possibly_white <- cols[1,] == 255L

  grey_code <- 232L + as.integer(round(cols[1,]/255 * 23))

  cols <- round(cols/255 * 5)
  colour_code <- 16L + 36L * cols[1,] + 6 * cols[2,] + cols[3,]

  ifelse(is_grey & !possibly_white, grey_code, colour_code)
}

