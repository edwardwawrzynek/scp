#!/usr/bin/python
from __future__ import print_function
from optimizer import *
A = -1
NO_ARG = arg("")
patterns = [
    #optimize repetitive mdsp as one
    [ [
        ["mdsp", arg.TYPE_LIT, A],
        ["mdsp", arg.TYPE_LIT, A], ],
        lambda c:[cg("mdsp", arg("#" + str(c[0].arg.val + c[1].arg.val) ))], ],
    #uneeded psh and pop
    [ [
        ["psha", A, A],
        ["lwia,lbia", A, A],
        ["popb", A, A], ],
        lambda c:[cg("xswp", arg("")), c[1],], ],
    [ [
        ["psha", A, A],
        ["mspa,bspa", A, A],
        ["lwpa,lbpa", A, A],
        ["popb", A, A], ],
        lambda c:[cg("xswp", arg("")), cg(c[1].cmd, arg("#" + str(c[1].arg.val-2))), c[2]], ],
    #pointer arithmetic constant multiplication
    [ [
        ["lwia,lbia", arg.TYPE_LIT, A],
        ["lwib,lbib", arg.TYPE_LIT, A],
        ["amul", A, A] ],
        lambda c:[cg("lwia", arg("#" + str(c[0].arg.val * c[1].arg.val)))] ],
    #jumps take logical value, no need to convert
    [ [
        ["aclv", A, A],
        ["jpz ,jpnz", A, A], ],
        lambda c:[c[1]], ],
    #optimize one byte mspa
    [ [
        ["mspa", arg.TYPE_LIT, lambda v: (v < 256 and v >= 0)] ],
        lambda c : [cg("bspa", c[0].arg)] ],
    [ [
        ["bspa", A, A],
        ["lwpa", A, A], ],
        lambda c:[cg("bspl", c[0].arg)] ],
    #one byte mdsp
    [ [
        ["mdsp", arg.TYPE_LIT, lambda v: (v < 256 and v >= 0)] ],
        lambda c: [cg("bdsp", c[0].arg)] ],
    #optomize lwi_ for values less than 256 as lbi_
    [ [
        ["lwia", arg.TYPE_LIT, lambda v: (v < 256 and v >= 0)], ],
        lambda c:[cg("lbia", c[0].arg)], ],
    [ [
        ["lwib", arg.TYPE_LIT, lambda v: (v < 256 and v >= 0)], ],
        lambda c:[cg("lbib", c[0].arg)], ],
    [ [
        ["nop ", A, A], ],
        lambda c:[], ],
]

main(patterns)