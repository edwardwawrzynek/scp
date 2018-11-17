#include <stdint>

extern "C" {
    #include <libserialport.h>
}

class SerialIO {
    /* serial port object */
    struct sp_port * out_port;
    /* buffer and position in buffer */
    char buf[256];
    uint8_t read_pos;
    uint8_t write_pos;

    /* open the serial port with path file */
    void open(char * file);

    /* write a byte to out*/
    void write(char val);
    /* get the number of bytes waiting */
    uint16_t waiting();
    /* read a char - should check waiting first */
    uint8_t read();

    public:
        /* perform an io read or write - only handles serial ports*/
        uint16_t io_read(uint8_t port);
        void io_write(uint8_t port, uint16_t val;)

}