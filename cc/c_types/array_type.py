import typing
from defs import Defs
from c_types.base_type import BaseCType
from regs import Reg, RegEnum

#array type
class ArrayCType(BaseCType):
  def __init__(self):
    #what type the elements are
    self.type: BaseCType = None

  def new(self, type: BaseCType, num_elms: int) -> 'BaseCType':
    self.type = type
    self.num_elms = num_elms

    return self

  def get_storage_size(self) -> int:
    #size of each element times number of elements
    return self.type.get_storage_size() * self.num_elms

  def get_reg_size(self) -> int:
    #load as a pointer
    return Defs.POINTER_SIZE

  def get_stack_size(self) -> int:
    #pass as pointer
    return Defs.POINTER_SIZE

  def gen_load_from_addr(self, comp: 'CompilerInst', addr: 'Reg', dst: 'Reg') -> None:
    #arrays are loaded as their addr - only do something if addr and dst are different
    if addr.reg_id == RegEnum.A_REG and dst.reg_id == RegEnum.B_REG:
      comp.asm.cmd("mvab")
    elif addr.reg_id == RegEnum.B_REG and dst.reg_id == RegEnum.A_REG:
      comp.asm.cmd("mvba")

  def gen_store_from_addr(self, comp: 'CompilerInst', addr: 'Reg', src: 'Reg') -> None:
    assert addr.reg_id != src.reg_id, "Addr and src regs have to be different"
    #arrays can't be assigned values
    raise AssertionError("arrays aren't lvalues")
    pass