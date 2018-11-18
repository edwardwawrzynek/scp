all: scpemu scpasm

EMU_SRC=cpu.cpp main.cpp io/io.cpp io/serial.cpp io/gfx.cpp io/gfx_charset.cpp

scpemu: ${EMU_SRC}
	g++ -g -std=c++11 -o scpemu -Wall ${EMU_SRC} -lserialport -lSDL2

scpasm: asm.c
	gcc -Wall -o scpasm asm.c