zero <- as.raw(c(0, 0, 0, 0))
one <- as.raw(c(1, 0, 0, 0))
hund <- as.raw(c(100, 0, 0, 0))
hundbe <- as.raw(c(0, 0, 0, 100))

msg_one01 <- -1238509685
msg_zero01 <- -398917142
msg_hund100_100 <- -1221982725
msg_hundbe100_100 <- -1125694476

msg_zero10 <- c(
  -2027064858L, -1489326973L, 1142046877L, -406317157L, -1521925087L,
  -213636100L, -1491661455L, 637854673L, -1153662057L, -576691921L
)

expect_equal(digest(zero, 0, serialize = FALSE), integer(0L))

expect_equal(digest(zero, 1, serialize = FALSE), msg_zero01)
expect_equal(digest(one, 1, serialize = FALSE), msg_one01)
expect_equal(digest(zero, 10, serialize = FALSE), msg_zero10)

expect_equal(digest(hund, 100, serialize = FALSE)[100], msg_hund100_100)
expect_equal(digest(hundbe, 100, serialize = FALSE)[100], msg_hundbe100_100)

hund_obj <- serialize(100L,
  connection = NULL, version = 3L, ascii = FALSE,
  xdr = FALSE
)

expect_equal(digest(100L), digest(hund_obj, serialize = FALSE))
