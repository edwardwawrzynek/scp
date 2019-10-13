#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include "debug.h"


Symbol::Symbol(std::string name, uint16_t addr) {
  this->name = name;
  this->addr = addr;
}


/* symbol debug file info */
/* has symbol locations loaded from debug file */

std::string * DebugFileInfo::findName(uint16_t addr) {
  for(auto&& s: symbols) {
    if(s.addr == addr) {
      return &(s.name);
    }
  }
  return nullptr;
}

std::string * DebugFileInfo::findNameInBody(uint16_t addr) {
  std::string * last = nullptr;
  for(auto&& s: symbols) {
    if(s.addr > addr) {
      return last;
    }
    last = &(s.name);
  }
  return nullptr;
}

DebugFileInfo::DebugFileInfo(std::string filename) {
  std::ifstream file;
  file.open(filename);
  if(!file.is_open()) {
    std::cerr << "no such file: " << filename;
    exit(1);
  }

  for (std::string line; std::getline(file, line); ) {
    std::string str_addr = line.substr(0, line.find(": "));
    std::string name = line.substr(line.find(": ") + 2);
    uint16_t addr = std::stoul(str_addr, nullptr, 16);
    symbols.push_back(Symbol(name, addr));
  }
}
