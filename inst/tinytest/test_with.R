#### Setup #####################################################################

# save random seed
reallyoldseed <- get_random_seed()

#### Tests #####################################################################

ironseed:::rm_random_seed()

expect_false(has_random_seed())
expect_message(expect_equal(
  with_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN", {
    get_ironseed()
  }),
  as_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
))
expect_false(has_random_seed())

expect_equal(
  with_ironseed(1L, get_ironseed(), quiet = TRUE),
  create_ironseed(list(1L))
)

expect_equal(
  with_ironseed(list(1:2), get_ironseed(), quiet = TRUE),
  create_ironseed(list(1L, 2L))
)

expect_equal(
  with_ironseed(list(1L, "2"), get_ironseed(), quiet = TRUE),
  create_ironseed(list(1L, "2"))
)

expect_equal(
  with_ironseed(
    "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
    {
      sample(1000, 4L)
    },
    quiet = TRUE
  ),
  c(895, 787, 223, 492)
)

expect_equal(
  with_ironseed(
    "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
    {
      sample(1000, 4L)
    },
    quiet = TRUE,
    salt = 1L
  ),
  c(246, 138, 446, 335)
)

rng_kind <- RNGkind("Knuth-TAOCP-2002")
expect_silent(expect_equal(
  with_ironseed(
    "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
    {
      sample(1000, 4L)
    },
    quiet = TRUE
  ),
  c(435, 301, 980, 179)
))

# with_ironseed restores original seed
set.seed(1)
oldseed <- get_random_seed()
expect_equal(
  with_ironseed(
    "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
    {
      get_ironseed()
    },
    quiet = TRUE
  ),
  as_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
)
expect_equal(.Random.seed, oldseed)

RNGkind(rng_kind[1])

#### local_ironseed() ##########################################################
set_random_seed(reallyoldseed)
set.seed(1)
oldseed <- get_random_seed()

local({
  expect_message(
    local_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
  )
  expect_equal(
    get_ironseed(),
    as_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
  )
  runif(1L)
})

expect_equal(.Random.seed, oldseed)

local({
  expect_message(local_ironseed("IRONSEED"))
  expect_equal(get_ironseed(), create_ironseed(list("IRONSEED")))
  runif(1L)
})

expect_equal(.Random.seed, oldseed)

local({
  local_ironseed(list(1L, "2"), quiet = TRUE)
  expect_equal(get_ironseed(), create_ironseed(list(1L, "2")))
  runif(1L)
})

expect_equal(.Random.seed, oldseed)

local({
  local_ironseed(1L, "2", quiet = TRUE)
  expect_equal(get_ironseed(), create_ironseed(list(1L, "2")))
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

local({
  local_ironseed(
    "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
    quiet = TRUE
  )
  expect_equal(sample(1000, 4L), c(895, 787, 223, 492))
})

expect_equal(.Random.seed, oldseed)

local({
  local_ironseed(
    "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN",
    quiet = TRUE,
    salt = 1L
  )
  expect_equal(sample(1000, 4L), c(246, 138, 446, 335))
})

expect_equal(.Random.seed, oldseed)

#### with_ironseed_stream() ####################################################

one_fe <- create_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
one_fe_stream <- ironseed_stream(one_fe)

expect_equal(
  with_ironseed_stream(one_fe_stream, sample(1000L, 4L)),
  c(895, 787, 223, 492)
)

expect_equal(
  with_ironseed_stream(one_fe_stream, sample(1000L, 4L)),
  c(508, 639, 488, 775)
)

one_fe_stream <- ironseed_stream(one_fe, salt = 1L)
expect_equal(
  with_ironseed_stream(one_fe_stream, sample(1000L, 4L)),
  c(246, 138, 446, 335)
)

#### local_ironseed_stream() ###################################################

one_fe <- create_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
one_fe_stream <- ironseed_stream(one_fe)

local({
  local_ironseed_stream(one_fe_stream)
  expect_equal(sample(1000L, 4L), c(895, 787, 223, 492))
})

local({
  local_ironseed_stream(one_fe_stream)
  expect_equal(sample(1000L, 4L), c(508, 639, 488, 775))
})

one_fe_stream <- ironseed_stream(one_fe, salt = 1L)

local({
  local_ironseed_stream(one_fe_stream)
  expect_equal(sample(1000L, 4L), c(246, 138, 446, 335))
})

#### Cleanup ###################################################################

# restore random seed
set_random_seed(reallyoldseed)
