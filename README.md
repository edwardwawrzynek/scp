# Small C Processor (scp)
**This project is active, and is not close to completion or a working stage. This README describes the likely structure of the project**
A FPGA Implemented processor designed to work well with a Small C compiler. While the Small C compiler is rather inefficient, this project is an attempt to build a microprocessor that runs Small C generated code well, and is more of a learning project for myself than anything else.

## The Hardware Description
The quartus project is located in `quartus`, and is the physical implementation of the cpu. Each subfolder contains verilog and ip files for the individual components of the cpu.

## The Processor
The quartus project for scp is in the `quartus` directory, and is primarily written in verilog. Most of the IO is taken from a previous [project](https://github.com/darksteelcode/comp16.git) of mine. If you read the code for the project, you may realize that most of the non-IO code is simple - it is meant to be this way, as the processor is meant to be described near a lower hardware level.

## The Compiler
The `smallC` directory contains the compiler with my code generator, and may contain a few other small changes. The compiler used is based on the compiler [here](https://github.com/ncb85/SmallC-85), which is a version of Chris Lewis's port of Ron Cain's original compiler to be able to be compiled with a modern c compiler.

## The Assembler
The assembler is located in `assembler`, and assembles code in the format emitted by Small C.

## The Microcode Assembler
Located in `microcode`, this tool takes a source file specifying microcode signal values in a convinent format, and converts them a decode rom file. It is written by me in python, and likely very buggy, but it seems to work.
