#### Setup #####################################################################

# save random seed
reallyoldseed <- get_random_seed()

#### Tests #####################################################################

ironseed:::rm_random_seed()

expect_false(has_random_seed())
expect_message(expect_equal(
  with_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb", {
    ironseed()
  }),
  as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
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

rng_kind <- RNGkind("Knuth-TAOCP-2002")
expect_silent(expect_equal(
  with_ironseed(
    "aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb",
    {
      sample(1000, 4L)
    },
    quiet = TRUE
  ),
  c(318, 739, 414, 589)
))

# with_ironseed restores original seed
set.seed(1)
oldseed <- get_random_seed()
expect_equal(
  with_ironseed(
    "aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb",
    {
      ironseed()
    },
    quiet = TRUE
  ),
  as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
)
expect_equal(.Random.seed, oldseed)

RNGkind(rng_kind[1])

#### local_ironseed() ##########################################################
set_random_seed(reallyoldseed)
set.seed(1)
oldseed <- get_random_seed()

local({
  expect_message(
    local_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
  )
  expect_equal(
    ironseed(),
    as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
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

#### with_ironseed_stream() ####################################################

one_fe <- create_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
one_fe_stream <- ironseed_stream(one_fe)

expect_equal(
  with_ironseed_stream(one_fe_stream, sample(1000L, 4L)),
  c(897, 834, 696, 863)
)

expect_equal(
  with_ironseed_stream(one_fe_stream, sample(1000L, 4L)),
  c(635, 293, 907, 708)
)

#### local_ironseed_stream() ###################################################

one_fe <- create_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")
one_fe_stream <- ironseed_stream(one_fe)

local({
  local_ironseed_stream(one_fe_stream)
  expect_equal(sample(1000L, 4L), c(897, 834, 696, 863))
})

local({
  local_ironseed_stream(one_fe_stream)
  expect_equal(sample(1000L, 4L), c(635, 293, 907, 708))
})

#### Cleanup ###################################################################

# restore random seed
set_random_seed(reallyoldseed)
