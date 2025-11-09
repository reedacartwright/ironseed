#### Validate Ironseed Algorithm ###############################################

# NOTE: If any of these fail, something has changed about the algorithm or API.

expect_error(create_ironseed())
expect_null(create_ironseed(NULL))
expect_null(create_ironseed(list()))
expect_null(create_ironseed(integer(0L)))

expect_error(create_ironseed(list(quote(c(x)))))

null_fe <- structure(
  c(
    -309390410L,
    656251397L,
    1158962031L,
    1610828431L,
    1094635650L,
    819367212L,
    1923963095L,
    1954053394L
  ),
  class = "ironseed_ironseed"
)

one_fe <- structure(
  c(
    -864784934L,
    1887334312L,
    -519088785L,
    2126522241L,
    1366013041L,
    -462028912L,
    617882387L,
    282044577L
  ),
  class = "ironseed_ironseed"
)

# An ironseed with no data has a default value.
expect_equal(create_ironseed(list(list())), null_fe)
expect_equal(create_ironseed(list(NULL)), null_fe)
expect_equal(create_ironseed(list(NULL, NULL)), null_fe)

# A ironseed string is parsed directly.
expect_equal(
  create_ironseed("MaCM14iELpK-kHC2xsg6eCN-pCz7W9fiMDf-AcW65VfB6p3"),
  one_fe
)
expect_equal(
  create_ironseed(list("MaCM14iELpK-kHC2xsg6eCN-pCz7W9fiMDf-AcW65VfB6p3")),
  one_fe
)

# as_ironseed parses an ironseed string.
expect_equal(
  as_ironseed("MaCM14iELpK-kHC2xsg6eCN-pCz7W9fiMDf-AcW65VfB6p3"),
  one_fe
)

# as.character() and format() convert an ironseed to a specific format.
expect_equal(
  as.character(null_fe),
  "14KyPGBJUY7-ieCzQZuoS4H-oRUW4QornA9-eCkczSZruUL"
)

expect_equal(
  format(one_fe),
  "MaCM14iELpK-kHC2xsg6eCN-pCz7W9fiMDf-AcW65VfB6p3"
)

# 32-bit input
expect_equal(create_ironseed(1L), one_fe)
expect_equal(create_ironseed(TRUE), one_fe)
expect_equal(create_ironseed(list(1L)), one_fe)
expect_equal(create_ironseed(list(list(TRUE))), one_fe)
expect_equal(
  create_ironseed(0L),
  as_ironseed("oRUW4QornA9-eCkczSZruUL-xkxzcDrgvea-ZzzjQzsq1v1")
)

# fe as an input
expect_equal(create_ironseed(null_fe), null_fe)
expect_equal(create_ironseed(one_fe), one_fe)

# 8-bit input
expect_equal(
  create_ironseed("\01"),
  as_ironseed("xzRdPe8BLVR-DSxsx1mg2q2-tbhi7KUEgGE-SKmqcW6MeQ7")
)
expect_equal(
  create_ironseed(as.raw(1L)),
  as_ironseed("xzRdPe8BLVR-DSxsx1mg2q2-tbhi7KUEgGE-SKmqcW6MeQ7")
)
expect_equal(
  create_ironseed(list(1L, 1L)),
  as_ironseed("xzRdPe8BLVR-DSxsx1mg2q2-tbhi7KUEgGE-SKmqcW6MeQ7")
)

expect_equal(
  create_ironseed("1"),
  as_ironseed("9ZnnLNUsr2K-5Z9NGurhRx4-kcHU2PVtFL5-aZfzpMvaEZQ")
)
expect_equal(
  create_ironseed(as.raw(49L)),
  as_ironseed("9ZnnLNUsr2K-5Z9NGurhRx4-kcHU2PVtFL5-aZfzpMvaEZQ")
)
expect_equal(
  create_ironseed(list(1L, 49L)),
  as_ironseed("9ZnnLNUsr2K-5Z9NGurhRx4-kcHU2PVtFL5-aZfzpMvaEZQ")
)

# 64-bit input
expect_equal(
  create_ironseed(1.0),
  as_ironseed("6g84uipcXnR-6m4HdTnPxKi-8DDSAu6jSXS-rUmREq8x6e2")
)
expect_equal(
  create_ironseed(list(0L, 1072693248L)),
  as_ironseed("6g84uipcXnR-6m4HdTnPxKi-8DDSAu6jSXS-rUmREq8x6e2")
)

