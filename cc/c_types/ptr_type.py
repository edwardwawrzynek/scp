import typing
from defs import Defs
from c_types.base_type import BaseCType
from regs import Reg, RegEnum

#pointer type
class PointerCType(BaseCType):
  def __init__(self):
    #what type is pointer to
    self.ptr_type: BaseCType = None

  def new(self, ptr_type: BaseCType) -> 'BaseCType':
    #set type parameters
    self.ptr_type = ptr_type

    return self

  def get_storage_size(self) -> int:
    return Defs.POINTER_SIZE

  #get the size of the type when loaded in a register
  def get_reg_size(self) -> int:
    return Defs.POINTER_SIZE

  #get the size of the type when loaded onto the stack as an arguement or local
  def get_stack_size(self) -> int:
    return Defs.POINTER_SIZE

  def gen_load_from_addr(self, comp: 'CompilerInst', addr: 'Reg', dst: 'Reg') -> None:
    #pointers are words
    if addr.reg_id == RegEnum.A_REG:
      if dst.reg_id == RegEnum.A_REG:
        comp.asm.cmd("lwpa")
      else:
        comp.asm.cmd("lwpb")
    else:
      if dst.reg_id == RegEnum.A_REG:
        comp.asm.cmd("lwqa")
      else:
        comp.asm.cmd("lwqb")

  def gen_store_from_addr(self, comp: 'CompilerInst', addr: 'Reg', src: 'Reg') -> None:
    assert addr.reg_id != src.reg_id, "Addr and src regs have to be different"
    #pointers are words
    if addr.reg_id == RegEnum.A_REG:
      comp.asm.cmd("swpb")
    else:
      comp.asm.cmd("swqa")