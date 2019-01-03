#include <cstdint>
#include <iostream>
#include <fstream>

class DiskIO {
    private:

    /* file */
    std::fstream disk_file;

    /* which block being operated on */
    uint16_t blk_addr;
    /* block buffer for reads and writes */
    uint8_t blk_mem[512];
    /* address in block */
    uint16_t blk_mem_addr;

    public:
    /* reset state */
    void reset();

    /* read + write to io port */
    void io_write(uint8_t port, uint16_t val);
    uint16_t io_read(uint8_t port);

    /* open disk file */
    void open(char *path);

    /* close the io system */
    void close();
};