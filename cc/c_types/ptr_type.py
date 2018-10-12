import typing
from defs import Defs
from c_types.base_type import BaseCType

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