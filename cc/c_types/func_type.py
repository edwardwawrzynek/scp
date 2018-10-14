import typing
from defs import Defs
from c_types.base_type import BaseCType
from regs import Reg, RegEnum

#func type
#this class is more of an abstraction for simplicity, as functions can't really be passed around or manipulated
#it allows easy function pointers and declaration storing
class FuncCType(BaseCType):
  def __init__(self):
    #the func return type
    self.return_type: BaseCType = None
    #the functions argument types
    self.arg_types: typing.List[BaseCType] = []

  def new(self, return_type: BaseCType, arg_types: typing.List[BaseCType]) -> 'BaseCType':
    self.return_type = return_type
    self.arg_types = arg_types

    return self

  #-- sizes --
  def get_storage_size(self) -> int:
    #can't be stored
    raise AssertionError("Functions can't be stored as values")
    return 0

  def get_reg_size(self) -> int:
    return Defs.POINTER_SIZE

  def get_stack_size(self) -> int:
    #can't be passed
    raise AssertionError("Functions can't be passed as values on the stack")
    return 0

  def gen_load_from_addr(self, comp: 'CompilerInst', addr: 'Reg', dst: 'Reg') -> None:
    #funcs are loaded as their addr - only do something if addr and dst are different
    if addr.reg_id == RegEnum.A_REG and dst.reg_id == RegEnum.B_REG:
      comp.asm.cmd("mvab")
    elif addr.reg_id == RegEnum.B_REG and dst.reg_id == RegEnum.A_REG:
      comp.asm.cmd("mvba")
    pass

  def gen_store_from_addr(self, comp: 'CompilerInst', addr: 'Reg', src: 'Reg') -> None:
    assert addr.reg_id != src.reg_id, "Addr and src regs have to be different"
    #functions can't be assigned values
    raise AssertionError("functions aren't lvalues")
    pass