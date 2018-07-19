# Small C Processor (scp)
A FPGA implemented processor designed to work well with a Small C compiler. 

## The Hardware Description
The quartus project is located in `quartus`, and is the physical implementation of the cpu. Each subfolder contains verilog and ip files for the individual components of the cpu.

## The Processor
The quartus project for scp is in the `quartus` directory, and is primarily written in verilog. Most of the IO is taken from a previous [project](https://github.com/darksteelcode/comp16.git) of mine. If you read the code for the project, you may realize that most of the non-IO code is simple - it is meant to be this way, as the processor is meant to be described near a lower hardware level.

## The Compiler
The `smallC` directory contains the compiler with my code generator, and may contain a few other small changes. The compiler used is based on the compiler [here](https://github.com/ncb85/SmallC-85), which is a version of Chris Lewis's port of Ron Cain's original small c compiler.

## The Assembler
The assembler and linker are located in `assembler`. Running `scpasm` and `scplnk` in that directory will give their options.

## The Microcode Assembler
Located in `microcode`, this tool takes a source file specifying microcode signal values in a convinent format, and converts them a decode rom file.
