# MIT License
#
# Copyright (c) 2025 Reed A. Cartwright <racartwright@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

the <- new.env(parent = emptyenv())

#' @export
ironseed <- function(..., set_seed = !has_random_seed(), quiet = FALSE) {
  x <- list(...)
  n <- length(x)

  # construct ironseed object based on arguments
  if(n == 0L && !isTRUE(set_seed)) {
    fe <- the$ironseed
  } else if(n == 0L || (n == 1L && is.null(x[[1]]))) {
    fe <- auto_ironseed();
  } else if(n == 1L && is_ironseed2(x[[1]])) {
    fe <- as_ironseed(x[[1]])
  } else {
    fe <- create_ironseed(x)
  }

  if(!isTRUE(set_seed)) {
    return(fe)
  }
  fill_random_seed(fe, quiet = quiet)
  the$ironseed <- fe
  invisible(fe)
}

has_random_seed <- function() {
  exists(".Random.seed", globalenv(), mode = "integer", inherits = FALSE)
}

get_random_seed <- function() {
  get0(".Random.seed", globalenv(), mode = "integer",
    inherits = FALSE, ifnotfound = NULL)
}

#' @export
#' @keywords internal
#' @importFrom stats runif
fill_random_seed <- function(x, quiet = FALSE) {
  stopifnot(is_ironseed(x))
  if(isFALSE(quiet)) {
    msg <- sprintf("** Ironseed : Seed %s", str(x))
    message(msg)    
  }
  # save oldseed
  oldseed <- get_random_seed()
  # use set.seed to flush seed space and get again
  set.seed(1)
  seed <- get_random_seed()
  is_mt <- seed[2] == 624L

  # generate a seed sequence of the correct length
  seed[-1] <- create_seedseq(x, length(seed) - 1)
  # if seed[2] = 625, then MT will think it is uninitialized
  # set seed[2] to 624 to signal that it is initialized 
  if(is_mt) {
    seed[2] <- 624L
  }
  # update .Random.seed with our own state
  assign(".Random.seed", seed, globalenv())
  # draw one value to trigger seed fixup
  runif(1)
  # return old seed
  invisible(oldseed)
}

#' @export
#' @keywords internal
create_ironseed <- function(x) {
  if(is.list(x)) {
    x <- lapply(x, unlist, use.names = FALSE)
  } else {
    x <- list(x)
  }
  .Call(R_create_ironseed, x)
}

#' @export
#' @keywords internal
auto_ironseed <- function() {
  .Call(R_auto_ironseed)
}

#' @export
#' @keywords internal
create_seedseq <- function(x, n) {
  x <- as.integer(x)
  n <- as.integer(n)
  stopifnot(length(x) == 8L)
  .Call(R_create_seedseq, x, n)
}

ironseed_re <- paste0("^[1-9A-HJ-NP-Za-km-z]{11}",
                      "-[1-9A-HJ-NP-Za-km-z]{11}",
                      "-[1-9A-HJ-NP-Za-km-z]{11}",
                      "-[1-9A-HJ-NP-Za-km-z]{11}$")

#' @export
is_ironseed <- function(x) {
  inherits(x, "ironseed_ironseed")
}

#' @export
is_ironseed_str <- function(x) {
  is.character(x) && length(x) == 1L && grepl(ironseed_re, x)
}

is_ironseed2 <- function(x) {
  is_ironseed(x) || is_ironseed_str(x)
}

#' @export
as_ironseed <- function(x) {
  if(is_ironseed(x)) {
    x
  } else if(is_ironseed_str(x)) {
    x <- parse_ironseed_str(x)
    structure(x, class="ironseed_ironseed")
  } else if(is.numeric(x) && length(x) == 8L) {
    x <- is.integer(x)
    structure(x, class="ironseed_ironseed")
  } else {
    stop("unable to convert `x` to ironseed")
  }
}

#' @export
#' @importFrom utils str
str.ironseed_ironseed <- function(object, ...) {
  stopifnot(length(object) == 8)
  x <- as.integer(object)

  # pack into 4 doubles
  x <- packBits(intToBits(x), "double")
  x <- .Call(R_base58_encode64, x)

  # Concatenate
  paste0(x, collapse = "-")
}

#' @export
print.ironseed_ironseed <- function(x, ...) {
  cat("Ironseed: ")
  cat(str(x), sep = "\n")
}

#' @export
#' @keywords internal
parse_ironseed_str <- function(x) {
  x <- as.character(x)[1]
  x <- strsplit(x, "-")[[1]]
  x <- base58_decode64(x)
  x <- numToInts(x)
  x
}

# encodes 64-bit doubles into base58 format
base58_encode64 <- function(x) {
  x <- as.numeric(x)
  .Call(R_base58_encode64, x)
}

# reverse of base58_encode64
base58_decode64 <- function(x) {
  x <- as.character(x)
  .Call(R_base58_decode64, x)
}
