#ifndef __STDARG_INCL
#define __STDARG_INCL 1

/* va_list's are just pointers */
typedef unsigned char * va_list;

/* (sizeof(lastarg)<sizeof(int) ? sizeof(int):sizeof(lastarg)) */
/* (sizeof(type)<sizeof(int)?sizeof(int):sizeof(type)) */
/* make sure that va_arg will properly align */
#define va_start(ap, lastarg) ( (ap) = (va_list)(&(lastarg)) + (sizeof(lastarg)<sizeof(int) ? sizeof(int):sizeof(lastarg)))

/* everything that is passed as an arg is at least aligned as an int */
#define va_arg(ap, type) ((ap += (sizeof(type)<sizeof(int)?sizeof(int):sizeof(type))), (((type *)(ap - (sizeof(type)<sizeof(int)?sizeof(int):sizeof(type))))[0]))

/* nothing needed */
#define va_end(ap)

/* simple copy */
#define va_copy(dst, src) ((dst) = (src))

#endif