#define _POSIX_C_SOURCE 200809L
#define _GNU_SOURCE
#define _CRT_RAND_S
#define _CRT_NONSTDC_NO_DEPRECATE

#include <fcntl.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#include <pthread.h>

#include "config.h"

static uint64_t timespec_to_u64(const struct timespec *ts) {
  uint64_t u = ts->tv_sec;
  u *= 1000000000;
  u += ts->tv_nsec;
  return u;
}

uint64_t clock_entropy(void) {
  struct timespec ts;
#if defined(CLOCK_MONOTONIC_RAW)
  if(clock_gettime(CLOCK_MONOTONIC_RAW, &ts) == 0) {
    return timespec_to_u64(&ts);
  }
#endif
#if defined(CLOCK_MONOTONIC)
  if(clock_gettime(CLOCK_MONOTONIC, &ts) == 0) {
    return timespec_to_u64(&ts);
  }
#endif
#if defined(TIME_MONOTONIC)
  if(timespec_get(&ts, TIME_MONOTONIC) == TIME_MONOTONIC) {
    return timespec_to_u64(&ts);
  }
#endif
#if defined(TIME_UTC)
  if(timespec_get(&ts, TIME_UTC) == TIME_UTC) {
    return timespec_to_u64(&ts);
  }
#endif

  return (uint64_t)time(NULL);
}

uint64_t pid_entropy(void) { return (uint64_t)getpid(); }

uint64_t tid_entropy(void) {
  return (uint64_t)pthread_self();
}

uint64_t readcycle_entropy(void) {
  uint64_t u = 0;
#if defined(__has_builtin) && __has_builtin(__builtin_readcyclecounter)
  u = (uint64_t)__builtin_readcyclecounter();
#endif
  return u;
}

static uint64_t system_entropy_once() {
#ifdef _WIN32
  unsigned int u = 0;
  uint64_t ret = 0;
  rand_s(&u);
  ret = (uint64_t)u;
  rand_s(&u);
  ret = (ret << 32) | (uint64_t)u;
#elif defined(HAVE_ARC4RANDOM)
  uint64_t ret = arc4random();
  ret = (ret << 32) | (uint64_t)arc4random();
#elif defined(HAVE_GETENTROPY)
  uint64_t ret = 0;
  getentropy(&ret, sizeof(ret));
#else
  uint64_t ret = 0;
  int f = open("/dev/urandom", O_RDONLY);
  if(f >= 0) {
    read(f, &ret, sizeof(ret));
    close(f);
  }
#endif
  return ret;
}

uint64_t system_entropy(void) {
  static uint64_t random_number = 0;
  if(random_number == 0) {
    random_number = system_entropy_once();
  }
  return random_number += 0xcaced73e648668efULL;
}
