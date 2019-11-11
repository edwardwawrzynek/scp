#! /bin/bash

make -C lib/src
make -C os
make -C userspace

scpmkfs fs disk.img
scpemu bios/bios -g -d disk.img -s /dev/tnt0

