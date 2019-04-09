all: serial scpftp

serial: serial.c serial.h
	vc -O1 -o serial serial.c -c99 -lc
scpftp: host.c serial.h
	cc -o scpftp host.c -lserialport