/* Device table */

#include "dev.h"

#include "tty.h"
#include "serial.h"
#include "pipe.h"
#include "special.h"
#include "dev_gen.h"
#include "ps.h"

struct dev_entry devices[] = {
    {NULL, NULL, NULL, NULL, NULL},         /* Regular Files */
    {_no_open, _no_close, _special_read, _special_write, _no_ioctl}, /* Special OS device files */
    {_pipe_open, _pipe_close, _pipe_read, _pipe_write, _pipe_ioctl}, /* Pipes */
    {_tty_open, _tty_close, _tty_read, _tty_write, _tty_ioctl}, /* TTY */
    {_serial_open, _serial_close, _serial_read, _serial_write, _serial_ioctl}, /* Serial */
    {_ps_open, _no_close, _ps_read, _no_write, _no_ioctl},
};
