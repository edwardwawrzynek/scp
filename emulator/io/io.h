#include "serial.h"
#include "ports.h"

/* main io object, including all io subsytems */
class IO{
  SerialIO io_serial;

  public:
    /* init io subsystems */
    void init(char * serial_port);

    /* read from a port */
    uint16_t io_read(uint8_t port);
    /* write to to a port */
    void io_write(uint8_t port, uint16_t val);

};