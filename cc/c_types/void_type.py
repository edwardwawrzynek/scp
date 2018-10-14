import typing
from defs import Defs
from c_types.base_type import BaseCType
from regs import Reg, RegEnum

#void type - used for pointers and function return values
class VoidCType(BaseCType):
  def __init__(self):
    pass

  def new(self) -> 'BaseCType':
    return self

  #-- sizes --
  def get_storage_size(self) -> int:
    raise AssertionError("Voids can't be stored as values")
    return 0

  def get_reg_size(self) -> int:
    raise AssertionError("Voids can't be loaded as values")
    return 0

  def get_stack_size(self) -> int:
    raise AssertionError("Voids can't be passed as values")
    return 0

  def gen_load_from_addr(self, comp: 'CompilerInst', addr: 'Reg', dst: 'Reg') -> None:
    raise AssertionError("Voids can't be loaded")

  def gen_store_from_addr(self, comp: 'CompilerInst', addr: 'Reg', src: 'Reg') -> None:
    raise AssertionError("Voids can't be stored")
    pass