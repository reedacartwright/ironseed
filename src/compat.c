#define _POSIX_C_SOURCE 200809L
#define _GNU_SOURCE
#define _CRT_RAND_S
#define _CRT_NONSTDC_NO_DEPRECATE

#ifndef __has_builtin
#define __has_builtin(x) 0  // Compatibility with non-clang compilers.
#endif

#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#if __has_builtin(__builtin_readcyclecounter)
#elif defined(_WIN32)
#include <intrin.h>
#elif defined(__i386__) || defined(__x86_64__)
#include <x86intrin.h>
#elif defined(__INTEL_COMPILER) && defined(__ia64__)
#include <ia64intrin.h>
#endif

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
  // TODO: If a system defines pthread_t to not be an arithmetic type,
  // this will fail.
  pthread_t id = pthread_self();
  return (uint64_t)((uintptr_t)id);
}

static uint64_t system_entropy_once(void) {
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
  int res = getentropy(&ret, sizeof(ret));
  (void)res;
#else
  uint64_t ret = 0;
  int f = open("/dev/urandom", O_RDONLY);
  if(f >= 0) {
    int res = read(f, &ret, sizeof(ret));
    (void)res;
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

// Using ideas from MariaDB to make this portable
// https://github.com/MariaDB/server/blob/main/include/my_rdtsc.h
uint64_t readcycle_entropy(void) {
#if __has_builtin(__builtin_readcyclecounter) && !defined(__aarch64__)
  return __builtin_readcyclecounter();
#elif defined(_M_IX86) || defined(_M_X64) || defined(__i386__) || \
  defined(__x86_64__)
  return __rdtsc();
#elif defined(_M_ARM64)
  return _ReadStatusReg(ARM64_CNTVCT);
#elif defined(__GNUC__) && defined(__aarch64__)
  uint64_t u;
  __asm __volatile("mrs %0, CNTVCT_EL0" : "=&r"(u));
  return u;
#elif defined(__GNUC__) && (defined(__POWERPC__) || defined(__powerpc__))
  return __builtin_ppc_get_timebase();
#else
  return 0;
#endif
}
