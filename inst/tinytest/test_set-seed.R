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

#### Cleanup ###################################################################

# restore random seed
set_random_seed(reallyoldseed)
