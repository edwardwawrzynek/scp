#include <stdint.h>
/* Termios struct */
struct termios {
    /* flags */
    uint16_t flags;
};

/* ioctl tty requests */
#define TCGETA 0
#define TCSETA 1

/* termios flags */
#define TERMIOS_ECHO    0b00000001
#define TERMIOS_CANON   0b00000010