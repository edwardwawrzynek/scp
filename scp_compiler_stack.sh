#!/bin/bash

#automates c compiling, linking, assembling, and binary and mif file output for scp

usage() {
echo "Usage: scpc [-o bin_out] [-m mif_out] [-a asm_out] [-l file_to_link.s] [-L directory_to_link] [-h] file.c"
}

#Binary out - will always be generated
OUTPUT="a.out"

#Mif output - will only be generated with -m flag
MIF_OUTPUT=""
DO_MIF=false

#Asembley output - this is deleted if -a is not specified
ASM_OUTPUT=""
DO_ASM=false

#Files to link with
LINKS="/home/edward/scp/smallC/scp/cret.asm /home/edward/scp/smallC/scp/crun.asm /home/edward/scp/smallC/scp/lib.s /home/edward/scp/smallC/lib/lib.s"

while getopts "ho:m:a:l:L:" opt; do
  case $opt in
    o)
      OUTPUT=$OPTARG
      ;;
    h)
    	usage
    	;;
    m)
    	MIF_OUTPUT=$OPTARG
    	DO_MIF=true
    	;;
    a)
    	ASM_OUTPUT=$OPTARG
    	DO_ASM=true
    	;;
    l)
    	LINKS="$LINKS $OPTARG"
    	;;
    L)
    	LINKS="$LINKS $OPTARG/*.s"
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
#Link
#Add output to linking
LINKS="$LINKS $name"

scplnk "SCP_ASM_LINKED.s" $LINKS


#Assemble
scpasm $OUTPUT "SCP_ASM_LINKED.s"
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