
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ransid

<!-- badges: start -->

![](https://img.shields.io/badge/cool-useless-green.svg)
<!-- badges: end -->

`ransid` converts images to ANSI text which can be displayed in the
console.

Note to be confused with:

  - [ransid - Rust ANSI
    Driver](https://gitlab.redox-os.org/redox-os/ransid)

## Installation

You can install `ransid` from
[github](https://github.com/coolbutuseless/ransid) with:

``` r
# install.packages('remotes')
remotes::install_github("coolbutuseless/ransid")
```

## Example

**Note** - because ANSI is for display in a terminal, it does not render
in a markdown document. The following images are screenshots of my
Rstudio terminal

``` r
im <- image_read(system.file('img', 'Rlogo.png', package = 'png'))
cat(im2ansi(im, width = 120))
```

<img src="man/figures/R.png" width="100%" />

``` r
im <- magick::image_read('https://www.fillmurray.com/300/250')
cat(im2ansi(im, width = 120))
```

<img src="man/figures/murray.png" width="100%" />

``` r
im <- magick::image_read('https://placekitten.com/300/200')
cat(im2ansi(im, width = 120))
```

<img src="man/figures/kitten.png" width="100%" />
