all: ../bin/crt0.o

../bin/crt0.o: crt0.o div.o
	vc -o ../bin/crt0.o crt0.o div.o

div.o: div.c
	vc -c -c99 -O3 -size div.c

crt0.o: crt0.s
	vc -c crt0.s
