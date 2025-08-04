#### Setup #####################################################################

# save random seed
reallyoldseed <- get_random_seed()

#### Tests #####################################################################

ironseed:::rm_random_seed()

expect_false(has_random_seed())
expect_message(expect_equal(
  with_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1", {
    ironseed()
  }),
  as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
))
expect_false(has_random_seed())

expect_equal(
  with_ironseed(1L, ironseed(), quiet = TRUE),
  create_ironseed(list(1L))
)

expect_equal(
  with_ironseed(list(1:2), ironseed(), quiet = TRUE),
  create_ironseed(list(1L, 2L))
)

expect_equal(
  with_ironseed(list(1L, "2"), ironseed(), quiet = TRUE),
  create_ironseed(list(1L, "2"))
)

RNGkind("Knuth-TAOCP-2002")
expect_silent(expect_equal(
  with_ironseed(
    "rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1",
    {
      sample(1000, 4L)
    },
    quiet = TRUE
  ),
  c(43, 466, 321, 956)
))

# with_ironseed restores original seed
set.seed(1)
oldseed <- get_random_seed()
expect_equal(
  with_ironseed(
    "rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1",
    {
      ironseed()
    },
    quiet = TRUE
  ),
  as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
)
expect_equal(.Random.seed, oldseed)

#### local_ironseed() ##########################################################
set.seed(1)
oldseed <- get_random_seed()

local({
  expect_message(
    local_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
  )
  expect_equal(
    ironseed(),
    as_ironseed("rBQSjhjYv1d-z8dfMATEicf-sw1NSWAvVDi-bQaKSKKQmz1")
  )
  runif(1L)
})

expect_equal(.Random.seed, oldseed)

local({
  expect_message(local_ironseed("IRONSEED"))
  expect_equal(ironseed(), create_ironseed(list("IRONSEED")))
  runif(1L)
})

expect_equal(.Random.seed, oldseed)

local({
  local_ironseed(list(1L, "2"), quiet = TRUE)
  expect_equal(ironseed(), create_ironseed(list(1L, "2")))
  runif(1L)
})

expect_equal(.Random.seed, oldseed)

local({
  local_ironseed(1L, "2", quiet = TRUE)
  expect_equal(ironseed(), create_ironseed(list(1L, "2")))
  runif(1L)
})

expect_equal(
  local({
    fe <- local_ironseed("IRONSEED", quiet = TRUE)
    runif(1L)
    fe
  }),
  create_ironseed(list("IRONSEED"))
)

expect_equal(.Random.seed, oldseed)

#### Cleanup ###################################################################

# restore random seed
set_random_seed(reallyoldseed)
