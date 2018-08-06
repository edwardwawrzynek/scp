#!/usr/bin/python
from optimizer import *
patterns = [
    [ [ ["lwia", arg.TYPE_ANY, VAL_ANY] ], lambda c:[cg("abcd", arg("#5"))] ],

    [ [ ["nop ", arg.TYPE_ANY, VAL_ANY] ], lambda c:[cg("b", arg(""))] ]
]

main(patterns)