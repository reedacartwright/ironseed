# ironseed (development version)

# ironseed 0.2.0

## Breaking Changes

* Avalanche behavior and observed randomness were improved by including
  additional bit mixing at the end of hashing. This changes the calculation of
  all ironseeds and seed streams, but allows the algorithms to pass PractRand
  tests.
* When hashing a string, ironseed now includes the length of the string in
  the hash. This avoids input collision for two strings that are of different
  length but correspond to the same set of 32-bit values due to padding.

## New Features

* New `with_ironseed()` and `local_ironseed()` functions to temporarily change
  the `.Random.seed` state.
* New streaming API: `ironseed_stream()` function returns a function that can be
  called multiple times to generate a stream of output seeds. There are also new
  `with_ironseed_stream()` and `local_ironseed_stream()` functions as well.
* `ironseed()` gained a new `methods` parameter to control which methods are
  used for input seeds. The following methods are supported (in order of default precedence)
  - "dots" extracts one or more seeds from arguments passed to `ironseed()`.
  - "args" extracts one or more seeds from the command line.
  - "env" extracts a seed from an environment variable named "IRONSEED".
  - "auto" extracts seeds from local sources of system entropy.
  - "null" uses a default seed.
* Automatically generated ironseeds will now use also use entropy from hostnames
  and cluster job ids (if present).

## Miscellaneous fixes and features

* New `set_ironseed(...)` function to wrap `ironseed(..., set_seed = TRUE)`
* New `create_ironseed()` function to construct an ironseed from objects. This
  function has a stricter interface than `ironseed()` and is useful for internal
  usage.
* `ironseed()` now requires `...` arguments to be unnammed.
* Better support for MacOS and PowerPC (from Sergey Fedorov @barracuda156)
* Better support for \*BSD systems
* Better support for big-endian systems

# ironseed 0.1.0

* Initial CRAN submission.
