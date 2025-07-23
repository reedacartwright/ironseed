#ifndef IRONSEED_IRONSEED_H
#define IRONSEED_IRONSEED_H

#include <stdint.h>

typedef struct ironseed_hash {
  uint64_t coef;
  uint64_t hashes[8];
} ironseed_hash_t;

typedef struct ironseed {
  uint32_t seed[8];
} ironseed_t;

#endif
