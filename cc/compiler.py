import typing
from defs import Defs
from asm_output import AsmOutput
from c_types.base_type import BaseCType
from c_types.int_type import IntCType
from c_types.ptr_type import PointerCType
from c_types.array_type import ArrayCType
from c_types.struct_type import StructCType
from c_types.void_type import VoidCType

from c_types.type_gen import CTypeGenerator

from regs import Reg, RegEnum

#a compiler instance - there will probably only be one anyway
class CompilerInst:
  def __init__(self):
    #asembly output
    self.asm = AsmOutput()
    #registers
    self.a_reg = Reg(RegEnum.A_REG)
    self.b_reg = Reg(RegEnum.B_REG)

  #get the other reg of the one passed
  def other_reg(self, reg: Reg) -> Reg:
    if reg.reg_id == RegEnum.A_REG:
      return self.b_reg
    else:
      return self.a_reg


comp = CompilerInst()

PointerCType().new(IntCType().new(1,True)).gen_store_from_addr(comp, comp.b_reg, comp.a_reg)

IntCType().new(2, True).gen_load_from_addr(comp, comp.a_reg, comp.a_reg)
ArrayCType().new(IntCType().new(1,True),10).gen_load_from_addr(comp, comp.a_reg, comp.b_reg)

comp.asm.print_asm()