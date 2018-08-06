#!/usr/bin/python
import sys

#represents a command argument
class arg:
    TYPE_ANY = -1
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
                #adjust for two's complement
                if self.val < 0:
                    self.val = 65536 + self.val
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

#shorthand cmd gen
def cg(cmd_n, arg):
    return cmd.fromVal(cmd_n, arg)

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
        #a label, so asm (ignore comments)
        elif l[0] != ';' and len(l) > 1 and l[1] != ';':
            res.append(asm.fromAsm(l))
    res.append(asm.fromAsm(";\toptomizer end"))
    return res

#output a new asm file from a list of asm's and cmd's
def put_tokens(f, tokens):
    for t in tokens:
        f.write(t.toAsm())

#command matching routines
def VAL_ANY(val):
    return 1

#match a single pattern on a signle token
def match_pat_des(pat, token):
    #if asm, return False
    if not token.is_cmd:
        return False
    #check if name is in comma seperated list
    if not (token.cmd in pat[0].split(',')):
        return False
    #check arg type
    if token.arg.type != pat[1] and pat[1] != arg.TYPE_ANY:
        return False
    #check val
    if not pat[2](token.arg.val):
        return False
    return True

#applies the first match to the tokens
def match_pat(pat, rep, tokens):
    pat_len = len(pat)
    #first index of good matches
    goods = []
    hitGood = True
    for i in range(len(tokens)-pat_len+1):
        #attempt to match this pattern on the sequence starting at tokens[i]
        hitGood = True
        for p in range(pat_len):
            if not match_pat_des(pat[p], tokens[i+p]):
                hitGood = False
                break;
        if hitGood:
            #tokens = tokens[:i] + apply_replace() + tokens[i+p:]
            tokens = tokens[:i] + rep(tokens[i:i+p]) + tokens[i+p+1:]
            return tokens
            #get range to apply

    return False

#applies all the matches of a pat to tokens
def apply_pat(pat, rep, tokens):
    res = match_pat(pat, rep, tokens)
    while res:
        tokens = res
        res = match_pat(pat, rep, tokens)
    return tokens

'''
match pattern format
an array, one entry for each command, specifying how to match that command
[ [ cmd_name , cmd_arg_type(or arg.TYPE_ANY), cmd_arg_val_function(prob. VAL_ANY, or a custom lambda)], ...]
'''

#Main routines
def error(err):
    print err
    exit(1)

def optimize_file(path):
    file = open(path, "r")
    fout = open("output.s", "w")
    tokens = parse_file(file)
    put_tokens(fout, tokens)

def printTokens(t):
    for i in t:
        print i.toAsm()

def main():
    if (len(sys.argv)<2):
        error("Usage: scpopt [files.s]")

    #for each file listed, run the optomizer on it
    for f in sys.argv[1:]:
        optimize_file(f)

    newT = apply_pat([["lwia,lwib", arg.TYPE_LIT, lambda v: v<256], ["nop ", arg.TYPE_ANY, VAL_ANY]], lambda c: [cg("extr", c[0].arg)], [cmd.fromAsm("cmda\t\n"), cmd.fromAsm("lwib\t#255\n"), cmd.fromAsm("nop \t\n"), cmd.fromAsm("lwib\t#2\n"), cmd.fromAsm("nop \t\n")])
    printTokens(newT)
main()