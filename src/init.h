#ifndef IRONSEED_INIT_H
#define IRONSEED_INIT_H

#include <R.h>
#include <Rinternals.h>

SEXP R_create_ironseed(SEXP x);
SEXP R_auto_ironseed(void);
SEXP R_create_seedseq(SEXP x, SEXP n, SEXP salt, SEXP k);

SEXP R_base58_encode64(SEXP x);
SEXP R_base58_decode64(SEXP x);

SEXP R_ironseed_config(void);

#endif
