#! /bin/bash

make -C lib/src
make -C os
make -C userspace

scpmkfs fs disk.img
scpemu bios/bios -f 35.0 -g -d disk.img -s /dev/tnt0
#scpemu os/bin/scpos -g
