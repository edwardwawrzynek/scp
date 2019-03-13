/* Device table */

#include "dev.h"

#include "tty.h"
#include "serial.h"
#include "pipe.h"

struct dev_entry devices[] = {
    {NULL, NULL, NULL, NULL, NULL},         /* Regular Files */
    {_tty_open, _tty_close, _tty_read, _tty_write, _tty_ioctl},
    {_serial_open, _serial_close, _serial_read, _serial_write, _serial_ioctl},
    {_pipe_open, _pipe_close, _pipe_read, _pipe_write, _pipe_ioctl},
};
