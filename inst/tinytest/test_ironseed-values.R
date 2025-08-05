#### Validate Ironseed Algorithm ###############################################

# NOTE: If any of these fail, something has changed about the algorithm or API.

expect_error(create_ironseed())
expect_null(create_ironseed(NULL))
expect_null(create_ironseed(list()))
expect_null(create_ironseed(list(NULL)))
expect_null(create_ironseed(integer(0L)))

expect_error(create_ironseed(list(quote(c(x)))))

null_fe <- structure(
  c(
    -2128494816L,
    1928268316L,
    -1098770175L,
    -309390410L,
    1233806517L,
    656251397L,
    -1726969757L,
    1158962031L
  ),
  class = "ironseed_ironseed"
)

one_fe <- structure(
  c(
    1100802175L,
    -412525365L,
    1477556999L,
    1670677042L,
    281748010L,
    494767993L,
    808804019L,
    -864784934L
  ),
  class = "ironseed_ironseed"
)

# An ironseed with no data has a default value.
expect_equal(create_ironseed(list(list())), null_fe)
expect_equal(create_ironseed(list(NULL, NULL)), null_fe)

# A ironseed string is parsed directly.
expect_equal(
  create_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"),
  one_fe
)
expect_equal(
  create_ironseed(list("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb")),
  one_fe
)

# as_ironseed parses an ironseed string.
expect_equal(
  as_ironseed("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"),
  one_fe
)

# as.character() and format() convert an ironseed to a specific format.
expect_equal(
  as.character(null_fe),
  "yDFnG5U51EL-iPvgn9qtcjg-JbmoCCBJUY7-NcqXAz6AAZC"
)

expect_equal(
  format(one_fe),
  "aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb"
)

# 32-bit input
expect_equal(create_ironseed(1L), one_fe)
expect_equal(create_ironseed(TRUE), one_fe)
expect_equal(create_ironseed(list(1L)), one_fe)
expect_equal(create_ironseed(list(list(TRUE))), one_fe)
expect_equal(
  create_ironseed(0L),
  as_ironseed("JbmoCCBJUY7-NcqXAz6AAZC-Dh8JPZuoS4H-Aej9neXnxuB")
)

# fe as an input
expect_equal(create_ironseed(null_fe), null_fe)
expect_equal(create_ironseed(one_fe), one_fe)

# 8-bit input
expect_equal(
  create_ironseed("\01"),
  as_ironseed("un3nd4pk7FA-cgdMNEGhag4-ASeu5oiqNo2-YVtwE8fqWJd")
)
expect_equal(
  create_ironseed(as.raw(1L)),
  as_ironseed("un3nd4pk7FA-cgdMNEGhag4-ASeu5oiqNo2-YVtwE8fqWJd")
)
expect_equal(
  create_ironseed(list(1L, 1L)),
  as_ironseed("un3nd4pk7FA-cgdMNEGhag4-ASeu5oiqNo2-YVtwE8fqWJd")
)

expect_equal(
  create_ironseed("1"),
  as_ironseed("5VRdb2Z6LwS-73RLQRR3kFM-LRLPqnkDei7-UqtqWxvhuZ4")
)
expect_equal(
  create_ironseed(as.raw(49L)),
  as_ironseed("5VRdb2Z6LwS-73RLQRR3kFM-LRLPqnkDei7-UqtqWxvhuZ4")
)
expect_equal(
  create_ironseed(list(1L, 49L)),
  as_ironseed("5VRdb2Z6LwS-73RLQRR3kFM-LRLPqnkDei7-UqtqWxvhuZ4")
)

# 64-bit input
expect_equal(
  create_ironseed(1.0),
  as_ironseed("5Cu3pu8ZH59-6gArqHELcdd-MD3R5ZHtMmQ-DW7Uya19PcY")
)
expect_equal(
  create_ironseed(list(0L, 1072693248L)),
  as_ironseed("5Cu3pu8ZH59-6gArqHELcdd-MD3R5ZHtMmQ-DW7Uya19PcY")
)

