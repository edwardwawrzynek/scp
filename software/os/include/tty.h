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
/* echo input */
#define TERMIOS_ECHO    0b00000001
/* canonical / raw mode */
#define TERMIOS_CANON   0b00000010
/* handle key codes such as ctrl+c, ctrl+d, etc - only handled in CANON mode */
#define TERMIOS_CTRL    0b00000100