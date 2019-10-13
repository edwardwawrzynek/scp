#include <vector>
#include <string>

class Symbol {
  public:
  std::string name;
  uint16_t addr;

  Symbol(std::string name, uint16_t addr);
};

/* symbol debug file info */
/* has symbol locations loaded from debug file */
class DebugFileInfo {
  private:
    std::vector<Symbol> symbols;

  public:
    std::string * findName(uint16_t addr);
    std::string * findNameInBody(uint16_t addr);

    DebugFileInfo();
    DebugFileInfo(std::string);
};