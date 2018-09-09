#!/usr/bin/python

import sys
''' Generate a charset binary file from a verilog style hex memory initilizer '''

def main():
    if len(sys.argv) != 3:
        print "Usage: gen_charset.py [charset.txt] [out]"
        exit()
    inf = open(sys.argv[1], "r")
    outf = open(sys.argv[2], "w")

    for l in inf:
        d = int(l, 16)
        for i in range(8):
            outf.write(chr(d&0xff))
            d = d >> 8

main()