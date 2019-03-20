#! /bin/bash

out=$1
shift

rm -rf "$out"
mkdir "$out"

index=0

for file in "$@"
do
    cp "$file" "$out"/"$index".o
    index=$((index+1))
done