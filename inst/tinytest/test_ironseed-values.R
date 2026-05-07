#### Validate Ironseed Algorithm ###############################################

# NOTE: If any of these fail, something has changed about the algorithm or API.

expect_error(create_ironseed())
expect_null(create_ironseed(NULL))
expect_null(create_ironseed(list()))
expect_null(create_ironseed(integer(0L)))

expect_error(create_ironseed(list(quote(c(x)))))

null_fe <- structure(c(
  -403410543L, -1475612951L, -528418999L, 168574931L,
  -1769759682L, -1191861008L, -17209729L, -1809830631L
), class = "ironseed_ironseed")


one_fe <- structure(c(
  1662407425L, -1085609956L, 1216467990L, -80188245L,
  -1883945801L, 1090219277L, -1244544655L, -2100254172L
), class = "ironseed_ironseed")

# An ironseed with no data has a default value.
expect_equal(create_ironseed(list(NULL)), null_fe)
expect_equal(create_ironseed(list(NULL, NULL)), null_fe)
expect_equal(create_ironseed(list(list(), NULL)), null_fe)
expect_equal(create_ironseed(list(list(), list())), null_fe)

# The default value is skipped if an empty list is passed instead of NULL
expect_null(create_ironseed(list(list())))
expect_null(create_ironseed(list(integer())))
expect_null(create_ironseed(list(character())))

# A ironseed string is parsed directly.
expect_equal(
  create_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN"),
  one_fe
)
expect_equal(
  create_ironseed(list("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN")),
  one_fe
)

# as_ironseed parses an ironseed string.
expect_equal(
  as_ironseed("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN"),
  one_fe
)

# as.character() and format() convert an ironseed to a specific format.
expect_equal(
  as.character(null_fe),
  "rmw7oZbEG7V-8UkiL1heUg2-9tda2cRgLwX-t7qDUxtG1nR"
)

expect_equal(
  format(one_fe),
  "rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN"
)

# 32-bit input
expect_equal(create_ironseed(1L), one_fe)
expect_equal(create_ironseed(TRUE), one_fe)
expect_equal(create_ironseed(list(1L)), one_fe)
expect_equal(create_ironseed(list(list(TRUE))), one_fe)
expect_equal(
  create_ironseed(0L),
  as_ironseed("9tda2cRgLwX-t7qDUxtG1nR-8Eco4Zzg78L-XxXfoZMQZf7")
)

# fe as an input
expect_equal(create_ironseed(null_fe), null_fe)
expect_equal(create_ironseed(one_fe), one_fe)

# 8-bit input
expect_equal(
  create_ironseed("\01"),
  as_ironseed("bm7d7B9N64f-4vkG8GjQ6SR-89Ltq1Tuaq6-HNytHnbJASB")
)
expect_equal(
  create_ironseed(as.raw(1L)),
  as_ironseed("bm7d7B9N64f-4vkG8GjQ6SR-89Ltq1Tuaq6-HNytHnbJASB")
)
expect_equal(
  create_ironseed(list(1L, 1L)),
  as_ironseed("bm7d7B9N64f-4vkG8GjQ6SR-89Ltq1Tuaq6-HNytHnbJASB")
)

expect_equal(
  create_ironseed("1"),
  as_ironseed("qmF85L1KZbJ-8p2Hx8VAWk1-YYiDhzw6RT3-jsA3Jh4q1aR")
)
expect_equal(
  create_ironseed(as.raw(49L)),
  as_ironseed("qmF85L1KZbJ-8p2Hx8VAWk1-YYiDhzw6RT3-jsA3Jh4q1aR")
)
expect_equal(
  create_ironseed(list(1L, 49L)),
  as_ironseed("qmF85L1KZbJ-8p2Hx8VAWk1-YYiDhzw6RT3-jsA3Jh4q1aR")
)

# 64-bit input
expect_equal(
  create_ironseed(1.0),
  as_ironseed("c3ZM2aSdpmN-AeTNiJFoUPf-UDxDSXwvSfM-v7ty7Uq2u4N")
)
expect_equal(
  create_ironseed(list(0L, 1072693248L)),
  as_ironseed("c3ZM2aSdpmN-AeTNiJFoUPf-UDxDSXwvSfM-v7ty7Uq2u4N")
)

