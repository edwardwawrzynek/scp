#!/usr/bin/python

import sys
''' Generate an opcode definition file from the scpasm source file
 * the scpasm source file should have a line formatted as follows:
 * char cmds[CMD_ARRAY_LEN] = "*a long string*";
 * and extracts the asm length of arguments with the following:
 * char cmd_lens[NUM_CMDS] = {array};
 * this code extracts this an generates a definition file for the emulator '''

def main():
    if len(sys.argv) != 3:
        print "Usage: gen_opcode_defs.py [asm.c] [defs.c]"
        exit()
    inf = open(sys.argv[1], "r")
    outf = open(sys.argv[2], "w")

    data = inf.read()

    pos = data.find("cmds[CMD_ARRAY_LEN] =")
    if pos == -1:
        print "Can't find asm definitions in file - must contain exactly the following:\ncmds[CMD_ARRAY_LEN] ="
        exit(1)
    defs = data[data.find('"', pos):data.find(";", pos)]
    outf.write("char cmds[1280] = " + defs + ";\n")
    print defs
    defs = defs.replace('"', "")

    defs = defs.split("\\0")

    i = 0
    for d in defs:
        if d == "":
            continue
        outf.write("#define " + d.upper() + " " + str(i) + "\n")
        i+=1

    pos = data.find("char cmd_lens[NUM_CMDS] =")
    if pos == -1:
        print "Can't find asm definitions in file - must contain exactly the following:\nchar cmd_lens[NUM_CMDS] ="
        exit(1)

    defs = data[data.find('{', pos):data.find(";", pos)]
    defs = defs.replace("}", "")
    defs = defs.replace("{", "")
    defs = defs.split(",")
    
    outf.write("unsigned char CMD_LENS[256] = {")

    for d in defs:
        outf.write(d + ", ")
    
    outf.write("};")

    print "Sucessfully wrote " + str(i) + " definitions to " + sys.argv[2]
    outf.close()

main()