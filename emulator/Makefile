all: scpemu
scpemu: main.c opcodes.c io.c
	gcc -O3 -Wall -o scpemu main.c -lSDL2 -lserialport
