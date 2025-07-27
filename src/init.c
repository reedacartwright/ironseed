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

#include "init.h"

#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>

static const R_CallMethodDef callMethods[] = {
  {"R_create_ironseed", (DL_FUNC)&R_create_ironseed, 1},
  {"R_auto_ironseed", (DL_FUNC)&R_auto_ironseed, 0},
  {"R_create_seedseq", (DL_FUNC)&R_create_seedseq, 2},
  {"R_create_seedseq0", (DL_FUNC)&R_create_seedseq0, 3},
  {"R_base58_encode64", (DL_FUNC)&R_base58_encode64, 1},
  {"R_base58_decode64", (DL_FUNC)&R_base58_decode64, 1},
  {"R_ironseed_config", (DL_FUNC)&R_ironseed_config, 0},
  {NULL, NULL, 0}
};

void attribute_visible R_init_ironseed(DllInfo *info) {
  R_registerRoutines(info, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
  R_forceSymbols(info, TRUE);
}

// #nocov start
void attribute_visible R_unload_ironseed(DllInfo *info) {
  (void)info;  // do nothing
}
// #nocov end
