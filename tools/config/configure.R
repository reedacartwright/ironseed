# Prepare your package for installation here.
# Use 'define()' to define configuration variables.
# Use 'configure_file()' to substitute configuration values.

Rcmd <- function(args, ...) {
  system2(file.path(R.home("bin"), "R"), c("CMD", args), ...)
}

# defaults
define(
  DEFINE_HAVE_ARC4RANDOM = "//#define HAVE_ARC4RANDOM",
  DEFINE_HAVE_GETENTROPY = "//#define HAVE_GETENTROPY"
)

check_compile <- function(tmpl, name) {
  message(sprintf("*** Looking for %s...", name))
  verbose <- if (configure_verbose()) "" else FALSE

  f <- tempfile()
  ensure_directory(f)
  cfile <- file.path(f, "test.c")
  writeLines(tmpl, cfile)
  ret <- Rcmd(c("COMPILE", cfile), stdout = verbose, stderr = verbose)
  message(sprintf("**** %s: %s", if (ret == 0) "Found" else "Not found", name))
  remove_file(f)
  ret == 0
}

if (.Platform$OS.type != "windows") {
  # Check for arc4random
  tmpl <- "
#pragma GCC diagnostic error \"-Wimplicit-function-declaration\"
#define _POSIX_C_SOURCE 200809L
#ifdef __APPLE__
#define _DARWIN_C_SOURCE
#else
#define _GNU_SOURCE
#endif
#include <stdlib.h>
int f() {
  return arc4random();
}
"
  if (check_compile(tmpl, "arc4random()")) {
    define(DEFINE_HAVE_ARC4RANDOM = "#define HAVE_ARC4RANDOM")
  }

  # Check for getentropy
  tmpl <- "
#pragma GCC diagnostic error \"-Wimplicit-function-declaration\"
#define _POSIX_C_SOURCE 200809L
#ifdef __APPLE__
#define _DARWIN_C_SOURCE
#else
#define _GNU_SOURCE
#endif
#include <unistd.h>
int f() {
  unsigned int u;
  return getentropy(&u, sizeof(u));
}
"
  if (check_compile(tmpl, "getentropy()")) {
    define(DEFINE_HAVE_GETENTROPY = "#define HAVE_GETENTROPY")
  }
}
