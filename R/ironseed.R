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

#' Ironseed: Improved Random Number Generator Seeding
#'
#' @description
#'
#' An ironseed is a 256-bit hash digest constructed from a variable-length
#' input sequence and can be used to generate a variable-length output sequence
#' of seeds, including initializing R's built-in random number generator.
#'
#' - `ironseed()` creates an ironseed from user supplied objects, from external
#'  arguments, or automatically from multiple sources of entropy on the local
#'  system. It also initializes R's built-in random number generator from an
#'  ironseed.
#'
#' - `create_ironseed()` constructs an ironseed from a list of seed objects,
#'   following the rules described below.
#'
#' - `set_ironseed()` calls `ironseed()` with set_seed = TRUE.
#'
#' - `is_ironseed()` tests whether an object is an ironseed, and
#'   `is_ironseed_str()` tests if it is a string representing and ironseed.
#'
#' - `as_ironseed()` casts an object to an ironseed, and `parse_ironseed_str()`
#'   parses a string to an ironseed.
#'
#' @param ... objects
#' @param set_seed a logical indicating whether to initialize `.Random.seed`.
#' @param quiet a logical indicating whether to silence messages.
#' @param methods a character vector.
#' @param fe an ironseed
#' @param x a string, ironseed, list, or other object
#'
#' @returns An ironseed. If `.Random.seed` was initialized, the ironseed used
#'   will be returned invisibly.
#'
#' @details
#'
#' Ironseeds have a specific string representation, e.g.
#' "rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1", where each element is a
#' 64-bit number encoded in little-endian base58 format.
#'
#' Parameter `set_seed` defaults to `TRUE` if `.Random.seed` does not already
#' exist and `FALSE` otherwise.
#'
#' Ironseed behaves differently depending on the number of arguments passed as
#' `...` and the value of `methods`. If `...` has a length of zero **and**
#' initialization is disabled, then `ironseed()` returns the last ironseed used
#' to initialize `.Random.seed`. Otherwise, it generates an ironseed from an
#' input sequence according to the methods included in `methods`.
#'
#' When generating an ironseed, `ironseed()` tries the listed methods starting
#' from the first value and continuing until it can generate an ironseed. If no
#' method works, an error will be raised.
#'
#' - dots: Use the values passed as `...` to construct an ironseed. Most atomic
#' types and lists of atomic types can be used. `ironseed()` and
#' `ironseed(NULL)` are considered empty inputs and the next method will be
#' tried.
#'
#' - args: Use command line arguments to construct an ironseed. Any arguments
#' that begins with `--seed=` or `-seed=` will be used as strings, after the
#' argument names are trimmed. If no matching arguments are found, the next
#' method will be tried.
#'
#' - env: Use the value of the environmental variable "IRONSEED" as a scalar
#' character to construct an ironseed. If this variable doesn't exist or is set
#' to an empty string, the next method will be tried.
#'
#' - auto: Use multiple sources of entropy from the system to generate an
#' ironseed. This method always constructs an ironseed.
#'
#' - null: Generate a "default" ironseed using no input. This method always
#' constructs an ironseed.
#'
#' If the input sequence has one value and it is an ironseed object, it is used
#' as is. If the input sequence is a scalar character that matches an ironseed
#' string, it is parsed to an ironseed. Otherwise, the input sequence is hashed
#' to create an ironseed.
#'
#' @details
#'
#' An ironseed is a finite-entropy (or fixed-entropy) hash digest that can be
#' used to generate an unlimited sequence of seeds for initializing the state of
#' a random number generator. It is inspired by the work of M.E. O’Neill and
#' others.
#'
#' An ironseed is a 256-bit hash digest constructed from a variable-length
#' sequence of 32-bit inputs. Each ironseed consists of eight 32-bit
#' sub-digests. The sub-digests are 32-bit multilinear hashes that accumulate
#' entropy from the input sequence. Each input is included in every sub-digest.
#' The coefficients for the multilinear hashes are generated by a Weyl sequence.
#'
#' Multilinear hashes are also used to generate an output seed sequence from an
#' ironseed. Each 32-bit output value is generated by uniquely hashing the
#' sub-digests. The coefficients for the output are generated by a second
#' Weyl sequence.
#'
#' To improve the observed randomness of each hash output, bits are mixed using
#' a finalizer adapted from SplitMix64. With the additional mixing from the
#' finalizer, the output seed sequence passes PractRand tests.
#'
#' @seealso [set.seed] [.Random.seed]
#'
#' @references
#' - O’Neill (2015) Developing a seed_seq Alternative.
#'   <https://www.pcg-random.org/posts/developing-a-seed_seq-alternative.html>
#' - O’Neill (2015) Simple Portable C++ Seed Entropy.
#'   <https://www.pcg-random.org/posts/simple-portable-cpp-seed-entropy.html>
#' - O’Neill (2015) Random-Number Utilities.
#'   <https://gist.github.com/imneme/540829265469e673d045>
#' - Lemire and Kaser (2018) Strongly universal string hashing is fast.
#'   <http://arxiv.org/pdf/1202.4961>
#' - Steele et al. (2014) Fast splittable pseudorandom number generators.
#'   <https://doi.org/10.1145/2714064.2660195>
#' - Weyl Sequence <https://en.wikipedia.org/wiki/Weyl_sequence>
#' - PractRand <https://pracrand.sourceforge.net/>
#'
#' @export
#' @examples
#'
#' \dontshow{
#' oldseed <- ironseed::get_random_seed()
#' }
#'
#' # Generate an ironseed with user supplied data
#' ironseed::ironseed("Experiment", 20251031, 1)
#'
#' # Generate an ironseed automatically and initialize `.Random.seed` with it
#' ironseed::ironseed(set_seed = TRUE)
#'
#' \dontshow{
#' ironseed::set_random_seed(oldseed)
#' }
#'
ironseed <- function(
  ...,
  set_seed = !has_random_seed(),
  quiet = FALSE,
  methods = c("dots", "args", "env", "auto", "null")
) {
  x <- list(...)
  n <- length(x)

  if (!is.null(names(x))) {
    stop(
      "Ironseed arguments in `...` must be passed by position, not name. ",
      "Did you misspell an argument name?",
      call. = FALSE
    )
  }

  # return the previous ironseed object
  if (n == 0L && isFALSE(set_seed)) {
    return(the$ironseed)
  }
  fe <- NULL
  for (method in methods) {
    fe <- switch(
      method,
      dots = create_ironseed(x),
      args = args_ironseed(),
      env = env_ironseed(),
      auto = auto_ironseed(),
      null = create_ironseed0(NULL),
      stop("Invalid ironseed input method.", call. = FALSE)
    )
    if (!is.null(fe)) {
      break
    }
  }
  if (is.null(fe)) {
    stop("Unable to construct an ironseed.", call. = FALSE)
  }

  # do not set seed if seed is FALSE or NA
  if (!isTRUE(set_seed)) {
    return(fe)
  }

  fill_random_seed(fe, quiet = quiet)
  the$ironseed <- fe
  invisible(fe)
}

