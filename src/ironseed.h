
#include <stdint.h>

typedef struct ironseed_hash_s {
  uint64_t coef;
  uint64_t hashes[8];
} ironseed_hash_t;

typedef struct ironseed_s {
  uint32_t seed[8];
} ironseed_t;
