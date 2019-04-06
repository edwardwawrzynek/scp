# Small C Processor (scp)
A small, 16 bit processor design to learn about computers.

SCP consists of:

* a FPGA implementation (in progress)
* emulator (complete)
* assembler and linker (complete)
* ANSI C compiler (ported vbcc) (complete)
* An operating system (nearly complete)
* C standard library (in progress)
* A usable software stack (in progress)

## Processor Architecture
The detailed ISA is described in `isa.md`. SCP is a 16 bit, 16 register, orthogonal RISC architecture. It supports a basic MMU that can have up to 256 kiB of memory (up to 64 kiB addressable by one process) in pages of 2 kiB. With privileged instruction restrictions, it supports memory protection. SCP provides a basic interrupt system and two ring privilege model. All SCP instructions (and full binaries) are relocatable without any run time linking.

### IO Subsystems
The current implementation's IO subsystems are as follows:

- VGA graphics, including
    - Hardware rendered 80x25 text display (black and white)
    - 320 x 200 8 bit graphics (2 red bits, 2 blue, 3 green)
- 115200 baud buffered serial port
- Buffered SD card io
- Buffered PS/2 keyboard io
- LED output

## Programming Support
SCP has a custom linker and assembler. The assembler is fairly simple, and outputs SCP's object code format. The object code format supports static linking, and the linker is capable of removing unused functions when linking with libraries, resulting in smaller code size. SCP's binaries are relocatable due to the processor architecture, and don't need run time linking.

SCP supports a ported version of the vbcc ANSI C compiler. It is lacking floating point types and 32 bit longs (only 16 bit values are supported), but is otherwise nearly complete, and supports some C99 features.

## Software
### OS
The SCP OS is somewhat Unix-like. It supports the following:

- Filesystem (custom format):
    - Normal files and directories (64 kB size limit per file)
    - Hard links
    - Device files
    - Pipes
- Preemptive multitasking process system:
    - File descriptors
    - Somewhat standard unix syscalls (fork, exec, read, open, etc)
    - Signals (in progress)
    - Memory allocation

SCP also has an implementation of the ANSI C standard library, including somewhat efficient malloc and file buffering implementations.

### Programs
TODO
