#!/usr/bin/python

import sys
''' Generate a charset binary file from a verilog style hex memory initilizer '''

def main():
    if len(sys.argv) != 3:
        print "Usage: gen_charset.py [charset.txt] [charset.c]"
        exit()
    inf = open(sys.argv[1], "r")
    outf = open(sys.argv[2], "w")
    outf.write("uint64_t io_charset[256] = {");
    for l in inf:
        outf.write("\n0x" + l[:-1] + ", ")
    outf.write("};")
    outf.close()


main()