/*
# MIT License
#
# Copyright (c) 2025 Reed A. Cartwright <racartwright@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

Example Usage: ./ironseed-bin 1 | RNG_test stdin32
./ironseed-bin $(od -vAn -N32 -t u4 < /dev/urandom) | RNG_test stdin32
./ironseed-bin | od -vAn -N400 -t d4 -
*/

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct ironseed_hash {
  uint64_t coef;
  uint64_t hashes[8];
} ironseed_hash_t;

typedef struct ironseed {
  uint32_t seed[8];
} ironseed_t;

static const uint64_t IRONSEED_A = 0xc9f736a1a00d1f5f;
static const uint64_t IRONSEED_B = 0x1044d9bc1bd04d7e;
static const uint64_t IRONSEED_C = 0x278abb429678dd43;
static const uint64_t IRONSEED_D = 0xf55176215fdee4b6;

static inline uint64_t init_hash4i_coef(void) { return IRONSEED_A; }
static inline uint64_t init_hash4o_coef(void) { return IRONSEED_C; }
static inline uint64_t hash4i_coef(uint64_t *m) {
  uint64_t r = *m;
  *m += IRONSEED_B;
  return r;
}
static inline uint64_t hash4o_coef(uint64_t *m) {
  uint64_t r = *m;
  *m += IRONSEED_D;
  return r;
}

// Adapted from mix32 of Java's SplittableRandom algorithm
// This is variant 4 of Stafford's mixing algorithms.
// http://zimbry.blogspot.com/2011/09/better-bit-mixing-improving-on.html
static inline uint32_t finalmix(uint64_t u) {
  u = (u ^ (u >> 33)) * 0x62a9d9ed799705f5;
  u = (u ^ (u >> 28)) * 0xcb24d0a5c88c35b3;
  return u >> 32;
}

// Initialize an ironseed_hash object. Stores the intermediate values of
// 8 multilinear hashes as additional values are added to the hash.
static void init_ironseed_hash(ironseed_hash_t *p) {
  assert(p != NULL);
  p->coef = init_hash4i_coef();
  for(int i = 0; i < 8; ++i) {
    p->hashes[i] = hash4i_coef(&p->coef);
  }
}

// Update the intermediate state of each sub-hash.
static void update_ironseed_hash(ironseed_hash_t *p, uint32_t value) {
  assert(p != NULL);
  for(int i = 0; i < 8; ++i) {
    p->hashes[i] += hash4i_coef(&p->coef) * value;
  }
}

static void create_ironseed(const ironseed_hash_t *p, ironseed_t *v) {
  assert(p != NULL);
  assert(v != NULL);

  // If the last valued hashed was 0, then it did not affect the hash
  // value. It did affect the coefficients. Append one extra value to
  // the end before we generate the result of each hash.
  uint64_t k = p->coef;
  for(int i = 0; i < 8; ++i) {
    uint64_t u = p->hashes[i] + hash4i_coef(&k);
    v->seed[i] = finalmix(u);
  }
}

static uint32_t create_seedseq(const ironseed_t *p, uint64_t *pm) {
  assert(p != NULL);
  assert(pm != NULL);

  uint64_t u = hash4o_coef(pm);

  for(int j = 0; j < 8; ++j) {
    u += hash4o_coef(pm) * p->seed[j];
  }

  return finalmix(u);
}

int main(int argc, char const *argv[]) {
  ironseed_hash_t h;
  ironseed_t fe;
  init_ironseed_hash(&h);

  for(int i = 1; i < argc; ++i) {
    uint32_t v = (uint32_t)strtoul(argv[i], NULL, 0);
    update_ironseed_hash(&h, v);
  }
  create_ironseed(&h, &fe);

  uint64_t k = init_hash4o_coef();

  for(;;) {
    uint32_t v = create_seedseq(&fe, &k);
    fwrite((void *)&v, sizeof(v), 1, stdout);
  }

  return EXIT_SUCCESS;
}
