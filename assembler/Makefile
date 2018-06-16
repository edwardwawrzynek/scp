all: scpasm scplnk scpmif
scpasm: machine_back.c main.c
	gcc -o scpasm main.c
scplnk: linker.c
	gcc -o scplnk linker.c
scpmif: bin_to_mif.c
	gcc -o scpmif bin_to_mif.c	
