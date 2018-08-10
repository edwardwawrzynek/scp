# Small C Processor (scp)
A FPGA implemented processor designed to work well with a Small C compiler. SCP
features a full compiler, assembler, and linker suite, and has a file based
multitasking OS (a work in progress).

## The Hardware Description
The quartus project is located in `quartus`, and is the physical implementation
of the cpu. Each subfolder contains verilog and ip files for the individual
components of the cpu. Some of the IO (keyboard and text output) is taken from a
previous [project](https://github.com/edwardwawrzynek/comp16.git) of mine, while
some parts, including the disk and graphics systems, are new.

## The Compilation Suite
`scp_compiler_stack.sh` contains a bash script to easily compile, link, assemble,
optimize, and provides other useful features. It is installed as `scpc`, and its
usgae is as follows:
```
Usage: scpc [options] files
Options:
-o bin_out :specifies the file to write the final binary to(defaults to a.out)
-m mif.mif :if specified, a memory initialization file for scp is generated
-a asm.s   :if specified, the fully linked assembly output is saved
-s asm.s   :if specified, the non-linked assembly is saved
-l file.s  :links an assembly file to be directly before the c file assembly
-L dir     :all files in the directory ending in .s are linked
-c         :assemble files instead of compiling
-X	   :don't link and assemble - only generate asms with .s extension on .c
-f file.s  :links an assembly file at the very end of the binary
-h         :display usage
-e         :if specified, the binary is put against the end of the address space
-n         :don't link asms associated with included system header files
-I	   :fix #asm prefixed section's indentation with scpcasmfix
-O:	   :run scpopt optimizer on the asm files
```
The tools that scpc uses are located in `smallC`, which contains the compiler,
and `assembler`, which contains an assembler (`scpasm`) and linker (`scplnk`)
written in c, as well as an assembly optimizer (`scpopt`), binary to memory
initialization file converter (`scpbintomif`), and a tool to fix inline assembly
formatting in c files (`scpasmfix`). All of these are invoced through options in
`scpc`.

## The Software
Software for SCP is located [here](https://github.com/edwardwawrzynek/scp_software),
and includes a few games, demos and partial c standard library implementation, as
well as a work in progress Operating System including a complete filesystem and
multitasking and memory managment facilities.

## The C Compiler
The `smallC` directory contains the small c compiler
(from [here](https://github.com/ncb85/SmallC-85)) with a scp code generator and
a significant amount of changes to increase functunality and fix bugs. The
compiler used is based on Chris Lewis's port of Ron Cain's original small c
compiler.

## The Microcode Assembler
Located in `microcode`, this tool takes a source file specifying microcode
signal values in a convinent format, and converts them a decode rom file. The
`defs.txt` contains signal definitions, and `microcode.txt` contains the actual
description of each instruction.
