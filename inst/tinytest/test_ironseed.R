oldseed <- get_random_seed()

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
  "JurR2ejJKXj-qMWP3GfF5oF-spTdYPe746M-oAPF88MfzXP"
)

expect_equal(
  format(ironseed(1L)),
  "JurR2ejJKXj-qMWP3GfF5oF-spTdYPe746M-oAPF88MfzXP"
)

#### Validation ################################################################

# If these fail, then something has gone wrong with the algorithm.

# Integer 1
expect_equal(
  ironseed(1L),
  as_ironseed("JurR2ejJKXj-qMWP3GfF5oF-spTdYPe746M-oAPF88MfzXP")
)

expect_equal(
  ironseed(TRUE),
  as_ironseed("JurR2ejJKXj-qMWP3GfF5oF-spTdYPe746M-oAPF88MfzXP")
)

# Double 1.0
expect_equal(
  ironseed(1.0),
  as_ironseed("dciFX9p1yGH-LQ1UTeR5xE5-PQjdPaKSTP7-aSxh9ANXS3f")
)

expect_equal(
  ironseed(0L, 1072693248L),
  as_ironseed("dciFX9p1yGH-LQ1UTeR5xE5-PQjdPaKSTP7-aSxh9ANXS3f")
)

# Raw 1
expect_equal(
  ironseed(as.raw(1L)),
  as_ironseed("9ojoGntW9Vb-CEUHxxPQ4gh-hHBHRZM4zNg-PWjZRvWXCFP")
)

expect_equal(
  ironseed("\01"),
  as_ironseed("9ojoGntW9Vb-CEUHxxPQ4gh-hHBHRZM4zNg-PWjZRvWXCFP")
)

expect_equal(
  ironseed(1L, 1L),
  as_ironseed("9ojoGntW9Vb-CEUHxxPQ4gh-hHBHRZM4zNg-PWjZRvWXCFP")
)

# Character "1"
expect_equal(
  ironseed("1"),
  as_ironseed("5TK4Kmqd6xN-BvEQcPxNGZ2-5KYDUcyY31E-U9fhQPHQQPb")
)

expect_equal(
  ironseed(as.raw(49L)),
  as_ironseed("5TK4Kmqd6xN-BvEQcPxNGZ2-5KYDUcyY31E-U9fhQPHQQPb")
)

expect_equal(
  ironseed(1L, 49L),
  as_ironseed("5TK4Kmqd6xN-BvEQcPxNGZ2-5KYDUcyY31E-U9fhQPHQQPb")
)

# Empty data
expect_equal(
  ironseed(list()),
  as_ironseed("8f8xBQ71SNf-F4jetMedYES-Z7qzFk77AAG-3uDpd2QmRpM")
)

expect_equal(
  ironseed(character(0L)),
  as_ironseed("8f8xBQ71SNf-F4jetMedYES-Z7qzFk77AAG-3uDpd2QmRpM")
)

expect_equal(
  ironseed(integer(0L)),
  as_ironseed("8f8xBQ71SNf-F4jetMedYES-Z7qzFk77AAG-3uDpd2QmRpM")
)

expect_equal(
  ironseed(""),
  as_ironseed("Z7qzFk77AAG-3uDpd2QmRpM-RH9ixtaaEo5-vmTqmirJRed")
)

expect_equal(
  ironseed(0L),
  as_ironseed("Z7qzFk77AAG-3uDpd2QmRpM-RH9ixtaaEo5-vmTqmirJRed")
)

# Multiple values produce an ironseed
expect_equal(
  ironseed(1:10),
  as_ironseed("ZAC3ztj4P2N-kDJg8ujhua4-7opTzXYVEEJ-dmutZPE7gVA")
)

expect_equal(
  ironseed(c(1.0, 0.0)),
  as_ironseed("YPuthLk5iRZ-LKhHq8pN7f3-3H7L7i9gMGM-66NyDeTgodB")
)

