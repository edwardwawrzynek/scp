import typing
from defs import Defs

#register enumerations
class RegEnum:
  A_REG = 0
  B_REG = 1

#class representing a register, and it state (type loaded) in execution
class Reg:
  def __init__(self, reg_id: int) -> None:
    #if the register has information loaded in it that needs to be kept
    self.data_loaded = False
    #the type of information loaded in the register
    self.type = None
    #which reg it is (A_REG or B_REG)
    self.reg_id = reg_id

  #get the type in the register, or False if none is needed to be saved
  def get_type(self):
    if not self.data_loaded:
      return False
    return self.type

  #mark the register as not containing any data that needs to be saved
  def mark_not_in_use(self) -> None:
    self.data_loaded = False

  def set_type(self, type) -> None:
    self.type = type
    self.data_loaded = True