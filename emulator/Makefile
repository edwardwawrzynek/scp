all: scpemu
scpemu: main.c opcodes.c io.c
	gcc -Wall -O3 -o scpemu main.c -lSDL2 -lserialport
