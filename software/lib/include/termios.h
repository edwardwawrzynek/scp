#ifndef __TERMIOS_INCL
#define __TERMIOS_INCL 1

#ifndef __TERMIOS_STRUCT
#define __TERMIOS_STRUCT 1

#include <stdint.h>
/* Termios struct */
typedef uint8_t tcflag_t;

struct termios {
    /* flags */
    tcflag_t c_iflag;      /* input modes */
    tcflag_t c_oflag;      /* output modes */
    tcflag_t c_lflag;      /* local modes */
};
#endif

/* ioctl tty requests */
#define TCGETA 0
#define TCSETA 1

/* c_iflag values */
// translate carriage return to newline on input
#define ICRNL  1 
/* c_oflag values */
// map nl to cr + nl on output
#define ONLCR  1
// enable / disable all output handling
#define OPOST 2

/* c_lflag values */
// handle signal control codes
#define ISIG   1 
// enable canonical mode
#define ICANON 2 
// echo characters typed
#define ECHO   4 

#endif