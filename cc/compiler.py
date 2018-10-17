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

from struct_decl import StructDeclaration

import pycparser as pyc

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

ast = pyc.parse_file("test.c")
ast.ext[5].type.show(nodenames = True)
StructDeclaration.add_struct_type(ast.ext[3].type)
StructDeclaration.add_struct_type(ast.ext[4].type)
print(vars(CTypeGenerator.gen_type(ast.ext[5].type)))