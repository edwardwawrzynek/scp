import typing
from defs import Defs
from c_types.base_type import BaseCType

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