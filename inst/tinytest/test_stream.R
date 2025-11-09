#### Setup #####################################################################

# save random seed
reallyoldseed <- get_random_seed()

#### Stream API ################################################################

ironseed:::rm_random_seed()
expect_false(has_random_seed())
expect_silent(f <- ironseed_stream(1L))

expect_equal(
  fe <- f(),
  as_ironseed("MaCM14iELpK-kHC2xsg6eCN-pCz7W9fiMDf-AcW65VfB6p3")
)

expect_equal(f(10L), create_seedseq(fe, 10))
expect_equal(f(10L), create_seedseq(fe, 20)[11:20])
expect_equal(f(10L), create_seedseq(fe, 30)[21:30])

expect_silent(g <- ironseed_stream())
expect_false(is.null(g()))

expect_false(has_random_seed())

#### SeedSeq Validation ########################################################

# 100th value produced by default initialized ironseed is 592413702
expect_silent(fe <- ironseed(NULL, methods = "null", set_seed = FALSE))
expect_equal(create_seedseq(fe, 100)[100], 592413702)

expect_silent(f <- ironseed_stream(fe))
invisible(f(99))
expect_equal(f(1), 592413702)

#### Cleanup ###################################################################

# restore random seed
set_random_seed(reallyoldseed)
