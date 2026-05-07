#### Setup #####################################################################

# save random seed
reallyoldseed <- get_random_seed()

#### Tests #####################################################################
invisible(runif(1))

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

## fill_random_seed() supports ironseed or stream input
one_fe <- create_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")
one_fe_stream <- ironseed_stream(one_fe)
expect_message(fill_random_seed(one_fe, quiet = FALSE))
expect_equal(sample(1000L, 4L), c(895, 787, 223, 492))
expect_silent(fill_random_seed(one_fe_stream, quiet = FALSE))
expect_equal(sample(1000L, 4L), c(895, 787, 223, 492))

## Reseeding with one_fe will be the same
expect_message(fill_random_seed(one_fe, quiet = FALSE))
expect_equal(sample(1000L, 4L), c(895, 787, 223, 492))

## But reseeding with one_fe_stream will differ
expect_silent(fill_random_seed(one_fe_stream, quiet = FALSE))
expect_equal(sample(1000L, 4L), c(508, 639, 488, 775))

## Using a salt changes the results
expect_message(fill_random_seed(one_fe, quiet = FALSE, salt = 1L))
expect_equal(sample(1000L, 4L), c(246, 138, 446, 335))

## fill_random_seed() ignores `salt` in steam mode
one_fe_stream <- ironseed_stream(one_fe)
expect_warning(fill_random_seed(one_fe_stream, quiet = FALSE, salt = 1L))
expect_equal(sample(1000L, 4L), c(895, 787, 223, 492))

one_fe_stream <- ironseed_stream(one_fe)
expect_silent(fill_random_seed(one_fe_stream, quiet = TRUE, salt = 1L))
expect_equal(sample(1000L, 4L), c(895, 787, 223, 492))

## for streams, the salt needs to be specified on creation.
one_fe_stream <- ironseed_stream(one_fe, salt = 1L)
expect_silent(fill_random_seed(one_fe_stream, quiet = FALSE))
expect_equal(sample(1000L, 4L), c(246, 138, 446, 335))


#### Cleanup ###################################################################

# restore random seed
set_random_seed(reallyoldseed)
