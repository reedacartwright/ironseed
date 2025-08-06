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
*/

#ifdef _WIN32
#define _CRT_RAND_S
#define _CRT_NONSTDC_NO_DEPRECATE
#endif

#ifndef __has_builtin
#define __has_builtin(x) 0  // Compatibility with non-clang compilers.
#endif

#define R_NO_REMAP

#include <R.h>
#include <R_ext/Visibility.h>
#include <Rinternals.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdbool.h>
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

// #nocov start
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
  // #nocov end
}

uint64_t pid_entropy(void) { return (uint64_t)getpid(); }

uint64_t tid_entropy(void) {
  // NOTE: Will fail if pthread_t is not an arithmetic type.
  pthread_t id = pthread_self();
  return (uint64_t)((uintptr_t)id);
}

static uint64_t system_entropy_once(void) {
  union {
    uint64_t u;
    uint32_t h[2];
  } ret = {0};
#if defined(_WIN32)
  rand_s((unsigned int *)&ret.h[0]);
  rand_s((unsigned int *)&ret.h[1]);
#elif defined(HAS_ARC4RANDOM)
  ret.h[0] = arc4random();
  ret.h[1] = arc4random();
#elif defined(HAS_GETENTROPY)
  int res = getentropy(&ret.u, sizeof(ret.u));
  (void)res;
#else
  int f = open("/dev/urandom", O_RDONLY);
  if(f >= 0) {
    int res = read(f, &ret.u, sizeof(ret.u));
    (void)res;
    close(f);
  }
#endif
  return ret.u;
}

uint64_t system_entropy(void) {
  static uint64_t random_number = 0;
  if(random_number == 0) {
    random_number = system_entropy_once();
  }
  return random_number += 0xcaced73e648668ef;
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

void hostname_entropy(char *name, size_t size) {
  // #nocov start
  if(name == NULL || size == 0) {
    return;
  }
  // #nocov end
#ifdef HAS_GETHOSTNAME
  int ret = gethostname(name, size);
  (void)ret;
  name[size - 1] = '\0';
#else
  name[0] = '\0';
#endif
}

// #nocov start
SEXP R_ironseed_config(void) {
  // clang-format off
  const char *names[] = {
    "HAS_ARC4RANDOM",
    "HAS_GETENTROPY",
    "HAS_RAND_S",
    "HAS_CLOCK_MONOTONIC_RAW",
    "HAS_CLOCK_MONOTONIC",
    "HAS_TIME_MONOTONIC",
    "HAS_TIME_UTC",
    "HAS_READCYCLE",
    "HAS_GETHOSTNAME",
    ""
  };
  // clang-format on

  SEXP ret = PROTECT(Rf_mkNamed(LGLSXP, names));

#ifdef HAS_ARC4RANDOM
  LOGICAL(ret)[0] = true;
#else
  LOGICAL(ret)[0] = false;
#endif

#ifdef HAS_GETENTROPY
  LOGICAL(ret)[1] = true;
#else
  LOGICAL(ret)[1] = false;
#endif

#ifdef _WIN32
  LOGICAL(ret)[2] = true;
#else
  LOGICAL(ret)[2] = false;
#endif

#ifdef CLOCK_MONOTONIC_RAW
  LOGICAL(ret)[3] = true;
#else
  LOGICAL(ret)[3] = false;
#endif

#ifdef CLOCK_MONOTONIC
  LOGICAL(ret)[4] = true;
#else
  LOGICAL(ret)[4] = false;
#endif

#ifdef TIME_MONOTONIC
  LOGICAL(ret)[5] = true;
#else
  LOGICAL(ret)[5] = false;
#endif

#ifdef TIME_UTC
  LOGICAL(ret)[6] = true;
#else
  LOGICAL(ret)[6] = false;
#endif

  LOGICAL(ret)[7] = (readcycle_entropy() != 0);

#ifdef HAS_GETHOSTNAME
  LOGICAL(ret)[8] = true;
#else
  LOGICAL(ret)[8] = false;
#endif

  UNPROTECT(1);
  return ret;
}
// #nocov end
