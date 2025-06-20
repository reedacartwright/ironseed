
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Ironseed

<!-- badges: start -->

[![R-CMD-check](https://github.com/reedacartwright/ironseed/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/reedacartwright/ironseed/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/reedacartwright/ironseed/graph/badge.svg)](https://app.codecov.io/gh/reedacartwright/ironseed)
<!-- badges: end -->

## Overview

Ironseed is an R package that improves seeding for R’s built in random
number generators. An ironseed is a finite-entropy (or fixed-entropy)
hash that can be used to generate an unlimited sequence of seeds for
initializing the state of a random number generator. It is inspired by
the work of M.E. O’Neill and others
\[[1](https://www.pcg-random.org/posts/developing-a-seed_seq-alternative.html),
[2](https://www.pcg-random.org/posts/simple-portable-cpp-seed-entropy.html),
[3](https://gist.github.com/imneme/540829265469e673d045)\].

An ironseed is a 256-bit hash constructed from a variable-length
sequence of 32-bit inputs. Each ironseed consists of eight 32-bit
sub-hashes. The sub-hashes are 32-bit multilinear hashes
\[[4](https://arxiv.org/pdf/1202.4961.pdf)\] that accumulate entropy
from the input sequence. Each input is included in every sub-hash. The
coefficients for the multilinear hashes are generated by a [Weyl
sequence](https://en.wikipedia.org/wiki/Weyl_sequence).

Multilinear hashes are also used to generate a seed sequence from an
ironseed. Each 32-bit output value is generated by uniquely hashing the
sub-hashes. The coefficients for the output are also generated by a
second Weyl sequence.

## Installation

You can install the development version of ironseed from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("reedacartwright/ironseed")
```

## Examples

### User Seeding

Ironseed can be used at the top of a script to robustly initialize R’s
builtin random number generator. The resulting ironseed is returned
invisibly, and a message is generated notifying the user that
initialization has occurred. This message can be logged and later used
to reproduce the run.

``` r
#!/usr/bin/env -S Rscript --vanilla
ironseed::ironseed("Experiment", 20251031, 1)
#> ** Ironseed : Seed RW7vjwjeiHF-QG7RYPvrntR-6tGPoi65sVc-N1n5SQi5RH4
runif(10)
#>  [1] 0.03158887 0.36714050 0.23088033 0.33215967 0.69246113 0.98602135
#>  [7] 0.44661582 0.75930377 0.77047433 0.90614352
```

If your script is intended to be called multiple times as part of a
large study, you can also seed based on the command line arguments.

``` r
#!/usr/bin/env -S Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
ironseed::ironseed("A Simulation Script 1", args)
#> ** Ironseed : Seed Q9LKmfC2bf1-iCjg8C9QLaJ-k7JXxb5n5Vb-vpr9FbTxJa9
runif(10)
#>  [1] 0.16224205 0.24061448 0.04000381 0.50076538 0.95144747 0.23597125
#>  [7] 0.39933299 0.51114333 0.51120232 0.98538637
```

Specific command line arguments can also be used. For large, nested
studies, it is useful for scripts to support seeding using multiple
seeds. Ironseed makes this easy to accomplish.

``` r
#!/usr/bin/env -S Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
ironseed::ironseed("A Simulation Script 2", args[grepl("--seed=", args)])
#> ** Ironseed : Seed xLD31yrUbqH-CUCsxN8xAUd-VprMDvpDEHE-To1fdD6houZ
runif(10)
#>  [1] 0.8275151 0.5527449 0.8364873 0.4608138 0.9786886 0.9014904 0.5726790
#>  [8] 0.6980262 0.3485765 0.3413197
```

### Automatic Seeding

Ironseed can also automatically initialize the random number generator
using an ironseed constructed from multiple sources of entropy. This
occurs if no data is passed to `ironseed()`.

``` r
#!/usr/bin/env -S Rscript --vanilla
ironseed::ironseed()
#> ** Ironseed : Seed DtbrdrotuMS-Ttf4aeoXkcV-QkujxKoAbsY-ekywt7ooR8c
runif(10)
#>  [1] 0.9748343 0.2914455 0.6487710 0.5234303 0.5688722 0.8346885 0.6328274
#>  [8] 0.6888870 0.3184848 0.3099098

# Since RNG initializing has occurred, the next call will simply
# return the ironseed used in previous seeding.
fe <- ironseed::ironseed()
fe
#> Ironseed: DtbrdrotuMS-Ttf4aeoXkcV-QkujxKoAbsY-ekywt7ooR8c
```

Or achieving the same thing with one call. Note that the automatically
generated seed is different from the previous run.

``` r
#!/usr/bin/env -S Rscript --vanilla
fe <- ironseed::ironseed()
#> ** Ironseed : Seed V9VwkDFjqmj-cAzPdQsfFsG-ixoBDU4pBnY-QGyhAtgkbs5
runif(10)
#>  [1] 0.80523682 0.98858094 0.14015560 0.65239866 0.99692107 0.09247972
#>  [7] 0.73068611 0.89441681 0.87310406 0.25398704
fe
#> Ironseed: V9VwkDFjqmj-cAzPdQsfFsG-ixoBDU4pBnY-QGyhAtgkbs5
```

### Reproducible Code

An ironseed can also be used directly to reproduce a previous
initialization. This is most useful when automatic seeding has been
used, and the previously generated seed has been logged.

``` r
#!/usr/bin/env -S Rscript --vanilla
ironseed::ironseed("RW7vjwjeiHF-QG7RYPvrntR-6tGPoi65sVc-N1n5SQi5RH4")
#> ** Ironseed : Seed RW7vjwjeiHF-QG7RYPvrntR-6tGPoi65sVc-N1n5SQi5RH4
runif(10)
#>  [1] 0.03158887 0.36714050 0.23088033 0.33215967 0.69246113 0.98602135
#>  [7] 0.44661582 0.75930377 0.77047433 0.90614352
```

## Analysis

### Avalanche

A good hash function has good avalanche properties. If we change one bit
of information in the input, our goal is to change 50% of the bits in
the output. To test this we, will first build a function to construct a
random pair of ironseeds that differ by a single input bit.

``` r
rand_fe_pair <- function(w) {
  x <- sample(0:1, w, replace=TRUE)
  n <- sample(seq_along(x), 1)
  y <- x
  y[n] <- if(y[n] == 1) 0L else 1L
  x <- packBits(x, "integer")
  y <- packBits(y, "integer")
  x <- ironseed::ironseed(x, set_seed = FALSE)
  y <- ironseed::ironseed(y, set_seed = FALSE)
  list(x = x, y = y)
}
```

Next we will generate 100,000 pairs using 32-bit inputs. We will use R’s
built-in seeding algorithm so that the results are independent of
Ironseed’s seeding algorithm. We will also measure how many hash bits
were flipped by flipping one input bit.

``` r
set.seed(20251220)
z <- replicate(100000, rand_fe_pair(32), simplify = FALSE)
dat <- sapply(z, \(a) sum(intToBits(a$x) != intToBits(a$y)))
```

``` r
mean(dat) # expectation: 128
#> [1] 129.0988
sd(dat) # expectation: 8
#> [1] 6.73154
hist(dat, breaks = 86:170, main = NULL)
```

<img src="man/figures/README-analysis_32-1.png" width="100%" />

We will repeat the same analysis for 256-bit inputs.

``` r
set.seed(20251221)
z <- replicate(100000, rand_fe_pair(256), simplify = FALSE)
dat <- sapply(z, \(a) sum(intToBits(a$x) != intToBits(a$y)))
mean(dat) # expectation: 128
#> [1] 128.1829
sd(dat) # expectation: 8
#> [1] 8.308218
hist(dat, breaks = 86:170, main = NULL)
```

<img src="man/figures/README-analysis_256-1.png" width="100%" />

As one can see, the avalanche behavior of the input hash is pretty good.
