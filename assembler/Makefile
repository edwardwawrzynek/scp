all: scpasm scplnk scpmif
scpasm: assembler.c
	gcc -o scpasm assembler.c
scplnk: linker.c
	gcc -o scplnk linker.c
scpmif: bin_to_mif.c
	gcc -o scpmif bin_to_mif.c
install:
	sudo ln -s `pwd`/scpasm /usr/local/bin/scpasm \
	sudo ln -s `pwd`/scplnk /usr/local/bin/scplnk \
	sudo ln -s `pwd`/scpmif /usr/local/bin/scpmif \
	sudo ln -s `pwd`/scpcasmfix /usr/local/bin/scpcasmfix
