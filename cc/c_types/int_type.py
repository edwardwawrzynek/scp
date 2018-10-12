import typing
from defs import Defs
from c_types.base_type import BaseCType

#integar types
class IntCType(BaseCType):
  def __init__(self):
    #the integer's size
    self.size = 0
    #if the integar is signed
    self.signed = True

  def new(self, size: int, signed: bool) -> 'BaseCType':
    self.size = size
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