# Prepare your package for installation here.
# Use 'define()' to define configuration variables.
# Use 'configure_file()' to substitute configuration values.

# defaults
define(
  DEFINE_HAVE_ARC4RANDOM = "//#define HAVE_ARC4RANDOM",
  DEFINE_HAVE_GETENTROPY = "//#define HAVE_GETENTROPY"
)

CC <- r_cmd_config("CC")
CPPFLAGS <- r_cmd_config("CPPFLAGS")
CPICFLAGS <- r_cmd_config("CPICFLAGS")
CFLAGS <- r_cmd_config("CFLAGS")
CCMD <- paste(CC, CPPFLAGS, CPICFLAGS, CFLAGS)

check_compile <- function(tmpl, name) {
  message(sprintf("*** Looking for %s...", name))
  cfile <- tempfile("conftest-", fileext=".c")
  ofile <- sub(".c$", ".o", cfile)
  writeLines(tmpl, cfile)
  cmd <- paste(CCMD, "-c", shQuote(cfile), "-o", shQuote(ofile))
  if (configure_verbose()) {
    message(cmd)
  }
  ret <- system(cmd)
  message(sprintf("**** %s: %s", if (ret == 0) "Found" else "Not found", name))
  remove_file(cfile, verbose = FALSE)
  remove_file(ofile, verbose = FALSE)
  ret == 0
}

if (.Platform$OS.type != "windows") {
  # Check for arc4random
  tmpl <- "
#pragma GCC diagnostic error \"-Wimplicit-function-declaration\"
#include <stdlib.h>
int f(void) {
  return arc4random();
}
"
  if (check_compile(tmpl, "arc4random()")) {
    define(DEFINE_HAVE_ARC4RANDOM = "#define HAVE_ARC4RANDOM")
  }

  # Check for getentropy
  tmpl <- "
#pragma GCC diagnostic error \"-Wimplicit-function-declaration\"
#include <unistd.h>
int f(void) {
  unsigned int u;
  return getentropy(&u, sizeof(u));
}
"
  if (check_compile(tmpl, "getentropy()")) {
    define(DEFINE_HAVE_GETENTROPY = "#define HAVE_GETENTROPY")
  }
}
