#!/usr/bin/python
import sys

#represents a command argument
class arg:
    TYPE_NONE = 0
    TYPE_LIT = 1
    TYPE_ADDR = 2
    def __init__(self, asm):
        self.arg = asm
        self.type = arg.TYPE_NONE
        self.val = 0
        self.parse_arg()
    def parse_arg(self):
        if len(self.arg) > 0:
            if self.arg[0] == '#':
                self.type = arg.TYPE_LIT
                self.val = int(self.arg[1:])
            else:
                self.type = arg.TYPE_ADDR

#represents a command
class cmd:
    def __init__(self, asm):
        #full asm
        self.asm = asm
        #

#Main routines
def optimize_file(path):
    file = open(path, "r")
    print file.read()

def main():
    if (len(sys.argv)<2):
        print "Usage: scpopt [files.s]"
        exit(1)

    #for each file listed, run the optomizer on it
    for f in sys.argv[1:]:
        optimize_file(f)

main()