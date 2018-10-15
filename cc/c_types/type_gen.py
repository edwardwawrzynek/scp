import typing

import pycparser as pyc

from defs import Defs
from c_types.base_type import BaseCType
from c_types.int_type import IntCType
from c_types.ptr_type import PointerCType
from c_types.array_type import ArrayCType
from c_types.struct_type import StructCType
from c_types.void_type import VoidCType

#generate a type from a pycparser type def
class CTypeGenerator:
  def __init__(self):
    pass

  #generate a type
  @staticmethod
  def gen_type(pyc_type: typing.Union[pyc.c_ast.TypeDecl, pyc.c_ast.PtrDecl, pyc.c_ast.ArrayDecl, pyc.c_ast.FuncDecl, pyc.c_ast.Typename, pyc.c_ast.IdentifierType]) -> 'BaseCType':
    decltype = type(pyc_type)

    if decltype == pyc.c_ast.TypeDecl:
      return CTypeGenerator.gen_type(pyc_type.type)

    if decltype == pyc.c_ast.IdentifierType:
      #this is either a basic type, or a typedef
      return CTypeGenerator.get_from_identifier_type(pyc_type)

    if decltype == pyc.c_ast.PtrDecl:
      #pointer to type
      return PointerCType().new(CTypeGenerator.gen_type(pyc_type.type))

    if decltype == pyc.c_ast.ArrayDecl:
      #array
      return ArrayCType().new(CTypeGenerator.gen_type(pyc_type.type), int(pyc_type.dim.value))

  @staticmethod
  def get_from_identifier_type(basic_type: pyc.c_ast.IdentifierType):
    #TODO: check typedefs here
    types = basic_type.names

    #an int type
    if "char" in types or "short" in types or "int" in types or "long" in types:
      signed = not "unsigned" in types
      size = Defs.INT_SIZE
      if "char" in types:
        size = Defs.CHAR_SIZE
      elif "short" in types:
        size = Defs.SHORT_SIZE
      elif "int" in types:
        size = Defs.INT_SIZE
      elif "long" in types:
        size = Defs.LONG_SIZE
      return IntCType().new(size, signed)

    #a void type
    if "void" in types:
      return VoidCType().new()