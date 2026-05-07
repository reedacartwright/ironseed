reallyoldseed <- get_random_seed()

#### Basic Tests ###############################################################

# Initialize .Random.seed if needed
invisible(runif(1))

expect_message(ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN"))
expect_silent(ironseed(
  "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
  quiet = TRUE
))

# Ironseed creates ironseeds via create_ironseed(list(...))
expect_equal(
  ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN", quiet = TRUE),
  as_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
)
expect_equal(
  ironseed(1L, quiet = TRUE),
  as_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
)
expect_equal(
  ironseed(
    "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
    "2",
    quiet = TRUE
  ),
  create_ironseed(list("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN", "2"))
)
expect_equal(
  ironseed(1:10, 1.0, LETTERS, FALSE, quiet = TRUE),
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
)
expect_equal(
  ironseed(list(1:10, 1.0, LETTERS, FALSE), quiet = TRUE),
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
)
expect_equal(
  ironseed(list(1:5, 6:10), 1.0, LETTERS, FALSE, quiet = TRUE),
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
)
expect_equal(
  ironseed(list(list(1:5, 6:10), 1.0, LETTERS, FALSE), quiet = TRUE),
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
)

# Passing NULL and passing list() are different
expect_false(all(
  ironseed(list(), quiet = TRUE) == ironseed(NULL, quiet = TRUE)
))

# Two auto-ironseeds are different
expect_false(all(
  ironseed(NULL, methods = "auto", quiet = TRUE) ==
    ironseed(NULL, methods = "auto", quiet = TRUE)
))

# set_ironseed()

expect_error(set_ironseed())
expect_equal(set_ironseed(NULL, quiet = TRUE), create_ironseed(list(NULL)))
expect_equal(
  set_ironseed("A", "B", quiet = TRUE),
  create_ironseed(list(c("A", "B")))
)

#### RNGkind ###################################################################

# Ironseed respects RNGkind
oldkind <- RNGkind()

RNGkind("Knuth-TAOCP-2002")
expect_message(ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN"))
expect_equal(RNGkind()[1], "Knuth-TAOCP-2002")

RNGkind("Mersenne-Twister")
expect_message(ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN"))
expect_equal(RNGkind()[1], "Mersenne-Twister")

RNGkind(oldkind[1], oldkind[2], oldkind[3])

#### .Random.seed ##############################################################

# Ironseed initializes .Random.seed

ironseed:::rm_random_seed()

expect_false(has_random_seed())
expect_inherits(ironseed(set_seed = FALSE), "ironseed_ironseed")
expect_message(
  fe <- ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
)
expect_true(has_random_seed())

expect_equal(fe, as_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN"))
expect_equal(fe, get_ironseed())

# empty arguments initializes with an autoseed
ironseed:::rm_random_seed()
expect_false(has_random_seed())
expect_message(fe <- ironseed())
expect_true(has_random_seed())
expect_equal(fe, get_ironseed())

# Forcing setting a seed
expect_true(has_random_seed())
prevseed <- get_random_seed()
expect_message(ironseed(
  "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
  set_seed = TRUE
))
expect_false(all(get_random_seed() == prevseed))
expect_message(set_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN"))

expect_silent(ironseed(
  "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
  set_seed = TRUE,
  quiet = TRUE
))
expect_silent(set_ironseed(
  "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
  quiet = TRUE
))

# Using automatic ironseeds emits messages
expect_message(expect_false(all(ironseed() == ironseed())))

#### Environmental Variable ####################################################

Sys.setenv(IRONSEED = "rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
expect_equal(
  ironseed(quiet = TRUE),
  as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
)
expect_equal(
  ironseed(list(), quiet = TRUE),
  as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
)
expect_equal(
  ironseed(NULL, quiet = TRUE),
  as_ironseed("rmw7oZbEG7V-8UkiL1heUg2-9tda2cRgLwX-t7qDUxtG1nR")
)

Sys.setenv(IRONSEED = "IRONSEED")
expect_equal(
  ironseed(quiet = TRUE),
  create_ironseed("IRONSEED")
)
Sys.unsetenv("IRONSEED")
expect_equal(
  ironseed(methods = c("env", "null"), quiet = TRUE),
  create_ironseed(list(NULL))
)

#### Miscellaneous #############################################################

expect_stdout(
  print(as_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN"))
)

expect_stdout(
  str(as_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN"))
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

rscript <- function(args, ...) {
  system2(file.path(R.home("bin"), "Rscript"), args, ...)
}
cmd <- "cat(as.character(ironseed::ironseed(quiet = TRUE)))"

# Exact seed
expect_equal(
  ironseed:::args_ironseed(
    "--seed=S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28"
  ),
  as_ironseed("S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28")
)

# No seed
expect_null(ironseed:::args_ironseed(character(0L)))

# One seed
expect_equal(
  ironseed:::args_ironseed("--seed=1"),
  as_ironseed("qmF85L1KZbJ-8p2Hx8VAWk1-YYiDhzw6RT3-jsA3Jh4q1aR")
)

# Two seeds
expect_equal(
  ironseed:::args_ironseed(c("--seed", "1", "-seed=2")),
  as_ironseed("VkQSzpzFVXV-s996AvSrK9G-JjpJf9pSJhQ-y2xnCSfoEaF")
)

expect_equal(
  ironseed:::args_ironseed(c(
    "-seed",
    "S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28",
    "--seed=2"
  )),
  as_ironseed("hbTsfgzLjdM-qbp96Jm9h7c-jBh217AP13P-KfJ9AYoxUoD")
)

expect_equal(
  ironseed:::args_ironseed(c(
    "--seed=1",
    "-seed",
    "2",
    "---seed=notused",
    "--",
    "--seed=3"
  )),
  as_ironseed("VkQSzpzFVXV-s996AvSrK9G-JjpJf9pSJhQ-y2xnCSfoEaF")
)

if (at_home()) {
  # Two seeds and other args
  res <- rscript(
    c(
      "--vanilla",
      "-e",
      shQuote(cmd),
      "--seed=1",
      "-seed",
      "2",
      "---seed=notused",
      "--",
      "--seed=3"
    ),
    stdout = TRUE
  )
  expect_null(attr(res, "status", exact = TRUE))
  # NOTE: This may fail if locally installed version has not been updated.
  expect_equivalent(res, "VkQSzpzFVXV-s996AvSrK9G-JjpJf9pSJhQ-y2xnCSfoEaF")
}

#### Cleanup ###################################################################

# restore random seed
set_random_seed(reallyoldseed)
