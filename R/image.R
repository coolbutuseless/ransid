

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert an image to an ANSI string
#'
#' @param im magick image
#' @param width text output width. default: 80
#' @param font_aspect ratio of width to height for the output font. default: 0.45
#' @param full_colour use 24bit colour codes. default: FALSE. Only supported by
#'        some terminals
#'
#' @return Character string with ANSI colours
#'
#' @import magick
#' @importFrom grDevices as.raster
#' @export
#'
#' @examples
#' \dontrun{
#' im <- image_read(system.file('img', 'Rlogo.png', package = 'png'))
#' cat(im2ansi(im, width = 80))
#' }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
im2ansi <- function(im, width = 80, font_aspect = 0.45, full_colour = FALSE) {

  mat <- im2char(im, width, font_aspect, full_colour)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Collapse
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  rows <- apply(mat, 1, paste0, collapse = "")
  rows <- paste0(rows, reset_code, "\n")
  paste0(rows, collapse = "")
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert an image to a matrix of ANSI chars
#'
#' @inheritParams im2ansi
#'
#' @return Character string with ANSI colours
#'
#' @import magick
#' @importFrom grDevices as.raster
#' @export
#'
#' @examples
#' \dontrun{
#' im <- image_read(system.file('img', 'Rlogo.png', package = 'png'))
#' mat <- im2char(im)
#' }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
im2char <- function(im, width = 80, font_aspect = 0.45, full_colour = FALSE) {

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Scale the image:
  #    * for the given font_aspect
  #    * for the given output width
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  info         <- image_info(im)
  width_factor <- width/info$width
  final_height <- info$height * width_factor * font_aspect
  final_height <- as.integer(round(final_height))

  im <- magick::image_resize(im, geometry = paste0(width, "x", final_height, "!"))

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Convert to raster
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ras <- grDevices::as.raster(im)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Get the ANSI match for each colour, and use it to colour a plain 'space'
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (full_colour) {
    ansi <- col2bg24(ras)
  } else {
    ansi <- col2bg(ras)
  }
  ansi <- paste0(ansi, ' ')

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Reshape for return to the user
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dim(ansi) <- rev(dim(ras))
  ansi <- t(ansi)

  ansi
}





if (FALSE) {
  im <- image_read(system.file('img', 'Rlogo.png', package = 'png'))
  res <- im2ansi(im, width = 80, full_colour = TRUE)
  cat(res)

  ff <- system.file('img', 'magpie.jpg', package = 'ggpattern')
  im <- image_read(ff)
  cat(im2ansi(im))
}
