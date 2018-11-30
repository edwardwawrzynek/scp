# Considerations for object format

- At least two segments (read only and data) - is it worth it to have bss?
  - only small programs will be compiled on system anyway, so no real gains for bss
- Probably support four segments just in case we want to add segs
## Relocatable
- Segments must be relocatable independently of each other
  - Symbols and offsets must say which segments they are offsets in
- Must be able to staticaly link with external symbols
- Mabye use a byte before each data byte (or word) saying what it represents
  - Format?:

0|1|2|3|4|5|6|7
-|-|-|-|-|-|-|-
size|is_const|is_extern_symbol|seg_num(high)|seg_num(low)|is_pc_relative|

* size: if the byte marks a byte or word entry
* is_const: if true, just write the entry as it is (the rest of the entries assume is_const is false). if false, size has to be a word (offsets and symbols are always 2 bytes)
* is_extern_symbol: if the entry is a reference to an entry in a the external symbol table instead of an offset - seg num is irrelevant in this case
* seg_num: which segment the entry points to (ex: for an offset, this marks which segment this is an offset in)
* is_pc_relative: if the offset / symbol is pc-relative (most will be pc-relative) (non-pc-relative addresses are absolute addresses, while pc-relative addresses have to take into account location of symbol/offset, and relocation of current segment)

### PC-Relative offsets
They are encoded just like non-pc-relative addresses (just an offset in a segment), but additional calculations have to be done. A pc-relative address is encoded as:
```
addr - (pc + 2)
```
We addr is the absolute address of the symbol, and pc is the location of start of the instruction. However, since the linker will be dealing with the pc-relative address, which is an immediate at pc+2, the encoding is:
```
target_addr - cur_addr
```

## Symbol table
An external symbol table of symbols needing to be linked, and a symbol table with all of the global symbols defined in the file.

### External Table
Just names need to be listed. (Segment and offset will be gotten from other external symbol tables.)

### Table of defined symbols
Each entry has the following:
* symbol's name
* which segment it is in
* offset in the segment

## Linking
During linking, all external symbol references are looked for in defined symbol tables, resolved, and all the segments are combined.

Final output is a non-relocatable binary (can be made relocatable without addresses used in static initializations (a feature in c))

How the segments are arranged, and offsets between and in front of each can be specified.

NOTE: all offsets and such are in the file's segments, not the ultimate global segments. They all ultimately get combined, and addresses adjusted.