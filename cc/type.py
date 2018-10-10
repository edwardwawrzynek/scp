import typing
from defs import Defs
#a class that describes a variable's type, and functions associated with that type
class Type:
  def __init__(self):
    #-- sizes --
    #size when loaded into register - not the same as the machine's base register width
    #for something like an int, this is the same as its width
    #for something like a struct or function, it is kept as a pointer in the reg, and is just pointer width
    self.reg_size = 0
    #size in static storage
    self.storage_size = 0
    #size on stack
    #mostly the same as storage_size, but chars are passed as 2 byte values
    #structs are passed on the stack without needing pointers and memcpy (probably), and it makes no sense to
    #pass functions, as functions as a type are just an abstraction for function pointers and function type checking
    self.stack_size = 0

    #-- type details --
    #integar type
    self.is_int = False
    #if the int is signed
    self.int_signed = True

    #pointer type
    self.is_ptr = False
    #what type the pointer points to
    self.ptr_type: Type = None

    #array type
    self.is_array = False
    #type of elements
    self.array_type: Type = None
    #number of elements
    self.array_num_elements = 0

    #struct and union type (refered to as struct - union is just a packing distinction)
    self.is_struct = False
    #(False=struct, True=union)
    self.pack_union = False
    #fields
    #field name
    self.field_names: typing.List[str] = []
    #field type
    self.field_type: typing.List[Type] = []
    #field offset - calculated based on type
    self.field_offset: typing.List[int] = []

    #function type
    self.is_func = False
    #return type
    self.func_return_type: Type = None
    #argument types
    self.func_types: typing.List[Type] = []

  #-- type generators --
  #generate an int type
  @staticmethod
  def from_int(size: int, signed: int) -> 'Type':
    res = Type()
    res.is_int = True
    res.int_signed = True
    #generate sizes
    res.reg_size = size
    res.storage_size = size
    #if char, pass as a 2 byte value
    res.stack_size = size if not size < Defs.REG_SIZE else Defs.REG_SIZE

    return res

  #generate a pointer type
  @staticmethod
  def from_pointer(ptr_type: 'Type') -> 'Type':
    res = Type()
    res.is_ptr = True
    res.ptr_type = ptr_type
    #sizes
    res.reg_size = Defs.POINTER_SIZE
    res.storage_size = Defs.POINTER_SIZE
    res.stack_size = Defs.POINTER_SIZE

    return res

  #generate an array type
  @staticmethod
  def from_array(elm_type: 'Type', num_elms: int) -> 'Type':
    res = Type()
    res.is_array = True
    res.array_num_elements = num_elms
    res.array_type = elm_type
    #sizes
    #TODO: add getters for type sizes to determine storage size
    return res
