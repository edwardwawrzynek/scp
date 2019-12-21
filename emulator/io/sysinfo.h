#include <cstdint>

class SysInfoIO {

  /* amount of memory installed (pages) */
  uint16_t mem_installed;

  /* processor speed (mhz) */
  uint16_t cpu_speed;

  /* if the code is running in an emulator or not */
  uint16_t is_emulated;

  public:
    /* reset state */
    void reset();

    /* update the window and other parts of the subsystem - call often */
    void update();

    /* perform an io read or write - only handles gfx ports*/
    uint16_t io_read(uint8_t port);
    void io_write(uint8_t port, uint16_t val);


    void init(uint16_t pages_mem, uint16_t cpu_speed, uint8_t emulated);

    void close();

};