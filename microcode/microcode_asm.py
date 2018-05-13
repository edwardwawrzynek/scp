#!/usr/bin/python
import sys

def getSigsFromFile(f):
    #signal name definitions
    sigs = []

    #Open definitions file
    defF = open(f)
    #Parse name definitions from file format: num(s): name (anything else is discarded)
    for l in defF:
        words = l.split(' ')
        addr = words[0][:-1]
        name = words[1]
        #Signal position start and end - if one bit, these are the same
        start = 0
        end = 0
        if addr[0] == '[':
            start = int(addr[1:-1].split(":")[1])
            end = int(addr[1:-1].split(":")[0])
        else:
            start = int(addr)
            end = int(addr)
        sigs.append([name,start,end])
    return sigs

sigs = getSigsFromFile("defs.txt")
print sigs