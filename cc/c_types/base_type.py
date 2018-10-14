import typing
from defs import Defs
from regs import Reg, RegEnum

#a class that describes a variable's type, and functions associated with that type
class BaseCType:
  #-- creation --
  #init should only create an empty type
  def __init__(self):
    pass

  #create should actually set the type's properties
  #def new(self) -> 'BaseCType':
  #  #set type parameters
  #  return self

  #-- sizes --
  #get the size of the type in global memory
  def get_storage_size(self) -> int:
    return 0

  #get the size of the type when loaded in a register
  def get_reg_size(self) -> int:
    #this depends on how the type loads itself into a register
    #for an int, just size. for something like an array that is loaded as a pointer, POINTER_SIZE
    return 0

  #get the size of the type when loaded onto the stack as an arguement or local
  def get_stack_size(self) -> int:
    #usually storage size, but chars are passed as ints, and some things like functions can't be passed on the stack
    return 0

  #-- code generation --

  #given the addr of the value in reg addr, load the value into reg dst (addr and dst may be the same reg)
  def gen_load_from_addr(self, comp: 'CompilerInst', addr: 'Reg', dst: 'Reg') -> None:
    comp.asm.comment("BaseType load")

  #given the addr of the value in reg addr and the value in reg src, store value (addr and dst are different regs)
  def gen_store_from_addr(self, comp: 'CompilerInst', addr: 'Reg', src: 'Reg') -> None:
    comp.asm.comment("BaseType store")