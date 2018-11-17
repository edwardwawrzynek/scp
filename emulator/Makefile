all: scpemu scpasm

EMU_SRC=cpu.cpp main.cpp io/io.cpp io/serial.cpp

scpemu: ${EMU_SRC}
	g++ -g -std=c++11 -o scpemu -Wall ${EMU_SRC} -lserialport

scpasm: asm.c
	gcc -Wall -o scpasm asm.c