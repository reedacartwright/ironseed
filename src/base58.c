/*
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
*/
#define R_NO_REMAP

#include <R.h>
#include <R_ext/Visibility.h>
#include <Rinternals.h>
#include <stdint.h>
#include <string.h>

const char *base58_alphabet =
    "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

// buffer must be at least 12 bytes long, including the null terminator
static void base58_encode64(uint64_t u, char *buffer) {
  memset(buffer, base58_alphabet[0], 11);
  buffer[11] = '\0';
  for(int i = 0; i < 11 && u != 0; ++i) {
    buffer[i] = base58_alphabet[u % 58];
    u = u / 58;
  }
}

// Map anything that is out of range to 0.
static const int base58_array[] = {
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  2,  3,  4,  5,  6,  7,
    8,  0,  0,  0,  0,  0,  0,  0,  9,  10, 11, 12, 13, 14, 15, 16, 0,  17, 18,
    19, 20, 21, 0,  22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 0,  0,  0,  0,
    0,  0,  33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 0,  44, 45, 46, 47, 48,
    49, 50, 51, 52, 53, 54, 55, 56, 57, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0};

inline static int base58_decode_char(char c) {
  return base58_array[(unsigned char)(c)];
}

static uint64_t base58_decode64(const char *buffer) {
  uint64_t u = 0;
  for(size_t n = strlen(buffer); n > 0; --n) {
    u = u * 58 + base58_decode_char(buffer[n - 1]);
  }
  return u;
}

SEXP R_base58_encode64(SEXP x) {
  SEXP ret = PROTECT(Rf_allocVector(STRSXP, XLENGTH(x)));

  char buffer[12];
  uint64_t u;
  for(R_xlen_t i = 0; i < XLENGTH(x); ++i) {
    memcpy(&u, &REAL(x)[i], sizeof(uint64_t));
    base58_encode64(u, buffer);
    SET_STRING_ELT(ret, i, Rf_mkCharCE(buffer, CE_UTF8));
  }

  UNPROTECT(1);
  return ret;
}

SEXP R_base58_decode64(SEXP x) {
  SEXP ret = PROTECT(Rf_allocVector(REALSXP, XLENGTH(x)));

  for(R_xlen_t i = 0; i < XLENGTH(x); ++i) {
    const char *s = Rf_translateCharUTF8(STRING_ELT(x, i));
    uint64_t u = base58_decode64(s);
    memcpy(&REAL(ret)[i], &u, sizeof(double));
  }

  UNPROTECT(1);
  return ret;
}
