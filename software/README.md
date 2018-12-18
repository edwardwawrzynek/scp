# Small C Processor Software
This respository contains the Operating System, partial C standard library, and
a variety of programs and games for use on and with the
[Small C Processor](https://github.com/edwardwawrzynek/scp). The tools in the
previously linked respository, namely `scpc`, are required to build the programs.

## SCP OS
The Operating System (a work in progress) is located in `os`. The OS features a
full filesystem on an sd card, process abstraction, multitasking, and memory
managment, and has a number of features similar to UNIX systems, though greatly
simplified, supporting only one disk, and being single-user.

## C Library
A collection of C libraries iare implemented in `lib`. `lib/include` contains
include files and assemble libraries, and `lib/src` contains the source code for
the libraries. The following libraries are implemented: <br>
`stdio.h` - a stdio implementation, laking file support, but containing standard tty
io, including gets, puts, printf, etc.. <br>
`stdlib.h` - a limited stdlib, containing itoa, atoi, abs, rand, and a nearly working
malloc implementation <br>
`string.h` - fairly complete basic string.h functions <br>
`stdint.h` - stdint type specifiers <br>
`ctype.h` - c character type functions <br>
`gfx.h` - a scp specific graphics library, including basic shapes like rects,
triangles, etc, and text support <br>
`serial.h` - a scp specific library to use the onboard serial port <br>
`half.h` - a scp specific half precision floating point library - rather hacky
and buggy <br>

## Programs
`games` contains a pong and space invaders implementation, `demos` a colorful
mandelbrot renderer and graphics and sound demo, and `bootloader` a bootloader
suitable for sending programs to scp while running. `os_stuff` contains misc. 
stuff yet to be integrated into the os, but having direct applications to it.
