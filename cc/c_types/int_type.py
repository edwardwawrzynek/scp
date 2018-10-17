import typing
from defs import Defs
from c_types.base_type import BaseCType
from regs import Reg, RegEnum

#integar types
class IntCType(BaseCType):
  def __init__(self):
    #the integer's size
    self.size = 0
    #if the integar is signed
    self.signed = True

  def new(self, size: int, signed: bool) -> 'BaseCType':
    self.size = size
    assert self.size in [1,2,4], "Ints can only be 1, 2, or 4 bytes"
    self.signed = signed

    return self

  #-- sizes --
  def get_storage_size(self) -> int:
    return self.size

  def get_reg_size(self) -> int:
    return self.size

  def get_stack_size(self) -> int:
    #chars are passed as ints
    return self.size if self.size >= Defs.REG_SIZE else Defs.REG_SIZE

  def gen_load_from_addr(self, comp: 'CompilerInst', addr: 'Reg', dst: 'Reg') -> None:
    #load prefix
    res = "l"
    #size
    if self.size == 1:
      res += "b"
    elif self.size == 2:
      res += "w"
    elif self.size == 4:
      res += "l"
    #which addr reg
    if addr.reg_id == RegEnum.A_REG:
      res += "p"
    elif addr.reg_id == RegEnum.B_REG:
      res += "q"
    #which dst reg
    if dst.reg_id == RegEnum.A_REG:
      res += "a"
    elif dst.reg_id == RegEnum.B_REG:
      res += "b"
    comp.asm.cmd(res)

  def gen_store_from_addr(self, comp: 'CompilerInst', addr: 'Reg', src: 'Reg') -> None:
    assert addr.reg_id != src.reg_id, "Addr and src regs have to be different"
    #store prefix
    res = "s"
    #size
    if self.size == 1:
      res += "b"
    elif self.size == 2:
      res += "w"
    elif self.size == 4:
      res += "l"
    #which addr reg
    if addr.reg_id == RegEnum.A_REG:
      res += "p"
    elif addr.reg_id == RegEnum.B_REG:
      res += "q"
    #which reg to store
    if src.reg_id == RegEnum.A_REG:
      res += "a"
    elif src.reg_id == RegEnum.B_REG:
      res += "b"
    comp.asm.cmd(res)

  #cast to an int - sign extensions may be needed
  def cast_to_int(self, comp: 'CompilerInst', reg: Reg, tar_type: 'BaseCType') -> None:
    #if this type is signed and we are casting to a larger type, sign extend
    if self.signed and tar_type.size > self.size:
      #32 bit sign extend
      if tar_type.size > 2:
        comp.asm.comment("Sign extend to 32 bits")
        comp.asm.cmd("nimp")
      #16 bit sign extend
      if tar_type.size == 2:
        if reg.reg_id == RegEnum.A_REG:
          comp.asm.cmd("asex")
        else:
          comp.asm.comment("Sign extend b register 16 bit")
          comp.asm.cmd("nimp")

  #cats to pointer - sign extends needed if char
  def cast_to_pointer(self, comp: 'CompilerInst', reg: Reg, tar_type: 'BaseCType') -> None:
    if self.signed and self.size < Defs.POINTER_SIZE:
      #signed extend to 16 bit pointer
      if reg.reg_id == RegEnum.A_REG:
        comp.asm.cmd("asex")
      else:
        comp.asm.comment("Sign extend b register 16 bit")
        comp.asm.cmd("nimp")