#' @export
#' @rdname ironseed
set_ironseed <- function(
  ...,
  quiet = FALSE,
  methods = c("dots", "args", "env", "auto", "null")
) {
  ironseed(..., set_seed = TRUE, quiet = quiet, methods = methods)
}

#' @export
#' @rdname ironseed
create_ironseed <- function(x) {
  n <- length(x)
  if (n == 0L || (n == 1L && is.null(x[[1]]))) {
    NULL
  } else if (n == 1L && is_ironseed2(x[[1]])) {
    as_ironseed(x[[1]])
  } else {
    create_ironseed0(x)
  }
}

# Extract ironseed inputs from command line arguments
args_ironseed <- function() {
  x <- commandArgs(trailingOnly = TRUE)
  x <- x[grepl("^--?seed=", x)]
  x <- sub("^[^=]*=", "", x)
  create_ironseed(x)
}

# Extract ironseed input from environment
env_ironseed <- function() {
  x <- Sys.getenv("IRONSEED")
  if (is.character(x) && length(x) == 1L && (is.na(x) || nchar(x) == 0L)) {
    NULL
  } else {
    create_ironseed(x)
  }
}

create_ironseed0 <- function(x) {
  x <- simplify_list(x)
  x <- lapply(x, unlist, use.names = FALSE)
  .Call(R_create_ironseed, x)
}

auto_ironseed <- function() {
  .Call(R_auto_ironseed)
}

ironseed_re <- paste0(
  "^[1-9A-HJ-NP-Za-km-z]{11}",
  "-[1-9A-HJ-NP-Za-km-z]{11}",
  "-[1-9A-HJ-NP-Za-km-z]{11}",
  "-[1-9A-HJ-NP-Za-km-z]{11}$"
)

#' @export
#' @rdname ironseed
is_ironseed <- function(x) {
  inherits(x, "ironseed_ironseed")
}

#' @export
#' @rdname ironseed
is_ironseed_str <- function(x) {
  is.character(x) && length(x) == 1L && grepl(ironseed_re, x)
}

is_ironseed2 <- function(x) {
  is_ironseed(x) || is_ironseed_str(x)
}

#' @export
#' @rdname ironseed
as_ironseed <- function(x) {
  if (is_ironseed(x)) {
    x
  } else if (is_ironseed_str(x)) {
    x <- parse_ironseed_str(x)
    structure(x, class = "ironseed_ironseed")
  } else if (is.numeric(x) && length(x) == 8L) {
    x <- as.integer(x)
    structure(x, class = "ironseed_ironseed")
  } else {
    stop("unable to convert `x` to ironseed")
  }
}

str_ironseed <- function(x) {
  x <- as.integer(unclass(x))
  stopifnot(length(x) == 8L)

  # pack into 4 doubles
  x <- packBits(intToBits(x), "double")
  x <- .Call(R_base58_encode64, x)

  # Concatenate
  paste0(x, collapse = "-")
}

# NOTE: Ironseed is always 8 elements long and that cannot be changed

#' @export
length.ironseed_ironseed <- function(x) {
  1L
}

#' @export
`[.ironseed_ironseed` <- function(x, i, j) {
  x
}

#' @export
`[<-.ironseed_ironseed` <- function(x, i, j, value) {
  stop("Not supported")
}

#' @export
`[[.ironseed_ironseed` <- function(x, i, j) {
  x
}

#' @export
`[[<-.ironseed_ironseed` <- function(x, i, j, value) {
  stop("Not supported")
}

#' @export
as.character.ironseed_ironseed <- function(x, ...) {
  str_ironseed(x)
}

#' @export
format.ironseed_ironseed <- function(x, ...) {
  str_ironseed(x)
}

#' @export
str.ironseed_ironseed <- function(object, ...) {
  cat(" ironseed ")
  utils::str(format(object), give.head = FALSE)
}

#' @export
print.ironseed_ironseed <- function(x, ...) {
  s <- format(x, ...)
  cat("Ironseed: ")
  cat(s, sep = "\n")
  invisible(x)
}

#' @export
#' @rdname ironseed
parse_ironseed_str <- function(x) {
  stopifnot(is_ironseed_str(x))
  x <- strsplit(x, "-")[[1]]
  x <- .Call(R_base58_decode64, x)
  x <- numToInts(x)
  x
}
