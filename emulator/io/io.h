#include "serial.h"
#include "gfx.h"
#include "ports.h"

/* main io object, including all io subsytems */
class IO{
  /* subsystems */
  SerialIO io_serial;
  GfxIO io_gfx;


  public:
    /* init io subsystems */
    void init(char * serial_port);

    /* update io subsytems - only needs to be called when a screen update is needed */
    void update();

    /* read from a port */
    uint16_t io_read(uint8_t port);
    /* write to to a port */
    void io_write(uint8_t port, uint16_t val);

};