## ironseed (development)

* [Breaking] When hashing a string, include the length of the string in the hash
  to avoid input collision. This will change any inputs -> ironseed that use
  strings or raws. ironseed -> outputs is unaffected.
* Add entropy from hostname and cluster job ids (if present)
* Add a streaming API: `ironseed_stream()`
* Require `...` arguments to be unnammed in `ironseed()`.
* Expand `ironseed()` to support multiple methods out of the box for collecting
  seeds.
  - "args" method extracts one or more seeds from the command line.
  - "env" method extracts a seed from an environment variable named "IRONSEED".
* Better support for MacOS and PowerPC (from Sergey Fedorov @barracuda156)
* Better support for \*BSD systems
* Better support for big-endian systems

## ironseed 0.1.0

* Initial CRAN submission.
