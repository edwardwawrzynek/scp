#!/bin/bash

#automates c compiling, linking, assembling, and binary and mif file output for scp

usage() {
echo "Usage: scpc [options] files
Options:
-o bin_out :specifies the file to write the final binary to(defaults to a.out)
-m mif.mif :if specified, a memory initialization file for scp is generated
-a asm.s   :if specified, the fully linked assembly output is saved
-s asm.s   :if specified, the non-linked assembly is saved
-l file.s  :links an assembly file to be directly before the c file assembly
-L dir     :all files in the directory ending in .s are linked
-c         :assemble files instead of compiling
-X	   :don't link and assemble - only generate asms with .s extension on .c
-f file.s  :links an assembly file at the very end of the binary
-h         :display usage
-e         :if specified, the binary is put against the end of the address space
-n         :don't link asms associated with included system header files
-I	   :don't fix #asm prefixed section's indentation with scpcasmfix
-O:	   :run scpopt optimizer on the asm files"
}

#Binary out - will always be generated
OUTPUT="a.out"

#Mif output - will only be generated with -m flag
MIF_OUTPUT=""
DO_MIF=false

#Asembley output - this is deleted if -a is not specified
ASM_OUTPUT=""
DO_ASM=false

#whether to place prgm at end of addr space or not
DO_END=false

#Non linked assembley output
CLEAN_ASM_OUTPUT=""
DP_CLEAN_ASM=false

#whether to link files in .incl
LINK_INCS=true
INCL_FILE=""

#whether to compile the c files
DO_COMP=true

#whether to run scpcasmfix on the c files
DO_ASMFIX=true

#whether to stop before asm and lnk
DO_STOP_ASMLNK=false

#whether to run scpopt on the asm file
DO_OPT=false

#Files to link with
LINKS="/home/edward/scp_software/lib/include/cret.s /home/edward/scp_software/lib/include/crun.s"
END_LINK=""
while getopts "ehncIXOo:m:a:s:l:L:f:" opt; do
  case $opt in
    e)
	DO_END=true
	;;
    o)
      	OUTPUT=$OPTARG
      	;;
    h)
    	usage
    	exit 1
    	;;
    n)
        LINK_INCS=false
        ;;
    c)
    	DO_COMP=false
    	;;
    I)
    	DO_ASMFIX=false
    	;;
    X)
    	DO_STOP_ASMLNK=true
    	;;
    O)
    	DO_OPT=true
    	;;
    m)
    	MIF_OUTPUT=$OPTARG
    	DO_MIF=true
    	;;
    a)
    	ASM_OUTPUT=$OPTARG
    	DO_ASM=true
    	;;
    s)
    	CLEAN_ASM_OUTPUT=$OPTARG
    	DO_CLEAN_ASM=true
    	;;
    l)
    	LINKS="$LINKS $OPTARG"
    	;;
    L)
    	LINKS="$LINKS $OPTARG/*.s"
    	;;
    f)
    	END_LINK="$END_LINK $OPTARG"
    	;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ $# == 0 ]; then
	usage
	exit 1
fi

shift $((OPTIND-1))

ASMD_FILES=""
INCLD_FILES=""
C_FILES="$@"

#Compile the file, generating .incl
if [ "$DO_COMP" == "true" ]; then
	if [ "$DO_ASMFIX" == "true" ]; then
		for c_file in "$@"
		do
			mv "$c_file" "$c_file.scpcasmfix"
			scpcasmfix "$c_file.scpcasmfix" "$c_file"
			rm "$c_file.scpcasmfix"
		done
	fi
	sccscp -i "$C_FILES"
fi

#set asm and incl file names
if [ "$DO_COMP" == "true" ]; then
	for arg in "$C_FILES"
	do
		ASMD_FILES="$ASMD_FILES $(echo "$arg" | cut -f 1 -d '.').s"
		INCLD_FILES="$INCLD_FILES $(echo "$arg" | cut -f 1 -d '.').incl"
	done
else
	ASMD_FILES="$C_FILES"
	touch .SCP_INCL_FAKE.incl
	INCLD_FILES=".SCP_INCL_FAKE.incl"
fi

#stop with just asms
if [ "$DO_STOP_ASMLNK" == "true" ]; then
	rm $INCLD_FILES
	exit 0
fi

#write incl files to one incl file
cat $INCLD_FILES >> .SCP_INCL_COMBINED_REP.incl
rm $INCLD_FILES

sort .SCP_INCL_COMBINED_REP.incl | uniq >> .SCP_INCL_COMBINED.incl
rm .SCP_INCL_COMBINED_REP.incl

INCL_FILE=".SCP_INCL_COMBINED.incl"

#Write out full clean asm
if [ "$DO_CLEAN_ASM" == "true" ]; then
	cat $ASMD_FILES > $CLEAN_ASM_OUTPUT
fi
#Link
#Add output to linking
LINKS="$LINKS $ASMD_FILES $END_LINK"

if [ "$LINK_INCS" == "true" ]; then
	scplnk -i .SCP_INCL_COMBINED.incl .SCP_ASM_LINKED.s $LINKS
else
	scplnk ".SCP_ASM_LINKED.s" $LINKS
fi

#remove .incl file
rm .SCP_INCL_COMBINED.incl

LINKD_ASM=".SCP_ASM_LINKED.s"

#optimize
if [ "$DO_OPT" == "true" ]; then
	scpopt "$LINKD_ASM" ".SCP_ASM_LINKED.s.opt"
	LINKD_ASM=".SCP_ASM_LINKED.s.opt"
fi

#Assemble
if [ "$DO_END" == "true" ]; then
	scpasm -e $OUTPUT "$LINKD_ASM"
else
	scpasm $OUTPUT "$LINKD_ASM"
fi
if [ "$DO_COMP" == "true" ]; then
	rm $ASMD_FILES
fi
#If -a was specified, preserve asm
if [ "$DO_ASM" == "true" ]; then
	mv "$LINKD_ASM" $ASM_OUTPUT
else
	rm "$LINKD_ASM"
fi
#if -m was specified, generate a mif file
if [ "$DO_MIF" == "true" ]; then
	scpmif $OUTPUT $MIF_OUTPUT
fi