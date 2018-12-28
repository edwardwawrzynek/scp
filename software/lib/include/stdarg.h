#ifndef __STDARG_INCL
#define __STDARG_INCL 1

/**
 * scp stdarg.h - may not work
 * Edward Wawrzynek */

/* va_list's are just pointers */
typedef unsigned char * va_list;

/* +1 make sure that va_arg will properly align */
#define va_start(ap, lastarg) ( (ap) = (va_list)(&(lastarg) + 1) )

/* everything that is passed as an arg is at least aligned as an int */
#define va_arg(ap, type) ((ap) += (sizeof(type)<sizeof(int)?sizeof(int):sizeof(type)), ((type *)(ap))[-1])

/* just clear */
#define va_end(ap) ((ap) = 0)

/* simple copy */
#define va_copy(dst, src) ((dst) = (src))

#endif