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
  f <- tempfile(fileext = ".c")
  writeLines(tmpl, f)
  ret <- Rcmd(c("COMPILE", f), stdout = verbose, stderr = verbose)
  message(sprintf("**** %s: %s", if (ret == 0) "Found" else "Not found", name))
  ret == 0
}

if (.Platform$OS.type != "windows") {
  # Check for arc4random
  tmpl <- "
#define _POSIX_C_SOURCE 200809L
#define _GNU_SOURCE
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
#define _POSIX_C_SOURCE 200809L
#define _GNU_SOURCE
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
