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

#' Create ironseed digests for arbitrary R objects
#'
#' The `digest()` function creates a variable length ironseed digest for
#' arbitrary R objects. Internally, it uses [base::serialize] to convert objects
#' to a raw vector before calculating the digest.
#'
#' @param object an arbitary R object. Will be serialized unless the
#'  `serialize` argument is `FALSE`.
#' @param n a scalar integer. Specifies the length of the returned vector.
#' @param salt a scalar integer. Used to vary the digests between applications.
#' @param serialize a logical. Indicates whether to serialize object before
#'  calculating the digest.
#' @param ascii,xdr Passed to [base::serialize]
#'
#' @returns an integer vector of length `n`
#'
#' @details
#'
#' This algorithm uses different coefficients than [create_ironseed] and
#' [create_seedseq].
#'
#' @export
digest <- function(
  object, n = 1L, salt = 1L, serialize = TRUE, ascii = FALSE,
  xdr = FALSE
) {
  if (isTRUE(serialize)) {
    object <- serialize(object,
      connection = NULL, version = 3L, ascii = ascii,
      xdr = xdr
    )
  }

  n <- as.integer(n)
  salt <- as.integer(salt)

  .Call(R_create_digests, object, n, salt)
}
