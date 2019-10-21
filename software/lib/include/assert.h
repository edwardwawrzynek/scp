#ifndef __ASSERT_INCL
#define __ASSER_INCL 1

#ifdef NDEBUG
  #define assert(cond)
#endif
#ifndef NDEBUG
  #define assert(cond) if(!(cond)){fprintf(stderr, "%s:%d: %s: Assertion failed\n", __FILE__, __LINE__, __func__); exit(255);}
#endif

#endif