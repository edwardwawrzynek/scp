#!/bin/bash

#automates c compiling, linking, assembling, and binary and mif file output for scp

usage() {
echo "Usage: scpc [options] file.c
Options:
-o bin_out :specifies the file to write the final binary to(defaults to a.out)
-m mif.mif :if specified, a memory initialization file for scp is generated
-a asm.s   :if specified, the fully linked assembly output is saved
-s asm.s   :if specified, the non-linked assembly is saved
-l file.s  :links an assembly file to be directly before the c file assembly
-L dir     :all files in the directory ending in .s are linked
-f file.s  :links an assembly file at the very end of the binary
-h         :display usage
-e         :if specified, the binary is put against the end of the address space"
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

#Files to link with
LINKS="/home/edward/scp/smallC/scp/cret.asm /home/edward/scp/smallC/scp/crun.asm /home/edward/scp/smallC/scp/lib.s /home/edward/scp_software/lib/lib_asms/small_c_lib.s"
#File to link at end
END_LINK=""
while getopts "eho:m:a:s:l:L:f:" opt; do
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

#Compile the file
sccscp $1
#figure out what file it was assembled to (.s instead of .c)
name=$(echo "$1" | cut -f 1 -d '.')
name="$name.s"
if [ "$DO_CLEAN_ASM" == "true" ]; then
	cp $name $CLEAN_ASM_OUTPUT
fi
#Link
#Add output to linking
LINKS="$LINKS $name $END_LINK"

scplnk "SCP_ASM_LINKED.s" $LINKS


#Assemble
if [ "$DO_END" == "true" ]; then
	scpasm -e $OUTPUT "SCP_ASM_LINKED.s"
else
	scpasm $OUTPUT "SCP_ASM_LINKED.s"
fi
rm $name
#If -a was specified, preserve asm
if [ "$DO_ASM" == "true" ]; then
	mv "SCP_ASM_LINKED.s" $ASM_OUTPUT
else
	rm "SCP_ASM_LINKED.s"
fi
#if -m was specified, generate a mif file
if [ "$DO_MIF" == "true" ]; then
	scpmif $OUTPUT $MIF_OUTPUT
fi