# 128-bit input
expect_equal(
  create_ironseed(1 + 0i),
  as_ironseed("QbmwKK4RykS-Brpw7YaWLc2-xMRPy1dw9nY-NNynHN1w9DK")
)
expect_equal(
  create_ironseed(c(1, 0)),
  as_ironseed("QbmwKK4RykS-Brpw7YaWLc2-xMRPy1dw9nY-NNynHN1w9DK")
)
expect_equal(
  create_ironseed(list(c(1, 0))),
  as_ironseed("QbmwKK4RykS-Brpw7YaWLc2-xMRPy1dw9nY-NNynHN1w9DK")
)
expect_equal(
  create_ironseed(list(1, 0)),
  as_ironseed("QbmwKK4RykS-Brpw7YaWLc2-xMRPy1dw9nY-NNynHN1w9DK")
)
expect_equal(
  create_ironseed(list(0L, 1072693248L, 0)),
  as_ironseed("QbmwKK4RykS-Brpw7YaWLc2-xMRPy1dw9nY-NNynHN1w9DK")
)
expect_equal(
  create_ironseed(list(c(0L, 1072693248L), 0)),
  as_ironseed("QbmwKK4RykS-Brpw7YaWLc2-xMRPy1dw9nY-NNynHN1w9DK")
)
expect_equal(
  create_ironseed(list(c(0L, 1072693248L), c(0L, 0L))),
  as_ironseed("QbmwKK4RykS-Brpw7YaWLc2-xMRPy1dw9nY-NNynHN1w9DK")
)

# Empty input
expect_equal(
  create_ironseed(list(list())),
  as_ironseed("yDFnG5U51EL-iPvgn9qtcjg-JbmoCCBJUY7-NcqXAz6AAZC")
)
expect_equal(
  create_ironseed(list(character(0L))),
  as_ironseed("yDFnG5U51EL-iPvgn9qtcjg-JbmoCCBJUY7-NcqXAz6AAZC")
)
expect_equal(
  create_ironseed(list(integer(0L))),
  as_ironseed("yDFnG5U51EL-iPvgn9qtcjg-JbmoCCBJUY7-NcqXAz6AAZC")
)

# Empty strings
expect_equal(
  create_ironseed(""),
  as_ironseed("JbmoCCBJUY7-NcqXAz6AAZC-Dh8JPZuoS4H-Aej9neXnxuB")
)

# Multiple values produce different ironseeds
expect_equal(
  create_ironseed(1:10),
  as_ironseed("bgfYicF3xGP-ULaaHM5qVja-XacoSML5JZX-mwozZFSoHsb")
)
expect_equal(
  create_ironseed(list(1:10, 1.0)),
  as_ironseed("vbtJzsJjH7Q-Kn5AavJJMeb-Kc8rxz7ziPH-kC59ycJYwpW")
)
expect_equal(
  create_ironseed(list(1:10, 1.0, LETTERS)),
  as_ironseed("FcnrW23c6pV-LGsyUXzoqrB-K7jPccabHHF-JqwCfsYvkJV")
)
expect_equal(
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
  as_ironseed("NRrjNLq1Lm4-s4dRYy3DVCD-uruA5i18RJK-SFQptiW5yMV")
)
expect_equal(
  create_ironseed(list(list(1:5, 6:10), 1.0, LETTERS, FALSE)),
  as_ironseed("NRrjNLq1Lm4-s4dRYy3DVCD-uruA5i18RJK-SFQptiW5yMV")
)

# Final zero produces a different ironseed
expect_equal(
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE, 0L)),
  as_ironseed("C9GjYkWVD9Z-EFtFaLEFmHK-E62mD8YLM5H-m14KSsRUXGF")
)

# An ironseed string is parsed as a string if it is not alone.
expect_equal(
  create_ironseed(c("aaLzYxsxyhf-4B9K67L14fH-XZzrm2vU6w5-CHFFPRH8UCb", "2")),
  as_ironseed("re7W4P8MEoD-STSRSZtGaAe-Zvn2PQDU4U6-pbetVX2DbkN")
)

# Different orders produce different ironseeds
expect_equal(
  create_ironseed(c(FALSE, TRUE, NA)),
  as_ironseed("tKu92aDvGf3-oV88XXCfWwN-YsU3mYGUNtd-ZAbbQPdHipJ")
)
expect_equal(
  create_ironseed(c(TRUE, NA, FALSE)),
  as_ironseed("EVCHy3r5NrG-Qj4yySLqLKb-WpbfXUrK2vD-WEhUpdb3Eth")
)

# A single list argument is unwrapped
expect_equal(
  create_ironseed(list(list(1:10, 1.0, LETTERS, FALSE))),
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE))
)

# Otherwise, a list argument is "unlisted"
expect_equal(
  create_ironseed(list(list(1:10, 1.0, LETTERS, FALSE), 1L)),
  create_ironseed(list(unlist(list(1:10, 1.0, LETTERS, FALSE)), 1L))
)

# Nested lists are unlisted as well
expect_equal(
  create_ironseed(list(list(list(1:10, 1.0, LETTERS, FALSE)))),
  create_ironseed(list(unlist(list(1:10, 1.0, LETTERS, FALSE))))
)
