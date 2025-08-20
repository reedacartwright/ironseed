reallyoldseed <- get_random_seed()

#### Basic Tests ###############################################################

# Initialize .Random.seed if needed
invisible(runif(1))

# this should be quiet since .Random.seed is initialized
expect_silent(ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"))

# Ironseed creates ironseeds via create_ironseed(list(...))
expect_equal(
  ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"),
  as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
)
expect_equal(
  ironseed(1L),
  as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
)
expect_equal(
  ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb", "2"),
  create_ironseed(list("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb", "2"))
)
expect_equal(
  ironseed(1:10, 1.0, LETTERS, FALSE),
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
)
expect_equal(
  ironseed(list(1:10, 1.0, LETTERS, FALSE)),
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
)
expect_equal(
  ironseed(list(1:5, 6:10), 1.0, LETTERS, FALSE),
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
)
expect_equal(
  ironseed(list(list(1:5, 6:10), 1.0, LETTERS, FALSE)),
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
)
expect_equal(
  ironseed(list()),
  create_ironseed(list(list()))
)

# Two auto-ironseeds are different
expect_false(
  all(ironseed(NULL, methods = "auto") == ironseed(NULL, methods = "auto"))
)

#### RNGkind ###################################################################

# Ironseed respects RNGkind
oldkind <- RNGkind()

RNGkind("Knuth-TAOCP-2002")
expect_silent(ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"))
expect_equal(RNGkind()[1], "Knuth-TAOCP-2002")

RNGkind("Mersenne-Twister")
expect_silent(ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"))
expect_equal(RNGkind()[1], "Mersenne-Twister")

RNGkind(oldkind[1], oldkind[2], oldkind[3])

#### .Random.seed ##############################################################

# Ironseed initializes .Random.seed

ironseed:::rm_random_seed()

expect_false(has_random_seed())
expect_null(ironseed(set_seed = FALSE))
expect_message(
  fe <- ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
)
expect_true(has_random_seed())

expect_equal(fe, as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"))
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
  "aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb",
  set_seed = TRUE
))
expect_false(all(get_random_seed() == prevseed))
expect_message(set_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"))

expect_silent(ironseed(
  "aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb",
  set_seed = TRUE,
  quiet = TRUE
))
expect_silent(set_ironseed(
  "aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb",
  quiet = TRUE
))

# Using automatic ironseeds emits messages
expect_message(expect_false(
  all(set_ironseed(NULL) == ironseed(NULL, set_seed = TRUE))
))

#### Environmental Variable ####################################################

Sys.setenv(IRONSEED = "rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
expect_equal(
  ironseed(NULL),
  as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
)
Sys.setenv(IRONSEED = "IRONSEED")
expect_equal(
  ironseed(NULL),
  create_ironseed("IRONSEED")
)
Sys.unsetenv("IRONSEED")
expect_equal(
  ironseed(NULL, methods = c("env", "null")),
  create_ironseed(list(list()))
)

#### Miscellaneous #############################################################

expect_stdout(
  print(as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"))
)

expect_stdout(
  str(as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"))
)

expect_equal(as_ironseed(1:8), structure(1:8, class = "ironseed_ironseed"))
expect_equal(
  as_ironseed(1:8 * 1.0),
  structure(1:8, class = "ironseed_ironseed")
)

expect_error(as_ironseed("a"))
expect_error(as_ironseed(1:4))

expect_error(ironseed(NULL, methods = "error"))
expect_error(ironseed(NULL, methods = character(0L)))
expect_error(ironseed(a = NULL))

fe <- create_ironseed(1L)

expect_equal(length(fe), 1L)
expect_equal(fe[1], fe)
expect_equal(fe[[1]], fe)
expect_error(fe[] <- 1L)
expect_error(fe[[]] <- 1L)
expect_error(length(fe) <- 10L)

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
