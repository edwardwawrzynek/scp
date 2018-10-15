import typing

import pycparser as pyc

from defs import Defs
from c_types.struct_type import StructCType
from c_types.type_gen import CTypeGenerator

class StructDeclaration:
    #global struct table of StructDeclarations
    struct_table: 'StructDeclaration' = []
    #union table
    union_table: 'StructDeclaration' = []

    def __init__(self, name: str, struct_type: StructCType) -> None:
        self.name = name
        self.type = struct_type

    #add a StructCType from a pyc Struct or Union to the global struct type table
    @staticmethod
    def add_struct_type(struct_decl: typing.Union[pyc.c_ast.Struct, pyc.c_ast.Union]) -> StructCType:
        decl_type = type(struct_decl)

        assert decl_type == pyc.c_ast.Struct or decl_type == pyc.c_ast.Union, "Structs declared must be pyc Struct or Union"

        res_type = StructCType()

        if decl_type == pyc.c_ast.Struct:
            StructDeclaration.struct_table.append(
                StructDeclaration(struct_decl.name, res_type) )
        elif decl_type == pyc.c_ast.Union:
            StructDeclaration.union_table.append(
                StructDeclaration(struct_decl.name, res_type) )

        field_names = []
        field_types = []
        for field in struct_decl.decls:
            field_names.append(field.name)
            field_types.append(CTypeGenerator.gen_type(field.type))

        res_type.new(field_names, field_types, True if decl_type == pyc.c_ast.Union else False)

    #get the struct type from a struct name
    def get_struct_type(name: str, is_union: bool) -> StructCType:
        #get which table to search
        decls = StructDeclaration.union_table if is_union else StructDeclaration.struct_table
        #search the table
        for entry in decls:
            if entry.name == name:
                return entry.type
        Defs.error("No such " + ("union" if is_union else "struct") + " type: " + name)
        return StructCType()