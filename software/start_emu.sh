#! /bin/bash

make -C lib/src
make -C os
make -C userspace

scpmkfs fs disk.img
scpemu os/bin/scpos -g -d disk.img -s /dev/tnt0

