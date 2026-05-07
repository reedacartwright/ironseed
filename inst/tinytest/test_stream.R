#### Setup #####################################################################

# save random seed
reallyoldseed <- get_random_seed()

#### Stream API ################################################################

ironseed:::rm_random_seed()
expect_false(has_random_seed())
expect_silent(f <- ironseed_stream(1L))

expect_equal(
  fe <- f(),
  as_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
)

expect_equal(f(10L), create_seedseq(fe, 10))
expect_equal(f(10L), create_seedseq(fe, 20)[11:20])
expect_equal(f(10L), create_seedseq(fe, 30)[21:30])

expect_silent(g <- ironseed_stream())
expect_false(is.null(g()))

expect_false(has_random_seed())

#### SeedSeq Validation ########################################################

# 100th value produced by null ironseed is -621918424
expect_silent(fe <- ironseed(NULL, methods = "null", set_seed = FALSE))
expect_equal(create_seedseq(fe, 100)[100], -621918424)

expect_silent(f <- ironseed_stream(fe))
invisible(f(99))
expect_equal(f(1), -621918424)

# 100th value produced by null ironseed with salt 1L is -1527818547
expect_equal(create_seedseq(fe, 100, salt = 1L)[100], -1527818547)
expect_silent(f <- ironseed_stream(fe, salt = 1L))
invisible(f(99))
expect_equal(f(1), -1527818547)

#### Cleanup ###################################################################

# restore random seed
set_random_seed(reallyoldseed)
