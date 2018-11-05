all: scpemu scpasm
scpemu: cpu.cpp main.cpp
	g++ -g -std=c++11 -o scpemu -Wall main.cpp cpu.cpp

scpasm: asm.c
	gcc -Wall -o scpasm asm.c