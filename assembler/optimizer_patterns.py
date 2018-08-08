#!/usr/bin/python
from __future__ import print_function
from optimizer import *
A = -1
NO_ARG = arg("")
patterns = [
    #optomize lwi_ for values less than 256 as lbi_
    [ [
        ["lwia", arg.TYPE_LIT, lambda v: (v < 256 and v >= 0)], ],
        lambda c:[cg("lbia", c[0].arg)], ],
    [ [
        ["lwib", arg.TYPE_LIT, lambda v: (v < 256 and v >= 0)], ],
        lambda c:[cg("lbib", c[0].arg)], ],
    #optimize repetitive mdsp as one
    [ [
        ["mdsp", arg.TYPE_LIT, A],
        ["mdsp", arg.TYPE_LIT, A], ],
        lambda c:[cg("mdsp", arg("#" + str(c[0].arg.val + c[1].arg.val) ))], ],
    #uneeded psh and pop
    [ [
        ["psha", A, A],
        ["lbia", A, A],
        ["popb", A, A], ],
        lambda c:[cg("xswp", arg("")), c[1],], ],
    #pointer arithmetic constant multiplication
    [ [
        ["lbia", arg.TYPE_LIT, A],
        ["lbib", arg.TYPE_LIT, A],
        ["amul", A, A] ],
        lambda c:[cg("lwia", arg("#" + str(c[0].arg.val * c[1].arg.val)))] ],
    #optimize one byte mspa
    [ [
        ["mspa", arg.TYPE_LIT, lambda v: (v < 256 and v >= 0)] ],
        lambda c : [cg("bspa", c[0].arg)] ],
]

main(patterns)