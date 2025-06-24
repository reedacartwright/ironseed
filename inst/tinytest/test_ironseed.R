# Initialize .Random.seed if needed
invisible(runif(1))

# A properly formatted string is passed through.
expect_equal(ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"),
  as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"))

# as.character() and format() work
expect_equal(as.character(ironseed(1L)),
  "DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf")

expect_equal(format(ironseed(1L)),
  "DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf")

#### Validation ################################################################

# If these fail, then something has gone wrong with the algorithm.

# Integer 1
expect_equal(ironseed(1L),
  as_ironseed("DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf"))

expect_equal(ironseed(TRUE),
  as_ironseed("DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf"))

expect_equal(ironseed(as.raw(1L)),
  as_ironseed("DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf"))

expect_equal(ironseed("\01"),
  as_ironseed("DRNq18FUqhE-BCecATDkKsN-9yuPKnB2p2X-8kBBU7AJJCf"))

# Double 1.0
expect_equal(ironseed(1.0),
  as_ironseed("zZsYftUSLmA-GmruyQeEw8a-Rc1YDQFq1hE-ioztXvQdc4e"))

expect_equal(ironseed(0L, 1072693248L),
  as_ironseed("zZsYftUSLmA-GmruyQeEw8a-Rc1YDQFq1hE-ioztXvQdc4e"))

# Character "1"
expect_equal(ironseed("1"),
  as_ironseed("S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28"))

expect_equal(ironseed(49L),
  as_ironseed("S5ehwMKzbsK-YDmkGN95LCW-MD4H4Gy94Xg-migXDWE3G28"))

# Empty data
expect_equal(ironseed(list()),
  as_ironseed("A2cwaFmU65i-5PTX4ArTEh4-PEyNAiVet8A-h5VEGG9qYaF"))

expect_equal(ironseed(character(0L)),
  as_ironseed("A2cwaFmU65i-5PTX4ArTEh4-PEyNAiVet8A-h5VEGG9qYaF"))

expect_equal(ironseed(integer(0L)),
  as_ironseed("A2cwaFmU65i-5PTX4ArTEh4-PEyNAiVet8A-h5VEGG9qYaF"))

# Multiple values produce an ironseed
expect_equal(ironseed(1:10),
  as_ironseed("eTD7AJw3LwB-h9tinxhg2be-3D4YFsu7DRN-fQ4tFt7ZPF6"))

expect_equal(ironseed(1:10, 1.0),
  as_ironseed("QECWkLLKuiC-1nfMyK4N2VE-cK9DCKnQ9FG-Csc4RJWTG1J"))

expect_equal(ironseed(1:10, 1.0, LETTERS),
  as_ironseed("ZMXG9DqScdh-qowFrtSjLu2-Xk2XBEdDbz6-wYHFySohq5B"))

expect_equal(ironseed(1:10, 1.0, LETTERS, FALSE),
  as_ironseed("4iiEGnZcQh9-TWyx31k6fnD-9T4EPLvausH-qP9Vif65AyM"))

# Order matters
expect_equal(ironseed(1.0, 1:10),
  as_ironseed("ugPsRSw1MqM-WEsieRf4UbP-qdW3LJP7bMR-SBztYH7Ai7T"))

# Final zero matters
expect_equal(ironseed(1L, 0L),
  as_ironseed("q7QYDEYq9bR-ptfKNZW7ekZ-nfw6XtUP8vh-LxYc3atT6G7"))

# Two auto-ironseeds are different
expect_false(all(ironseed(NULL) == ironseed(NULL)))

#### Initializing .Random.seed #################################################

oldseed <- ironseed:::rm_random_seed()

expect_false(ironseed:::has_random_seed())
expect_message(fe <- ironseed(
  "rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"))
expect_true(ironseed:::has_random_seed())

expect_equal(fe, as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1"))
expect_equal(fe, ironseed())

# empty arguments initializes with an autoseed
ironseed:::rm_random_seed()
expect_false(ironseed:::has_random_seed())
expect_message(fe <- ironseed())
expect_true(ironseed:::has_random_seed())
expect_equal(fe, ironseed())

# Forcing setting a seed
expect_true(ironseed:::has_random_seed())
prevseed <- ironseed:::get_random_seed()
expect_message(ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1",
set_seed = TRUE))
expect_false(all(ironseed:::get_random_seed() == prevseed))

expect_silent(ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1",
  set_seed = TRUE, quiet = TRUE))

expect_message(expect_false(
  all(ironseed(NULL, set_seed = TRUE) == ironseed(NULL, set_seed = TRUE))))


#### Miscellaneous #############################################################

expect_stdout(
  print(as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")))

expect_stdout(
  str(as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")))

expect_equal(as_ironseed(1:8), structure(1:8, class="ironseed_ironseed"))
expect_equal(as_ironseed(1:8 * 1.0), structure(1:8, class="ironseed_ironseed"))

expect_error(as_ironseed("a"))
expect_error(as_ironseed(1:4))

expect_equal(ironseed:::create_ironseed(1:4),
  ironseed:::create_ironseed(list(1:4)))

expect_error(ironseed:::create_ironseed(quote(c(x))))

