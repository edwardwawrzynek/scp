all: scpasm scplnk scpmif scpcasmfix
scpasm: assembler.c
	gcc -o scpasm assembler.c
scplnk: linker.c
	gcc -o scplnk linker.c
scpmif: bin_to_mif.c
	gcc -o scpmif bin_to_mif.c
scpcasmfix: smallc_asm_fix.c
	gcc -o scpcasmfix smallc_asm_fix.c
