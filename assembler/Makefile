all: scpasm scpasmold scplnk scpmif scpcasmfix
scpasm: assembler.c
	gcc -o scpasm assembler.c
scpasmold: assembler_machine_back.c old_asm.c
	gcc -o scpasmold old_asm.c
scplnk: linker.c
	gcc -o scplnk linker.c
scpmif: bin_to_mif.c
	gcc -o scpmif bin_to_mif.c
scpcasmfix: smallc_asm_fix.c
	gcc -o scpcasmfix smallc_asm_fix.c