expect_equal(
  ironseed(1.0, 0.0),
  as_ironseed("YPuthLk5iRZ-LKhHq8pN7f3-3H7L7i9gMGM-66NyDeTgodB")
)

expect_equal(
  ironseed(1:10, 1.0),
  as_ironseed("WoBhgLSqyS8-wnDEJpmdnY6-ViMneF1ZD85-Ucti5JTtmoX")
)

expect_equal(
  ironseed(1:10, 1.0, LETTERS),
  as_ironseed("afnXzejfDEj-dLg1ZEiVRU1-aYTVWsYmyDe-Eh8d6cgK2AY")
)

expect_equal(
  ironseed(1:10, 1.0, LETTERS, FALSE),
  as_ironseed("wEZCcyLMWsa-AYbCbYV3DKF-VcxykeMEH4i-wxqs7FCx3wB")
)

expect_equal(
  ironseed("S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28", "2"),
  as_ironseed("HHmHoeDSWyL-WaCZXn6AWz4-bhR3RAqvJXj-hTHb9Z9su7j")
)

# Order matters
expect_equal(
  ironseed(1.0, 1:10),
  as_ironseed("jQ2ktTvdeVL-ai2MVyKurF7-aA4ETdUvTtV-MkjDQLLjGdL")
)

# Final zero matters
expect_equal(
  ironseed(1L, 0L),
  as_ironseed("1RFw351545P-4hm76kQxwo4-8nTLSkg5Wrb-LozozaG935M")
)

# Complex values are the same as pairs of doubles
expect_equal(
  ironseed(1 + 0i),
  as_ironseed("YPuthLk5iRZ-LKhHq8pN7f3-3H7L7i9gMGM-66NyDeTgodB")
)

# Two auto-ironseeds are different
expect_equal(Sys.getenv("IRONSEED"), "")
expect_false(all(ironseed(NULL) == ironseed(NULL)))

#### Initializing .Random.seed #################################################

ironseed:::rm_random_seed()

expect_false(has_random_seed())
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
  as_ironseed("nxi1BcWUMMM-nYkfefqmhW3-ve54PEDHtfd-TE3bbBNkiNe")
)
Sys.unsetenv("IRONSEED")
expect_equal(
  ironseed(NULL, methods = c("env", "null")),
  as_ironseed("8f8xBQ71SNf-F4jetMedYES-Z7qzFk77AAG-3uDpd2QmRpM")
)

#### Stream API ################################################################

ironseed:::rm_random_seed()
expect_false(has_random_seed())
expect_silent(f <- ironseed_stream(1L))

expect_equal(
  fe <- f(),
  as_ironseed("JurR2ejJKXj-qMWP3GfF5oF-spTdYPe746M-oAPF88MfzXP")
)

expect_equal(f(10L), create_seedseq(fe, 10))
expect_equal(f(10L), create_seedseq(fe, 20)[11:20])
expect_equal(f(10L), create_seedseq(fe, 30)[21:30])

expect_silent(g <- ironseed_stream())
expect_false(is.null(g()))

expect_false(has_random_seed())

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
  expect_equivalent(res, "5TK4Kmqd6xN-BvEQcPxNGZ2-5KYDUcyY31E-U9fhQPHQQPb")
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
  expect_equivalent(res, "HHmHoeDSWyL-WaCZXn6AWz4-bhR3RAqvJXj-hTHb9Z9su7j")
}

if (at_home()) {
  res <- rscript(
    c("--vanilla", "-e", shQuote(cmd), "--seed=1", "--seed=2"),
    stdout = TRUE
  )
  expect_null(attr(res, "status", exact = TRUE))
  expect_equivalent(res, "C6FBPZ8sKK8-LMRnp8qqD6Q-H5aSBZgcyV1-FRBqUns3HZ7")

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
  expect_equivalent(res, "C6FBPZ8sKK8-LMRnp8qqD6Q-H5aSBZgcyV1-FRBqUns3HZ7")
}

#### Cleanup ###################################################################

# restore random seed
set_random_seed(oldseed)
