import typing
from defs import Defs
from c_types.base_type import BaseCType

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