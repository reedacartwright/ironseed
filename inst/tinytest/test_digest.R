zero <- as.raw(c(0, 0, 0, 0))
one <- as.raw(c(1, 0, 0, 0))
hund <- as.raw(c(100, 0, 0, 0))
hundbe <- as.raw(c(0, 0, 0, 100))

msg_one01 <- -269145980
msg_zero01 <- 1317208620
msg_hund100_100 <- 2026670449
msg_hundbe100_100 <- -868636071

msg_zero10 <- c(
  2080518673L, 1833682805L, 1784498536L, -2120999793L, 953659409L,
  -610285392L, -1505134668L, 714448312L, 1282413654L, -317592544L
)

expect_equal(digest(zero, 0, serialize = FALSE), integer(0L))

expect_equal(digest(zero, 1, serialize = FALSE), msg_zero01)
expect_equal(digest(one, 1, serialize = FALSE), msg_one01)
expect_equal(digest(zero, 10, serialize = FALSE), msg_zero10)

expect_equal(digest(hund, 100, serialize = FALSE)[100], msg_hund100_100)
expect_equal(digest(hundbe, 100, serialize = FALSE)[100], msg_hundbe100_100)

expect_equal(digest("test", serialize = FALSE), 941255086L)
expect_equal(digest(charToRaw("test"), serialize = FALSE), 941255086L)

hund_obj <- serialize(
  100L,
  connection = NULL,
  version = 3L,
  ascii = FALSE,
  xdr = FALSE
)

expect_equal(digest(100L), digest(hund_obj, serialize = FALSE))
