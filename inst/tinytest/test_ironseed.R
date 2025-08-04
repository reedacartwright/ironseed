reallyoldseed <- get_random_seed()

#### Basic Tests ###############################################################

# Initialize .Random.seed if needed
invisible(runif(1))

# this should be quiet since .Random.seed is initialized
expect_silent(ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"))

# A properly formatted string is passed through.
expect_equal(
  ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"),
  as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
)

# as.character() and format() work
expect_equal(
  as.character(ironseed(1L)),
  "aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"
)

expect_equal(
  format(ironseed(1L)),
  "aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"
)

#### Validation ################################################################

# If these fail, then something has gone wrong with the algorithm.

# Integer 1
expect_equal(
  ironseed(1L),
  as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
)

expect_equal(
  ironseed(TRUE),
  as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
)

# Double 1.0
expect_equal(
  ironseed(1.0),
  as_ironseed("5Cu3pu8ZH59-6gArqHELcdd-MD3R5ZHtMmQ-DW7Uya19PcY")
)

expect_equal(
  ironseed(0L, 1072693248L),
  as_ironseed("5Cu3pu8ZH59-6gArqHELcdd-MD3R5ZHtMmQ-DW7Uya19PcY")
)

# Raw 1
expect_equal(
  ironseed(as.raw(1L)),
  as_ironseed("un3nd4pk7FA-cgdMNEGhag4-ASeu5oiqNo2-YVtwE8fqWJd")
)

expect_equal(
  ironseed("\01"),
  as_ironseed("un3nd4pk7FA-cgdMNEGhag4-ASeu5oiqNo2-YVtwE8fqWJd")
)

expect_equal(
  ironseed(1L, 1L),
  as_ironseed("un3nd4pk7FA-cgdMNEGhag4-ASeu5oiqNo2-YVtwE8fqWJd")
)

# Character "1"
expect_equal(
  ironseed("1"),
  as_ironseed("5VRdb2Z6LwS-73RLQRR3kFM-LRLPqnkDei7-UqtqWxvhuZ4")
)

expect_equal(
  ironseed(as.raw(49L)),
  as_ironseed("5VRdb2Z6LwS-73RLQRR3kFM-LRLPqnkDei7-UqtqWxvhuZ4")
)

expect_equal(
  ironseed(1L, 49L),
  as_ironseed("5VRdb2Z6LwS-73RLQRR3kFM-LRLPqnkDei7-UqtqWxvhuZ4")
)

# Empty data
expect_equal(
  ironseed(list()),
  as_ironseed("yDFnG5U51EL-iPvgn9qtcjg-JbmoCCBJUY7-NcqXAz6AAZC")
)

expect_equal(
  ironseed(character(0L)),
  as_ironseed("yDFnG5U51EL-iPvgn9qtcjg-JbmoCCBJUY7-NcqXAz6AAZC")
)

expect_equal(
  ironseed(integer(0L)),
  as_ironseed("yDFnG5U51EL-iPvgn9qtcjg-JbmoCCBJUY7-NcqXAz6AAZC")
)

expect_equal(
  ironseed(""),
  as_ironseed("JbmoCCBJUY7-NcqXAz6AAZC-Dh8JPZuoS4H-Aej9neXnxuB")
)

expect_equal(
  ironseed(0L),
  as_ironseed("JbmoCCBJUY7-NcqXAz6AAZC-Dh8JPZuoS4H-Aej9neXnxuB")
)

# Multiple values produce different ironseeds
expect_equal(
  ironseed(1:10),
  as_ironseed("bgfYicF3xGP-ULaaHM5qVja-XacoSML5JZX-mwozZFSoHsb")
)

expect_equal(
  ironseed(c(1.0, 0.0)),
  as_ironseed("QbmwKK4RykS-Brpw7YaWLc2-xMRPy1dw9nY-NNynHN1w9DK")
)

expect_equal(
  ironseed(1.0, 0.0),
  as_ironseed("QbmwKK4RykS-Brpw7YaWLc2-xMRPy1dw9nY-NNynHN1w9DK")
)

expect_equal(
  ironseed(1:10, 1.0),
  as_ironseed("vbtJzsJjH7Q-Kn5AavJJMeb-Kc8rxz7ziPH-kC59ycJYwpW")
)

expect_equal(
  ironseed(1:10, 1.0, LETTERS),
  as_ironseed("FcnrW23c6pV-LGsyUXzoqrB-K7jPccabHHF-JqwCfsYvkJV")
)

expect_equal(
  ironseed(1:10, 1.0, LETTERS, FALSE),
  as_ironseed("NRrjNLq1Lm4-s4dRYy3DVCD-uruA5i18RJK-SFQptiW5yMV")
)

expect_equal(
  ironseed("S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28", "2"),
  as_ironseed("tfedys71rDT-NhNQbzrhWDQ-DEpsYSJ6dAN-jHnKGsv1Thh")
)

# If dots is a single list, it gets unwrapped.
expect_equal(
  ironseed(list(1:10, 1.0, LETTERS, FALSE)),
  ironseed(1:10, 1.0, LETTERS, FALSE)
)

# Otherwise, a list argument is "unlisted"
expect_equal(
  ironseed(list(1:10, 1.0, LETTERS, FALSE), 1L),
  ironseed(unlist(list(1:10, 1.0, LETTERS, FALSE)), 1L)
)

# Nested lists are unlisted as well
expect_equal(
  ironseed(list(list(1:10, 1.0, LETTERS, FALSE))),
  ironseed(unlist(list(1:10, 1.0, LETTERS, FALSE)))
)

# Order matters
expect_equal(
  ironseed(1.0, 1:10),
  as_ironseed("aeoo9a7ntRd-42tmMpWwMM7-PcVXjQhPa7i-qgjUt8R1xUJ")
)

# Final zero matters
expect_equal(
  ironseed(1L, 0L),
  as_ironseed("wczYx67JsMD-LsPMEiMmvr1-xBMm8fWGR2f-wWTxGThzFzb")
)

# Complex values are the same as pairs of doubles
expect_equal(
  ironseed(1 + 0i),
  ironseed(1, 0)
)

# Two auto-ironseeds are different
expect_false(
  all(ironseed(NULL, methods = "auto") == ironseed(NULL, methods = "auto"))
)

# Ironseed respects RNGkind
oldkind <- RNGkind()

RNGkind("Knuth-TAOCP-2002")
expect_silent(ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"))
expect_equal(RNGkind()[1], "Knuth-TAOCP-2002")

RNGkind("Mersenne-Twister")
expect_silent(ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"))
expect_equal(RNGkind()[1], "Mersenne-Twister")

RNGkind(oldkind[1], oldkind[2], oldkind[3])

#### Initializing .Random.seed #################################################

ironseed:::rm_random_seed()

expect_false(has_random_seed())
expect_null(ironseed(set_seed = FALSE))
expect_message(
  fe <- ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
)
expect_true(has_random_seed())

expect_equal(fe, as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"))
expect_equal(fe, ironseed())

# empty arguments initializes with an autoseed
ironseed:::rm_random_seed()
expect_false(has_random_seed())
expect_message(fe <- ironseed())
expect_true(has_random_seed())
expect_equal(fe, ironseed())

# Forcing setting a seed
expect_true(has_random_seed())
prevseed <- get_random_seed()
expect_message(ironseed(
  "rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1",
  set_seed = TRUE
))
expect_false(all(get_random_seed() == prevseed))

expect_silent(ironseed(
  "rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1",
  set_seed = TRUE,
  quiet = TRUE
))

expect_message(expect_false(
  all(ironseed(NULL, set_seed = TRUE) == ironseed(NULL, set_seed = TRUE))
))

## set_random_seed() et al.
o <- ironseed:::rm_random_seed()
expect_false(is.null(o))
expect_false(has_random_seed())
## set_random_seed() returns NULL if no seed is set.
expect_silent(o <- set_random_seed(o))
expect_silent(runif(1))
expect_null(o)
## set_random_seed() unsets the seed if passed NULL
expect_silent(o <- set_random_seed(o))
expect_false(has_random_seed())
expect_silent(runif(1))
## set_random_seed() does nothing if both old and new seed are "NULL"
expect_silent(set_random_seed(NULL))
expect_false(has_random_seed())
expect_silent(runif(1))

#### Environmental Variable ####################################################

Sys.setenv(IRONSEED = "rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
expect_equal(
  ironseed(NULL),
  as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
)
Sys.setenv(IRONSEED = "ironseed")
expect_equal(
  ironseed(NULL),
  as_ironseed("MHHYnNaVNyS-TTu7okcxpZ9-NjmT3Tv1JHA-buJZfX4vqWN")
)
Sys.unsetenv("IRONSEED")
expect_equal(
  ironseed(NULL, methods = c("env", "null")),
  as_ironseed("yDFnG5U51EL-iPvgn9qtcjg-JbmoCCBJUY7-NcqXAz6AAZC")
)

#### Stream API ################################################################

ironseed:::rm_random_seed()
expect_false(has_random_seed())
expect_silent(f <- ironseed_stream(1L))

expect_equal(
  fe <- f(),
  as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
)

expect_equal(f(10L), create_seedseq(fe, 10))
expect_equal(f(10L), create_seedseq(fe, 20)[11:20])
expect_equal(f(10L), create_seedseq(fe, 30)[21:30])

expect_silent(g <- ironseed_stream())
expect_false(is.null(g()))

expect_false(has_random_seed())

#### SeedSeq Validation ########################################################

# 100th value produced by default initialized ironseed is -1366525975
expect_silent(fe <- ironseed(NULL, methods = "null", set_seed = FALSE))
expect_equal(create_seedseq(fe, 100)[100], -1366525975)

expect_silent(f <- ironseed_stream(fe))
invisible(f(99))
expect_equal(f(1), -1366525975)

#### Miscellaneous #############################################################

expect_stdout(
  print(as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"))
)

expect_stdout(
  str(as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"))
)

expect_equal(as_ironseed(1:8), structure(1:8, class = "ironseed_ironseed"))
expect_equal(
  as_ironseed(1:8 * 1.0),
  structure(1:8, class = "ironseed_ironseed")
)

expect_error(as_ironseed("a"))
expect_error(as_ironseed(1:4))

expect_equal(
  ironseed:::create_ironseed(1:4),
  ironseed:::create_ironseed(list(1:4))
)

expect_error(ironseed:::create_ironseed(quote(c(x))))

expect_error(ironseed(NULL, methods = "error"))
expect_error(ironseed(NULL, methods = character(0L)))
expect_error(ironseed(a = NULL))

#### Cluster Variables #########################################################

Sys.setenv("SLURM_JOB_ID" = "1")
expect_silent(ironseed(NULL, methods = "auto", set_seed = FALSE))
Sys.unsetenv("SLURM_JOB_ID")

Sys.setenv("PBS_JOBID" = "1")
expect_silent(ironseed(NULL, methods = "auto", set_seed = FALSE))
Sys.unsetenv("PBS_JOBID")

Sys.setenv("LSB_JOBID" = "1")
expect_silent(ironseed(NULL, methods = "auto", set_seed = FALSE))
Sys.unsetenv("LSB_JOBID")

Sys.setenv("FLUX_JOB_ID" = "1")
expect_silent(ironseed(NULL, methods = "auto", set_seed = FALSE))
Sys.unsetenv("FLUX_JOB_ID")

Sys.setenv("JOB_ID" = "1")
expect_silent(ironseed(NULL, methods = "auto", set_seed = FALSE))
Sys.unsetenv("JOB_ID")

Sys.setenv("AWS_BATCH_JOB_ID" = "1")
expect_silent(ironseed(NULL, methods = "auto", set_seed = FALSE))
Sys.unsetenv("AWS_BATCH_JOB_ID")

#### CommandArgs ###############################################################

# NOTE: These tests may issue out-of-date results if the installed version
# differs from the currently loaded version.

rscript <- function(args, ...) {
  system2(file.path(R.home("bin"), "Rscript"), args, ...)
}
cmd <- "cat(as.character(ironseed::ironseed(quiet = TRUE)))"

# Exact seed
res <- rscript(
  c(
    "--vanilla",
    "-e",
    shQuote(cmd),
    "--seed=S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28"
  ),
  stdout = TRUE
)
expect_null(attr(res, "status", exact = TRUE))
expect_equivalent(res, "S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28")

# Since these tests are slow, we will run the rest of them only at home
if (at_home()) {
  # No seed
  res <- rscript(c("--vanilla", "-e", shQuote(cmd)), stdout = TRUE)
  expect_null(attr(res, "status", exact = TRUE))
}

if (at_home()) {
  # One seed
  res <- rscript(c("--vanilla", "-e", shQuote(cmd), "--seed=1"), stdout = TRUE)
  expect_null(attr(res, "status", exact = TRUE))
  expect_equivalent(res, "5VRdb2Z6LwS-73RLQRR3kFM-LRLPqnkDei7-UqtqWxvhuZ4")
}

if (at_home()) {
  # Two seeds
  res <- rscript(
    c(
      "--vanilla",
      "-e",
      shQuote(cmd),
      "--seed=S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28",
      "--seed=2"
    ),
    stdout = TRUE
  )
  expect_null(attr(res, "status", exact = TRUE))
  expect_equivalent(res, "tfedys71rDT-NhNQbzrhWDQ-DEpsYSJ6dAN-jHnKGsv1Thh")
}

if (at_home()) {
  res <- rscript(
    c("--vanilla", "-e", shQuote(cmd), "--seed=1", "--seed=2"),
    stdout = TRUE
  )
  expect_null(attr(res, "status", exact = TRUE))
  expect_equivalent(res, "yFMXneM1LRg-bJgWtncCE6Q-6uFP4DThrJ9-tL3c4VBxVqK")

  # Two seeds and other args
  res <- rscript(
    c(
      "--vanilla",
      "-e",
      shQuote(cmd),
      "--seed=1",
      "-seed=2",
      "--",
      "---seed=notused"
    ),
    stdout = TRUE
  )
  expect_null(attr(res, "status", exact = TRUE))
  expect_equivalent(res, "yFMXneM1LRg-bJgWtncCE6Q-6uFP4DThrJ9-tL3c4VBxVqK")
}

#### Cleanup ###################################################################

# restore random seed
set_random_seed(reallyoldseed)
