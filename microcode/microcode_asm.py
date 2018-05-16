#!/usr/bin/python
import sys

#Number of signals, in bits
SIG_BITS = 12
#Number of entries in the microcode rom
NUM_ENTRIES = 1024

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

def getStartAndEnd(name, sigs):
    for s in sigs:
        if s[0] == name:
            return s[1],s[2]
    print "ERROR: cmd " + name + " is not defined"
    exit()

def proc_microcode(f, outf, sigs):
    f = open(f)
    #Result array
    result = [[0]*SIG_BITS]*NUM_ENTRIES
    for l in f:
        #Output for this line- 0 by default
        out = [0] * SIG_BITS
        #Ignore comments
        i = l.find("//")
        if i!=-1:
            l = l[:i]
        #Replace whitespace
        l = l.replace(" ", "")
        l = l.replace("\n", "")
        l = l.replace("\t", "")
        #If line is empty, skip it
        if l == "":
            continue
        #Break line into addr, name, and body
        lSplit = l.split(":")
        addr = int(lSplit[0])
        name = lSplit[1]
        body = lSplit[2]
        #Split body into individual cmds
        cmds = body.split(",")
        #Change out for each cmd
        for c in cmds:
            #If no specific value is set, it is set to 1
            val = 1
            split = c.split('=')
            #If the sig name is set to a value, set val to it
            if len(split) > 1:
                val = int(split[1])
            c = split[0]
            start,end = getStartAndEnd(c, sigs)
            #amount to shift right to get each bit
            shift = end-start
            pos = end
            #iterate through each bit from start to end
            while pos >= start:
                out[pos] = (val>>shift)&1
                pos-=1
                shift -= 1
        result[addr] = out
    mifFile = open(outf, 'w')
    mifFile.write("WIDTH="+str(SIG_BITS)+";\nDEPTH="+str(NUM_ENTRIES)+";\nADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\nCONTENT BEGIN\n")
    for r in range(NUM_ENTRIES):
        mifFile.write("\t")
        mifFile.write(str(r))
        mifFile.write(" : ")
        #Write backwards, due to [0] neening to be written furthest right
        for b in reversed(result[r]):
            mifFile.write(str(b))
        mifFile.write(";\n")
    mifFile.write("END;")
    mifFile.close()

sigs = getSigsFromFile("defs.txt")
proc_microcode("microcode.txt", "microcode.mif", sigs)
