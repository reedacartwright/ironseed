## Re-submission

Since the last submission the following important changes have been made in
response to CRAN feedback.

- Tests and examples now preserve `.Random.seed`.
- `tools/config/configure.R` has been updated to delete intermediate files
  generated during configuration checks.
- `tools/config.R`, which is only used during configuration, has been updated
  to remove code that is not needed to configure the package.

### Responses to specific CRAN feedback

> If there are references describing the methods in your package, please
> add these in the description field of your DESCRIPTION file in the form
> authors (year) <doi:...>
> authors (year, ISBN:...)
> or if those are not available: <https:...>
> with no space after 'doi:', 'https:' and angle brackets for
> auto-linking. (If you want to add a title as well please put it in
> quotes: "Title")

There is no reference describing the methods currently. My plan is to begin
working on a manuscript after this package is on CRAN.

> Please ensure that your functions do not write by default or in your
> examples/vignettes/tests in the user's home filespace (including the
> package directory and getwd()). This is not allowed by CRAN policies.
> Please omit any default path in writing functions. In your
> examples/vignettes/tests you can write to tempdir().
> -> tools/config.Rtools/config/configure.R

I am not exactly sure what this feedback is referring to as
`tools/config.Rtools/config/configure.R` is not a file in my package, and I have
been unable to identify a platform configuration during testing that would
produce such a file. There is a developer-only function in `tools/config.R` that
would create the file `tools/config/configure.R`. I have assumed that is what
the feedback is referring to. I removed that function and made some other
changes to `tools/config.R` to reduce the chance of false-positive reports from
static code analysis.

I also updated `tools/config/configure.R` to delete intermediate temp files
generated during configuration checks.

The only other file created is `src/config.h` from `src/config.h.in` which is
done intentionally during configuration.

> Please do not modify the .GlobalEnv. This is not allowed by the CRAN
> policies.
> -> R/ironseed.R

I have updated my tests and examples to preserve `.Random.seed`.

The behavior of my package is to modify `.Random.seed`, as my package provides a
user-friendly method to seed R's built-in RNG with up to 256-bits of entropy.
This is well documented by the package. Additionally, by default, the package
will not modify `.Random.seed` if it already exists, and the user has to
use `set_seed = TRUE` when calling `ironseed::ironseed()` to force it to reset
an existing `.Random.seed`. Other helper functions in the package that get or
set `.Random.seed` are well documented and given clear names that reflect their
behavior. It is unlikely that an end user would use these functions and be
surprised by their effect.

I understand CRAN's policy against anti-social behavior in packages, and I have
developed Ironseed to be as transparent about its behavior as possible. I
believe that it will be a useful tool for reproducible research. If necessary,
I would like to formally request that my package be reviewed for an exception,
along the lines of other packages with manipulate `.Random.seed`, such as
`withr`.

## Test Environments

* Arch Linux - R 4.5.1 (Local Install)
* Windows-Latest - Release (GitHub Actions)
* MacOS-Latest - Release (GitHub Actions)
* Ubuntu-Latest - Release (GitHub Actions)
* Ubuntu-Latest - Devel (GitHub Actions)
* Ubuntu-Latest - Oldrel-1 (Github Actions)
* devtools::check_win_devel()
* rhub::rhub_check()

## R CMD check results

0 errors | 0 warnings | 0 notes
