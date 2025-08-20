# Prepare your package for installation here.
# Use 'define()' to define configuration variables.
# Use 'configure_file()' to substitute configuration values.

# defaults
define(
  DEFINE_HAS_ARC4RANDOM = "//#define HAS_ARC4RANDOM",
  DEFINE_HAS_GETENTROPY = "//#define HAS_GETENTROPY",
  DEFINE_HAS_GETHOSTNAME = "//#define HAS_GETHOSTNAME"
)

enable <- function(n) {
  n <- paste0("DEFINE_", n)
  db <- configure_database()
  val <- db[[n]]
  stopifnot(!is.null(val))
  db[[n]] <- sub("^/*", "", val)
  invisible(val)
}

disable <- function(n) {
  n <- paste0("DEFINE_", n)
  db <- configure_database()
  val <- db[[n]]
  stopifnot(!is.null(val))
  db[[n]] <- sub("^/*", "//", val)
  invisible(val)
}

CC <- r_cmd_config("CC")
CPPFLAGS <- r_cmd_config("CPPFLAGS")
CPICFLAGS <- r_cmd_config("CPICFLAGS")
CFLAGS <- r_cmd_config("CFLAGS")
CCMD <- paste(CC, CPPFLAGS, CPICFLAGS, CFLAGS)

check_compile <- function(tmpl, name) {
  message(sprintf("*** Looking for %s...", name))
  cfile <- tempfile("conftest-", fileext = ".c")
  ofile <- sub(".c$", ".o", cfile)
  writeLines(tmpl, cfile)
  cmd <- paste(CCMD, "-c", shQuote(cfile), "-o", shQuote(ofile))
  if (configure_verbose()) {
    message(cmd)
  }
  ret <- system(cmd)
  message(sprintf("**** %s: %s", if (ret) "Not found" else "Found", name))
  remove_file(cfile, verbose = FALSE)
  remove_file(ofile, verbose = FALSE)

  !ret
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
    enable("HAS_ARC4RANDOM")
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
    enable("HAS_GETENTROPY")
  }
}

# Check for gethostname
tmpl <- "
#pragma GCC diagnostic error \"-Wimplicit-function-declaration\"
#include <unistd.h>
#ifdef _WIN32
#include <winsock2.h>
#endif
int f(void) {
  char buffer[256];
  return gethostname(buffer, sizeof(buffer));
}
"
if (check_compile(tmpl, "gethostname()")) {
  enable("HAS_GETHOSTNAME")
}
