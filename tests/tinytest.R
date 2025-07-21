if (requireNamespace("tinytest", quietly = TRUE)) {
  home <- length(unclass(packageVersion("ironseed"))[[1]]) == 4
  tinytest::test_package("ironseed", at_home = home)
}
