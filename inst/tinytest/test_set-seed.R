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
one_fe <- create_ironseed("MaCM14iELpK-kHC2xsg6eCN-pCz7W9fiMDf-AcW65VfB6p3")
one_fe_stream <- ironseed_stream(one_fe)
expect_message(fill_random_seed(one_fe, quiet = FALSE))
expect_equal(sample(1000L, 4L), c(691, 505, 533, 950))
expect_silent(fill_random_seed(one_fe_stream, quiet = FALSE))
expect_equal(sample(1000L, 4L), c(691, 505, 533, 950))

## Reseeding with one_fe will be the same
expect_message(fill_random_seed(one_fe, quiet = FALSE))
expect_equal(sample(1000L, 4L), c(691, 505, 533, 950))

## But reseeding with one_fe_stream will differ
expect_silent(fill_random_seed(one_fe_stream, quiet = FALSE))
expect_equal(sample(1000L, 4L), c(262, 207, 935, 99))

## Using a salt changes the results
expect_message(fill_random_seed(one_fe, quiet = FALSE, salt = 1L))
expect_equal(sample(1000L, 4L), c(757, 402, 159, 733))

## Salt needs to be included in stream creation
one_fe_stream <- ironseed_stream(one_fe)
expect_silent(fill_random_seed(one_fe_stream, quiet = FALSE, salt = 1L))
expect_equal(sample(1000L, 4L), c(691, 505, 533, 950))
one_fe_stream <- ironseed_stream(one_fe, salt = 1L)
expect_silent(fill_random_seed(one_fe_stream, quiet = FALSE))
expect_equal(sample(1000L, 4L), c(757, 402, 159, 733))


#### Cleanup ###################################################################

# restore random seed
set_random_seed(reallyoldseed)
