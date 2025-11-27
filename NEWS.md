# ironseed (development version)

## Breaking Changes

* `ironseed(list())`, `ironseed(integer())`, etc. are now equivalent to
  `ironseed()`. `ironseed(NULL)` still creates the default/null ironseed. This change was made to support package and tools authors who can now easily
  control whether their code defaults to a random or a deterministic ironseed if
  no seeds were passed by a user.

# ironseed 0.3.0

## Breaking Changes

* The underlying hash algorithms have been updated to only use odd coefficients,
  which avoids hashing values using a coefficient of zero. This does not affect
  the strongly universal property of the multilinear hash, but it does mean
  that the coefficient sequence will loop after 2^63 inputs instead of 2^64
  inputs.
* `ironseed()` now defaults to initializing `.Random.seed`. Making the default
  depend on whether the seed has been initialized ended up being
  counter-intuitive and easy to forget.
* Retrieving the last-used ironseed is no longer done via `ironseed()`. A
  dedicated `get_ironseed()` function is now used for that purpose.
* `ironseed()` without any arguments now generates an automatic ironseed and
  `ironseed(NULL)` generates the 'null' ironseed.
* The return value of `ironseed()` is now always invisible.
* `set_ironseed()` requires at least one data argument and only uses the `dots`
  method for creating an ironseed.

## New Features

* New `get_ironseed()` function returns the last ironseed used to initialize
  `.Random.seed`. This is a replacement for the discontinued functionality of
  using `ironseed::ironseed()` to return the seed that was last used.
* The extraction of seeds from command line parameters now detects seeds
  passed as the next value after a "--seed" argument. Seeds written directly
  after "--seed=" are still supported. Any arguments after a "--" parameter
  are now ignored. The one-dash "-seed" argument is recognized as well.

## Miscellaneous Fixes and Features

* The format of the message emitted when initializing `.Random.seed` has been
  updated to better indicate that a seed was set.

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

## Miscellaneous Fixes and Features

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
