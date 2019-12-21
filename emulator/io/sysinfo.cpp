#include <cstdint>
#include "sysinfo.h"
#include "ports.h"

void SysInfoIO::reset() {}

void SysInfoIO::update() {}

void SysInfoIO::close() {}

void SysInfoIO::init(uint16_t pages_mem, uint16_t cpu_speed, uint8_t emulated) {
  this->mem_installed = pages_mem;
  this->cpu_speed = cpu_speed;
  this->is_emulated = emulated;
}

uint16_t SysInfoIO::io_read(uint8_t port) {
  switch(port) {
    case _sys_info_cpu_speed:
      return cpu_speed;
    case _sys_info_emulated:
      return is_emulated;
    case _sys_info_pages_mem:
      return mem_installed;
    default:
      return 0;
  }
}

void SysInfoIO::io_write(uint8_t port, uint16_t val) {
  /* no ports can be written */
}