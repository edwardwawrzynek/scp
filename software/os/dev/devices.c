/* Device table */

#include "dev.h"

#include "tty.h"
#include "serial.h"
#include "pipe.h"
#include "special.h"
#include "dev_gen.h"

struct dev_entry devices[] = {
    {NULL, NULL, NULL, NULL, NULL},         /* Regular Files */
    {_tty_open, _tty_close, _tty_read, _tty_write, _tty_ioctl}, /* TTy */
    {_serial_open, _serial_close, _serial_read, _serial_write, _serial_ioctl}, /* Serial */
    {_pipe_open, _pipe_close, _pipe_read, _pipe_write, _pipe_ioctl}, /* Pipes */
    {no_open, no_close, no_read, _null_write, no_ioctl}, /* /dev/null */
    {no_open, no_close, _zero_read, _null_write, no_ioctl}, /* /dev/zero */
    {no_open, no_close, _random_read, _null_write, no_ioctl}, /* /dev/random */
};
