# wrapper to allow devtools::test() to work with tinytest
if (requireNamespace("tinytest", quietly = TRUE)) {
  tinytest::test_all("../..")
}
