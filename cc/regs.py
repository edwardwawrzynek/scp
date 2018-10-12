import typing
from defs import Defs
from c_types.base_type import BaseCType

#class representing a register, and it state (type loaded) in execution
class Reg:
  def __init__(self):
    #if the register has information loaded in it that needs to be kept
    self.data_loaded = False
    #the type of information loaded in the register
    self.type: BaseCType = None

  #get the type in the register, or False if none is needed to be saved
  def get_type(self) -> typing.Union[BaseCType, bool]:
    if not self.data_loaded:
      return False
    return self.type

  #mark the register as not containing any data that needs to be saved
  def mark_not_in_use(self) -> None:
    self.data_loaded = False

  def set_type(self, type: BaseCType) -> None:
    self.type = type
    self.data_loaded = True