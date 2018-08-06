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

#represents non-optomizable asm
class asm:
    @classmethod
    def fromAsm(cls, asm_v):
        res = asm()
        res.asm = asm_v
        return res

    def __init__(self):
        self.is_cmd = False
        self.asm = ""

    def toAsm(self):
        if self.asm[-1] != '\n':
            return self.asm + '\n'
        return self.asm

#represents a command
class cmd:

    @classmethod
    def fromAsm(cls, asm):
        res = cmd()
        res.asm = asm
        res.parse()
        return res

    #arg is of type arg
    @classmethod
    def fromVal(cls, cmd_n, arg):
        res = cmd()
        res.cmd = cmd_n
        res.arg = arg
        return res

    def __init__(self):
        self.is_cmd = True
        #full asm
        self.asm = ""
        #command name
        self.cmd = ""
        #arg - of arg class
        self.arg = None

    #parse from asm
    def parse(self):
        #remove newlines
        self.asm = self.asm.replace('\n', '')
        #Remove initial tab, if present
        if self.asm[0] == '\t':
            self.asm = self.asm[1:]
        #get command
        self.cmd = self.asm.split('\t')[0]
        #get arg
        self.arg = arg(self.asm.split('\t')[1])

    #return asm, including leading tab and ending newline, from self.cmd and self.arg
    def toAsm(self):
        res = ""
        #create asm representation
        res += '\t'
        res += self.cmd
        res += '\t'
        res += self.arg.arg
        res += '\n'
        return res

#parse a list of asm's and cmd's from a file
def parse_file(f):
    res = []
    for l in f:
        #A cmd or directive
        if l[0] == '\t':
            if l[1] == '.':
                res.append(asm.fromAsm(l))
            else:
                res.append(cmd.fromAsm(l))
        #a label or comment, so asm
        else:
            res.append(asm.fromAsm(l))
    return res

#Main routines
def error(err):
    print err
    exit(1)

def optimize_file(path):
    file = open(path, "r")
    tokens = parse_file(file)
    print len(tokens)

def main():
    if (len(sys.argv)<2):
        error("Usage: scpopt [files.s]")

    #for each file listed, run the optomizer on it
    for f in sys.argv[1:]:
        optimize_file(f)

main()