# 128-bit input
expect_equal(
  create_ironseed(1 + 0i),
  as_ironseed("5kihT3aBu6h-NVHkGTcPeHg-LgMX9weGRhj-quuja3RezrB")
)
expect_equal(
  create_ironseed(c(1, 0)),
  as_ironseed("5kihT3aBu6h-NVHkGTcPeHg-LgMX9weGRhj-quuja3RezrB")
)
expect_equal(
  create_ironseed(list(c(1, 0))),
  as_ironseed("5kihT3aBu6h-NVHkGTcPeHg-LgMX9weGRhj-quuja3RezrB")
)
expect_equal(
  create_ironseed(list(1, 0)),
  as_ironseed("5kihT3aBu6h-NVHkGTcPeHg-LgMX9weGRhj-quuja3RezrB")
)
expect_equal(
  create_ironseed(list(0L, 1072693248L, 0)),
  as_ironseed("5kihT3aBu6h-NVHkGTcPeHg-LgMX9weGRhj-quuja3RezrB")
)
expect_equal(
  create_ironseed(list(c(0L, 1072693248L), 0)),
  as_ironseed("5kihT3aBu6h-NVHkGTcPeHg-LgMX9weGRhj-quuja3RezrB")
)
expect_equal(
  create_ironseed(list(c(0L, 1072693248L), c(0L, 0L))),
  as_ironseed("5kihT3aBu6h-NVHkGTcPeHg-LgMX9weGRhj-quuja3RezrB")
)

# Empty input
expect_equal(
  create_ironseed(list(list())),
  as_ironseed("14KyPGBJUY7-ieCzQZuoS4H-oRUW4QornA9-eCkczSZruUL")
)
expect_equal(
  create_ironseed(list(character(0L))),
  as_ironseed("14KyPGBJUY7-ieCzQZuoS4H-oRUW4QornA9-eCkczSZruUL")
)
expect_equal(
  create_ironseed(list(integer(0L))),
  as_ironseed("14KyPGBJUY7-ieCzQZuoS4H-oRUW4QornA9-eCkczSZruUL")
)

# Empty strings
expect_equal(
  create_ironseed(""),
  as_ironseed("oRUW4QornA9-eCkczSZruUL-xkxzcDrgvea-ZzzjQzsq1v1")
)

# Multiple values produce different ironseeds
expect_equal(
  create_ironseed(1:10),
  as_ironseed("xk4riXitj4c-HNyrsypomQ1-tPWwkXaEYG8-cWTamfeommP")
)
expect_equal(
  create_ironseed(list(1:10, 1.0)),
  as_ironseed("24KvYGURhWg-KbHYdzHJxeb-3Hc7C7RJbvb-o8R9BtSWPad")
)
expect_equal(
  create_ironseed(list(1:10, 1.0, LETTERS)),
  as_ironseed("atjceBUZ817-2ErnNFGqVSX-PmoiMYRaHEf-5rVzBrfeBGg")
)
expect_equal(
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
  as_ironseed("w6kTGJ2kPuB-rUk4JLftZAF-GeQCe8SU4c7-EkWz4neREZ3")
)
expect_equal(
  create_ironseed(list(list(1:5, 6:10), 1.0, LETTERS, FALSE)),
  as_ironseed("w6kTGJ2kPuB-rUk4JLftZAF-GeQCe8SU4c7-EkWz4neREZ3")
)

# Final zero produces a different ironseed
expect_equal(
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE, 0L)),
  as_ironseed("VwdTCbhWVhR-PfWnL4mF97H-odTq1VN8nUA-kJNu8scTHPX")
)

# An ironseed string is parsed as a string if it is not alone.
expect_equal(
  create_ironseed(c("MaCM14iELpK-kHC2xsg6eCN-pCz7W9fiMDf-AcW65VfB6p3", "2")),
  as_ironseed("zLwjiqSWGDK-NznEdu5z7qA-LFwq2mKXPWb-TF33Ti2K5J9")
)

# Different orders produce different ironseeds
expect_equal(
  create_ironseed(c(FALSE, TRUE, NA)),
  as_ironseed("K9BYAKuMxQ6-2U1E2dK46h4-zypLAysf6KX-7arhDR7KKLX")
)
expect_equal(
  create_ironseed(c(TRUE, NA, FALSE)),
  as_ironseed("vnsJbeVQSzD-tcWNeJqxwzV-trgDi5cBRzf-Xpb78bJxAB6")
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
