#!/usr/bin/python

import sys

if len(sys.argv) != 3:
    print "Usage: conv in out"

inf = open(sys.argv[1], "r")
otf = open(sys.argv[2], "w")

data = inf.read()
data = data.split(" ")

for i in data:
    otf.write(chr(int(i, 2)))

otf.close()
inf.close()
