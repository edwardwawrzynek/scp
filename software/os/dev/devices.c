/* Device table */

#include "dev.h"

#include "tty.h"
#include "serial.h"

struct dev_entry devices[] = {
    {_tty_open, _tty_close, _tty_read, _tty_write, _tty_ioctl},
    {_serial_open, _serial_close, _serial_read, _serial_write},
};