# 128-bit input
expect_equal(
  create_ironseed(1 + 0i),
  as_ironseed("DknUU154XsX-4d7boZdZuSG-TBjgnRNQgwA-HTxj1suhV8N")
)
expect_equal(
  create_ironseed(c(1, 0)),
  as_ironseed("DknUU154XsX-4d7boZdZuSG-TBjgnRNQgwA-HTxj1suhV8N")
)
expect_equal(
  create_ironseed(list(c(1, 0))),
  as_ironseed("DknUU154XsX-4d7boZdZuSG-TBjgnRNQgwA-HTxj1suhV8N")
)
expect_equal(
  create_ironseed(list(1, 0)),
  as_ironseed("DknUU154XsX-4d7boZdZuSG-TBjgnRNQgwA-HTxj1suhV8N")
)
expect_equal(
  create_ironseed(list(0L, 1072693248L, 0)),
  as_ironseed("DknUU154XsX-4d7boZdZuSG-TBjgnRNQgwA-HTxj1suhV8N")
)
expect_equal(
  create_ironseed(list(c(0L, 1072693248L), 0)),
  as_ironseed("DknUU154XsX-4d7boZdZuSG-TBjgnRNQgwA-HTxj1suhV8N")
)
expect_equal(
  create_ironseed(list(c(0L, 1072693248L), c(0L, 0L))),
  as_ironseed("DknUU154XsX-4d7boZdZuSG-TBjgnRNQgwA-HTxj1suhV8N")
)

# Empty strings
expect_equal(
  create_ironseed(""),
  as_ironseed("9tda2cRgLwX-t7qDUxtG1nR-8Eco4Zzg78L-XxXfoZMQZf7")
)

# Multiple values produce different ironseeds
expect_equal(
  create_ironseed(1:10),
  as_ironseed("bd5rT4Fzx2c-GY5kB71kqqC-JUruz1H951Z-bFm32ttCiec")
)
expect_equal(
  create_ironseed(list(1:10, 1.0)),
  as_ironseed("G2x3wKPMtWj-ScvfkfdVzL7-Abpn7Lmy2EM-y88csw51MdM")
)
expect_equal(
  create_ironseed(list(1:10, 1.0, LETTERS)),
  as_ironseed("2tpy9QWxSY2-4SUvbWT1GiC-NzNF8BNcioC-jkg8wqPry7J")
)
expect_equal(
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE)),
  as_ironseed("sJSvGBeg5iL-dnhfcAYG4jA-ua3wcRZn2rB-XYJaS8f4A2i")
)
expect_equal(
  create_ironseed(list(list(1:5, 6:10), 1.0, LETTERS, FALSE)),
  as_ironseed("sJSvGBeg5iL-dnhfcAYG4jA-ua3wcRZn2rB-XYJaS8f4A2i")
)

# Final zero produces a different ironseed
expect_equal(
  create_ironseed(list(1:10, 1.0, LETTERS, FALSE, 0L)),
  as_ironseed("rtYqhb4nkv8-Fw98tMeUckf-vBnmEEoabRP-wu6xfCJeBH6")
)

# An ironseed string is parsed as a string if it is not alone.
expect_equal(
  create_ironseed(c("rja6yUo7nzY-HiipyxWr92j-WiTLWpofQsB-zwNpz6V55tN", "2")),
  as_ironseed("Mrk5vwmxoAW-hLDGWvmpHdT-WHTD5cWEkx3-1gLiyBRSAVV")
)

# Different orders produce different ironseeds
expect_equal(
  create_ironseed(c(FALSE, TRUE, NA)),
  as_ironseed("Bc5yda6DS35-Uf9RePBX9i9-JiDAi5BKLJc-GoPNqEsYoGg")
)
expect_equal(
  create_ironseed(c(TRUE, NA, FALSE)),
  as_ironseed("76uUegpjeeK-LvEiLhp1fn1-GxXkZBh4vSc-mkHhJh6FAYR")
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
