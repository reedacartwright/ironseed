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

#' Initialize .Random.seed
#'
#' @param x an ironseed.
#' @param seed a previous `.Random.seed`
#' @param quiet a logical indicating whether to silence messages.
#'
#' @returns `fill_random_seed()` returns the previous value of `.Random.seed` or
#' `NULL`.
#'
#' @export
#' @keywords internal
fill_random_seed <- function(x, quiet = FALSE) {
  stopifnot(is_ironseed(x))
  if (isFALSE(quiet)) {
    msg <- sprintf(
      "** Ironseed : Seed %s v%s",
      format(x),
      format(utils::packageVersion("ironseed"))
    )
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
  if (is_mt) {
    seed[2] <- 624L
  }
  # update .Random.seed with our own state
  assign(".Random.seed", seed, globalenv(), inherits = FALSE)
  # draw one value to trigger seed fixup
  stats::runif(1)
  # return old seed
  invisible(oldseed)
}

#' @export
#' @keywords internal
#' @rdname fill_random_seed
has_random_seed <- function() {
  exists(".Random.seed", globalenv(), mode = "integer", inherits = FALSE)
}

#' @export
#' @keywords internal
#' @rdname fill_random_seed
get_random_seed <- function() {
  get0(
    ".Random.seed",
    globalenv(),
    mode = "integer",
    inherits = FALSE,
    ifnotfound = NULL
  )
}

#' @export
#' @keywords internal
#' @rdname fill_random_seed
set_random_seed <- function(seed) {
  oldseed <- get_random_seed()
  if (!is.null(seed)) {
    assign(".Random.seed", seed, globalenv(), inherits = FALSE)
  } else if (!is.null(oldseed)) {
    rm_random_seed()
  }
  invisible(oldseed)
}

rm_random_seed <- function() {
  oldseed <- get_random_seed()
  suppressWarnings(rm(".Random.seed", envir = globalenv(), inherits = FALSE))
  the$ironseed <- NULL
  invisible(oldseed)
}
