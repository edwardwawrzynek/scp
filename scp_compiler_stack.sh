#!/bin/bash

#automates c compiling, linking, assembling, and binary and mif file output for scp

usage() {
echo "Usage: scpc [-o bin_out] [-m mif_out] [-a asm_out] [-l file_to_link] [-L directory_to_link] [-h] file.c"
}

OUTPUT="a.out"

while getopts "ho:" opt; do
  case $opt in
    o)
      OUTPUT=$OPTARG
      ;;
    h)
    	usage
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

echo $OUTPUT