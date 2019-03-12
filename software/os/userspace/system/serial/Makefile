all: serial scpftp

serial: serial.c serial.h
	vc -O1 -o serial serial.c -c99 -linout -lc -lsyscall -L../../syscall_lib/ -I../../syscall_lib

scpftp: host.c serial.h
	cc -o scpftp host.c -lserialport