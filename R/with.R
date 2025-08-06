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

#' Temporary ironseeds
#'
#' `with_ironseed()` runs code with a specific ironseed and restores global
#' state afterwards. `local_ironseed()` restores global state when the current
#' evaluation state ends.
#'
#' @inheritParams ironseed
#' @param seeds An object or list of objects suitable for constructing an
#' ironseed.
#' @param func A stream function returned by `ironseed_stream()`
#' @param ... Additional objects.
#' @param code Code to execute in the temporary environment.
#' @param .local_envir The environment to use for scoping.
#'
#' @returns `with_ironseed()` returns the results of the evaluation of the code
#' argument. `local_ironseed()` returns the constructed ironseed.
#'
#' @seealso [ironseed] [ironseed_stream]
#'
#' @export
with_ironseed <- function(
  seeds,
  code,
  quiet = FALSE
) {
  old_ironseed <- the$ironseed
  seeds <- simplify_list(list(seeds))
  fe <- create_ironseed(seeds)
  old_seed <- fill_random_seed(fe, quiet = quiet)
  the$ironseed <- fe
  on.exit({
    the$ironseed <- old_ironseed
    set_random_seed(old_seed)
  })
  force(code)
}

#' @export
#' @rdname with_ironseed
local_ironseed <- function(
  seeds,
  ...,
  quiet = FALSE,
  .local_envir = parent.frame()
) {
  old_ironseed <- the$ironseed
  seeds <- simplify_list(list(seeds))
  seeds <- c(seeds, list(...))
  fe <- create_ironseed(seeds)
  old_seed <- fill_random_seed(fe, quiet = quiet)
  the$ironseed <- fe
  defer(envir = .local_envir, {
    the$ironseed <- old_ironseed
    set_random_seed(old_seed)
  })
  invisible(fe)
}

#' @export
#' @rdname with_ironseed
with_ironseed_stream <- function(
  func,
  code
) {
  stopifnot(is.function(func))
  old_seed <- fill_random_seed(func, quiet = TRUE)
  on.exit({
    set_random_seed(old_seed)
  })
  force(code)
}

#' @export
#' @rdname with_ironseed
local_ironseed_stream <- function(
  func,
  .local_envir = parent.frame()
) {
  stopifnot(is.function(func))
  old_seed <- fill_random_seed(func, quiet = TRUE)
  defer(envir = .local_envir, {
    set_random_seed(old_seed)
  })
  invisible(NULL)
}
