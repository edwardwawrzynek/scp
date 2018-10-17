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

  #-- loads and stores --

  #given the addr of the value in reg addr, load the value into reg dst (addr and dst may be the same reg)
  def gen_load_from_addr(self, comp: 'CompilerInst', addr: 'Reg', dst: 'Reg') -> None:
    comp.asm.comment("BaseType load")

  #given the addr of the value in reg addr and the value in reg src, store value (addr and dst are different regs)
  def gen_store_from_addr(self, comp: 'CompilerInst', addr: 'Reg', src: 'Reg') -> None:
    comp.asm.comment("BaseType store")

  #-- casts --
  #cast a value of this type in reg reg to type type
  #this shouldn't be overridden, rather, the cast_to_xxx methods should
  def casts_to(self, comp: 'CompilerInst', reg: Reg, tar_type: 'BaseCType') -> None:
    ty = type(tar_type)

    if ty == c_types.void_type.VoidCType:
      self.cast_to_void(comp, reg, tar_type)

    elif ty == c_types.ptr_type.PointerCType:
      self.cast_to_ptr(comp, reg, tar_type)

    elif ty == c_types.int_type.IntCType:
      self.cast_to_int(comp, reg, tar_type)

    elif ty == c_types.struct_type.StructCType:
      self.cast_to_struct(comp, reg, tar_type)

    elif ty == c_types.func_type.FuncCType:
      self.cast_to_func(comp, reg, tar_type)

    elif ty == c_types.array_type.ArrayCType:
      self.cast_to_array(comp, reg, tar_type)

    else:
      raise AssertionError("Can't cast to type " + str(tar_type))

  #cast to a void (valid but useless)
  def cast_to_void(self, comp: 'CompilerInst', reg: Reg, tar_type: 'BaseCType') -> None:
    #don't do anything
    pass

  #cast to a pointer
  def cast_to_pointer(self, comp: 'CompilerInst', reg: Reg, tar_type: 'BaseCType') -> None:
    #nothing needed
    pass

  #cast to a int
  def cast_to_int(self, comp: 'CompilerInst', reg: Reg, tar_type: 'BaseCType') -> None:
    #a sign extend may be needed for some types
    pass

  #cast to a struct - not allowed
  def cast_to_struct(self, comp: 'CompilerInst', reg: Reg, tar_type: 'BaseCType') -> None:
    #things can't be casted to structs ? (only pointers)
    Defs.error("can't cast to struct")

  #cast to a function - not allowed
  def cast_to_struct(self, comp: 'CompilerInst', reg: Reg, tar_type: 'BaseCType') -> None:
    #things can't be casted to function ? (only pointers)
    Defs.error("can't cast to functions")

  #cast to an array - not allowed
  def cast_to_array(self, comp: 'CompilerInst', reg: Reg, tar_type: 'BaseCType') -> None:
    #can't cast to array - (can cast to pointer to array)
    Defs.error("can't cast to array")