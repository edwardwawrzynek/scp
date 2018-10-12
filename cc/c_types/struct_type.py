import typing
from defs import Defs
from c_types.base_type import BaseCType

#struct or union types
class StructCType(BaseCType):
  def __init__(self):
    #False = struct (don't pack on top of each other), True = union (pack elements on top of each other)
    self.pack_tight = False
    #field names
    self.field_names: typing.List[str] = []
    #field types
    self.field_types: typing.List[BaseCType] = []
    #offset of each field
    self.field_offset: typing.List[int] = []
    #total size of the struct
    self.size = 0

  def new(self, field_names: typing.List[str], field_types: typing.List[BaseCType], is_union: bool) -> 'BaseCType':
    self.field_names = field_names
    self.field_types = field_types
    #make sure field names and types are the same length
    assert len(self.field_names) == len(self.field_types), "struct field names and types must be equal length"
    self.pack_tight = is_union
    #calculate offsets and sizes
    self._calc_offsets()

    return self

  def _calc_offsets(self):
    offset = 0
    for f in self.field_types:
      #union
      if self.pack_tight:
        self.field_offsets.append(0)
        if f.get_storage_size() > offset:
          offset = f.get_storage_size()
      #struct
      else:
        self.field_offset.append(offset)
        offset += f.get_storage_size()
    self.size = offset

  #-- sizes --
  def get_storage_size(self) -> int:
    return self.size

  def get_reg_size(self) -> int:
    return Defs.POINTER_SIZE

  def get_stack_size(self) -> int:
    #structs can be passed on stack
    return self.size