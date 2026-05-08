exit_if_not(requireNamespace("Rmpfr", quietly = TRUE))

suppressPackageStartupMessages(library(gmp))
suppressPackageStartupMessages(library(Rmpfr))

magic_x <- mpfr(c(2, 3, 5), 256)
magic_x <- sqrt(magic_x)
magic_x <- magic_x - floor(magic_x)
magic_x <- magic_x * 2^64
magic_x <- floor(magic_x)
magic_x <- magic_x + (magic_x %% 2L == 0L)

magic_z <- as.bigz(formatMpfr(magic_x, digits = 0, drop0trailing = TRUE), 2^64)

MAGICA <- magic_z[1]
MAGICB <- magic_z[2]
MAGICC <- magic_z[3]

null_fe <- ironseed:::create_ironseed0(NULL)
one_fe <- ironseed:::create_ironseed0(1L)
two_fe <- ironseed:::create_ironseed0(c(1L, 2L))

# Final Bit mixing
#
# This is variant 4 of Stafford's mixing algorithms.
# http://zimbry.blogspot.com/2011/09/better-bit-mixing-improving-on.html
#

finalmix <- function(x) {
  M1 <- as.bigz("0x62a9d9ed799705f5")
  M2 <- as.bigz("0xcb24d0a5c88c35b3")

  shr <- function(x, n) {
    x %/% 2^n
  }

  xor64 <- function(a, b) {
    modulus(a) <- NULL
    modulus(b) <- NULL
    a <- strsplit(as.character(a, 2), "")[[1]]
    b <- strsplit(as.character(b, 2), "")[[1]]
    a <- c(rep("0", 64 - length(a)), a)
    b <- c(rep("0", 64 - length(b)), b)
    x <- paste0("0b", paste0((a != b) * 1L, collapse = ""))
    as.bigz(x, 2^64)
  }

  x <- as.bigz(x, 2^64)

  x <- xor64(x, shr(x, 33)) * M1
  x <- xor64(x, shr(x, 28)) * M2

  x <- as.numeric(shr(x, 32))
  if (x < 2^31) x else x - 2^32
}

# Ironseed Input Hash
#
# ## Input
#
# - u : a vector of length k containing 32-bit unsigned numbers
# - m : a weyl sequence of coefficients
# - salt: a 32-bit salt
#
# ## Output
#
# v_i = m_i0 + sum(m_ij * u_j for k in 1 to k) + salt * m_i(k+1) mod 2^64
# v_i' = mix(v_i) >> 32
#
# m_00 = MAGICA
# m_i0 = m_{(i-1),0} + MAGICA

salt <- 1L
row0 <- MAGICA * (1:8)
row1 <- MAGICA * (1:8 + 8)

v <- row0 + row1 * salt
expected_null <- sapply(v, finalmix)

expect_equal(as.numeric(null_fe), expected_null)


salt <- 1L
u <- 1L
row0 <- MAGICA * (1:8)
row1 <- MAGICA * (1:8 + 8)
row2 <- MAGICA * (1:8 + 16)

v <- row0 + row1 * u + row2 * salt
expected_one <- sapply(v, finalmix)

expect_equal(as.numeric(one_fe), expected_one)

salt <- 1L
u1 <- 1L
u2 <- 2L
row0 <- MAGICA * (1:8)
row1 <- MAGICA * (1:8 + 8)
row2 <- MAGICA * (1:8 + 16)
row3 <- MAGICA * (1:8 + 24)

v <- row0 + row1 * u1 + row2 * u2 + row3 * salt
expected_two <- sapply(v, finalmix)

expect_equal(as.numeric(two_fe), expected_two)

# Ironseed output hash
#
# This has is similar to the input hash, except that it uses the MAGICB
# constant, and doesn't store intermediate results.

null_z <- as.bigz(as.bigz(as.numeric(null_fe), 2^32), 2^64)

salt <- 0L
u <- c(as.bigz(1L), null_z, salt)
m <- MAGICB * (1:40)
r <- u * m

v1 <- finalmix(sum(r[1:10 + 0]))
v2 <- finalmix(sum(r[1:10 + 10]))
v3 <- finalmix(sum(r[1:10 + 20]))
v4 <- finalmix(sum(r[1:10 + 30]))

expect_equal(create_seedseq(null_fe, 4), c(v1, v2, v3, v4))


one_z <- as.bigz(as.bigz(as.numeric(one_fe), 2^32), 2^64)

salt <- 1L
u <- c(as.bigz(1L), one_z, salt)
m <- MAGICB * (1:40)
r <- u * m

v1 <- finalmix(sum(r[1:10 + 0]))
v2 <- finalmix(sum(r[1:10 + 10]))
v3 <- finalmix(sum(r[1:10 + 20]))
v4 <- finalmix(sum(r[1:10 + 30]))

expect_equal(create_seedseq(one_fe, 4, salt = 1L), c(v1, v2, v3, v4))

# Ironseed string digest
#
# Uses the ironseed algorithm to converts a string/raw into a variable length
# digest. Uses the MAGICC constant, and includes the length of the string into
# the hash.
#
# This digest processes input as little-endian 32-bit unsigned numbers, padding
# the end with zeros as needed.

salt <- 1L
u <- as.numeric(charToRaw("test"))
len <- length(u)
u <- sum(u * 256^(0:3))
u <- c(as.bigz(1L), len, u, salt)
m <- MAGICC * (1:40)
r <- rep(u, each = 10) * m
r <- setNames(split(r, 1:10), NULL)
expected_digest <- sapply(lapply(r, sum), finalmix)

expect_equal(digest("test", 10, serialize = FALSE, salt = 1L), expected_digest)

salt <- 2L
u <- as.numeric(charToRaw("testy"))
len <- length(u)
u <- c(u, rep(0, 3 - ((len - 1) %% 4)))
u <- u * 256^(0:3)
u <- split(u, (seq_along(u) - 1) %/% 4)
u <- sapply(u, sum)
u <- c(as.bigz(1L), len, u, salt)
m <- MAGICC * (1:(length(u) * 10))
r <- rep(u, each = 10) * m
r <- setNames(split(r, 1:10), NULL)
expected_digest <- sapply(lapply(r, sum), finalmix)

expect_equal(digest("testy", 10, serialize = FALSE, salt = 2L), expected_digest)
