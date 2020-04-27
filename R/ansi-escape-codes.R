

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Reset back to terminal defaults
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reset_code <- "\033[39m\033[49m"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert an R colour to an ansi string
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
  cols <- t(col2rgb(rcolour))

  # ToDo: vectorise properly
  innerf <- function(col) {
    if (col[1] == col[2] && col[2] == col[3] && col[1] != 255) {
      # grey scale
      val <- as.integer(round(col[1]/255 * 23))
      code <- 232L + val
    } else {
      # colour
      col  <- as.integer(round(col/255 * 5))
      code <- 16L + 36L * col[1] + 6 * col[2] + col[3]
    }
    code
  }

  apply(cols, 1, innerf)
}

