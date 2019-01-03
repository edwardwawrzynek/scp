#include "serial.h"
#include "gfx.h"
#include "disk.h"
#include "ports.h"

/* main io object, including all io subsytems */
class IO{
  /* subsystems */
  SerialIO io_serial;
  GfxIO io_gfx;
  DiskIO io_disk;

  /* if the subsystems are in use or not */
  bool do_serial;
  bool do_gfx;
  bool do_disk;

  public:
    /* init io subsystems */
    void init(bool do_serial, bool do_gfx, bool do_disk, char * serial_port, char * disk_file);

    /* update io subsytems - only needs to be called when a screen update is needed */
    void update();

    /* read from a port */
    uint16_t io_read(uint8_t port);
    /* write to to a port */
    void io_write(uint8_t port, uint16_t val);

    /* close the io systems */
    void close();

};