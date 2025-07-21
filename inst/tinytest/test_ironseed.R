# save random seed
oldseed <- get_random_seed()

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
  "DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf"
)

expect_equal(
  format(ironseed(1L)),
  "DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf"
)

#### Validation ################################################################

# If these fail, then something has gone wrong with the algorithm.

# Integer 1
expect_equal(
  ironseed(1L),
  as_ironseed("DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf")
)

expect_equal(
  ironseed(TRUE),
  as_ironseed("DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf")
)

expect_equal(
  ironseed(as.raw(1L)),
  as_ironseed("DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf")
)

expect_equal(
  ironseed("\01"),
  as_ironseed("DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf")
)

# Double 1.0
expect_equal(
  ironseed(1.0),
  as_ironseed("zZsYftUSLmA-GmruyQeEw8a-Rc1YDQFq1hE-ioztXvQdc4e")
)

expect_equal(
  ironseed(0L, 1072693248L),
  as_ironseed("zZsYftUSLmA-GmruyQeEw8a-Rc1YDQFq1hE-ioztXvQdc4e")
)

# Character "1"
expect_equal(
  ironseed("1"),
  as_ironseed("S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28")
)

expect_equal(
  ironseed(49L),
  as_ironseed("S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28")
)

# Empty data
expect_equal(
  ironseed(list()),
  as_ironseed("A2cwaFmU65i-5PTX4ArTEh4-PEyNAiVet8A-h5VEGG9qYaF")
)

expect_equal(
  ironseed(character(0L)),
  as_ironseed("A2cwaFmU65i-5PTX4ArTEh4-PEyNAiVet8A-h5VEGG9qYaF")
)

expect_equal(
  ironseed(integer(0L)),
  as_ironseed("A2cwaFmU65i-5PTX4ArTEh4-PEyNAiVet8A-h5VEGG9qYaF")
)

# Multiple values produce an ironseed
expect_equal(
  ironseed(1:10),
  as_ironseed("eTD7AJw3LwB-h9tinxhg2be-3D4YFsu7DRN-fQ4tFt7ZPF6")
)

expect_equal(
  ironseed(c(1.0, 0.0)),
  as_ironseed("W7mVcD5ByXY-Pp5bJ6gm36D-g15xccqZeTc-ZiP3KVSAj1H")
)

expect_equal(
  ironseed(1:10, 1.0),
  as_ironseed("QECWkLLKuiC-1nfMyK4N2VE-cK9DCKnQ9FG-Csc4RJWTG1J")
)

expect_equal(
  ironseed(1:10, 1.0, LETTERS),
  as_ironseed("ZMXG9DqScdh-qowFrtSjLu2-Xk2XBEdDbz6-wYHFySohq5B")
)

expect_equal(
  ironseed(1:10, 1.0, LETTERS, FALSE),
  as_ironseed("4iiEGnZcQh9-TWyx31k6fnD-9T4EPLvausH-qP9Vif65AyM")
)

# Order matters
expect_equal(
  ironseed(1.0, 1:10),
  as_ironseed("ugPsRSw1MqM-WEsieRf4UbP-qdW3LJP7bMR-SBztYH7Ai7T")
)

# Final zero matters
expect_equal(
  ironseed(1L, 0L),
  as_ironseed("q7QYDEYq9bR-ptfKNZW7ekZ-nfw6XtUP8vh-LxYc3atT6G7")
)

# Complex values are the same as pairs of doubles
expect_equal(
  ironseed(1 + 0i),
  as_ironseed("W7mVcD5ByXY-Pp5bJ6gm36D-g15xccqZeTc-ZiP3KVSAj1H")
)

# Two auto-ironseeds are different
expect_false(all(ironseed(NULL) == ironseed(NULL)))

#### Initializing .Random.seed #################################################

ironseed:::rm_random_seed()

expect_false(has_random_seed())
expect_message(
  fe <- ironseed(
    "rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"
  )
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


# restore random seed
set_random_seed(oldseed)
