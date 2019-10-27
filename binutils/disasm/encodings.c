#include "disasm.h"
/* IMPORTANT: 4 bit opcodes have to be specified as four bit - don't include blank bits for unused */
struct instr_encoding instructions[] = {
  { "nop.n.n", 0b000000, {end_arg},                /* nop.n.n */
    "000000----------" },
  { "mov.r.r", 0b000001, {reg, reg, end_arg},      /* mov.r.r dst src */
    "000000--22221111" },

  { "alu.r.r", 0b0001  , {alu, reg, reg, end_arg}, /* alu.r.r op dst src */
    "0000111133332222" },
  { "alu.r.i", 0b0010  , {alu, reg, cnst, end_arg},/* alu.r.i op dst imd */
    "00001111----2222", 3 },

  { "cmp.r.f", 0b000010, {reg, reg, end_arg},      /* cmp.r.f reg1 reg2 */
    "000000--22221111" },

  { "ld.r.i",  0b001100, {reg, cnst, end_arg},     /* ld.r.i reg imd */
    "000000------1111", 2},

  { "ld.r.m.w", 0b00110100, {reg, label, end_arg},  /* ld.r.m.w reg mem */
    "00000000----1111", 2},
  { "ld.r.m.b", 0b00110110, {reg, label, end_arg},  /* ld.r.m.b reg mem */
    "00000000----1111", 2},
  { "ld.r.m.bs", 0b00110111, {reg, label, end_arg},  /* ld.r.m.bs reg mem */
    "00000000----1111", 2},

  { "ld.r.p.w", 0b00111000, {reg, reg, end_arg},  /* ld.r.pw dst src */
    "0000000022221111"},
  { "ld.r.p.b", 0b00111010, {reg, reg, end_arg},  /* ld.r.p.b dst src */
    "0000000022221111"},
  { "ld.r.p.bs", 0b00111011, {reg, reg, end_arg},  /* ld.r.p.bs dst src*/
    "0000000022221111"},

  { "ld.r.p.off.w", 0b00111100, {reg, reg, cnst, end_arg},  /* ld.r.p.off.w dst src off */
    "0000000022221111", 3},
  { "ld.r.p.off.b", 0b00111110, {reg, reg, cnst, end_arg},  /* ld.r.off.p.b dst src off */
    "0000000022221111", 3},
  { "ld.r.p.off.bs", 0b00111111, {reg, reg, cnst, end_arg},  /* ld.r.p.off.bs dst src off */
    "0000000022221111", 3},

  { "ld.r.ra", 0b000011, {reg, label, end_arg},  /* ld.r.ra dst addr */
    "000000------1111", 2},

  { "st.r.m.w", 0b01000000, {reg, label, end_arg},  /* st.r.m.w reg mem */
    "00000000----1111", 2},
  { "st.r.m.b", 0b01000010, {reg, label, end_arg},  /* st.r.m.b reg mem */
    "00000000----1111", 2},
  { "st.r.m.bs", 0b01000010, {reg, label, end_arg},  /* st.r.m.bs reg mem (alias for st.r.m.b) */
    "00000000----1111", 2},

  { "st.r.p.w", 0b01000100, {reg, reg, end_arg},  /* st.r.p.w src dst */
    "0000000022221111"},
  { "st.r.p.b", 0b01000110, {reg, reg, end_arg},  /* st.r.p.b src dst */
    "0000000022221111"},
  { "st.r.p.bs", 0b01000110, {reg, reg, end_arg},  /* st.r.p.bs src dst (alias for st.r.p.b) */
    "0000000022221111"},

  { "st.r.p.off.w", 0b01001000, {reg, reg, cnst, end_arg},  /* st.r.p.off.w src dst off */
    "0000000022221111", 3},
  { "st.r.p.off.b", 0b01001010, {reg, reg, cnst, end_arg},  /* st.r.p.off.b src dst off */
    "0000000022221111", 3},
  { "st.r.p.off.bs", 0b01001010, {reg, reg, cnst, end_arg},  /* st.r.p.off.bs src dst off (alias for st.r.p.off.bs) */
    "0000000022221111", 3},

  { "jmp.c.j", 0b010011, {cond, label, end_arg}, /* jmp.c.j cond addr */
    "000000-11111----", 2},
  { "jmp.c.r", 0b010100, {cond, reg, end_arg}, /* jmp.c.r cond reg */
    "000000-111112222"},

  { "push.r.sp", 0b010101, {reg, reg, end_arg}, /* push.r.sp reg sp */
    "000000--22221111"},
  { "pop.r.sp", 0b010110, {reg, reg, end_arg}, /* pop.r.sp reg sp */
    "000000--22221111"},

  { "call.j.sp", 0b010111, {reg, label, end_arg}, /* call.j.sp sp addr */
    "000000--1111----", 2},
  { "call.r.sp", 0b011000, {reg, reg, end_arg}, /* call.j.sp reg sp */
    "000000--22221111"},

  { "ret.n.sp", 0b011001, {reg, end_arg}, /* ret.n.sp sp */
    "000000--1111----"},

  { "out.r.p",  0b011010, {reg, cnst, end_arg}, /* out.r.p reg port */
    "000000------1111", 2},
  { "in.r.p",  0b011011, {reg, cnst, end_arg}, /* in.r.p reg port */
    "000000------1111", 2},

  { "int.i.n", 0b011100, {reg, end_arg}, /* int.i.n vector (pass vector as reg) */
    "000000------1111"},

  { "mmu.r.r", 0b011101, {reg, reg, end_arg}, /* mmu.r.r reg1 reg2 */
    "000000--11112222"},

  { "ptb.r.n", 0b011110, {reg, end_arg}, /* ptb.r.n reg */
    "000000------1111"},

  { "reti.ipc.n", 0b011111, {end_arg}, /* reti.ipc.n */
    "000000----------" },

  { "mov.r.ipc", 0b100000, {reg, end_arg}, /* mov.r.ipc reg */
    "000000------1111" },

  { "mov.ipc.r", 0b100001, {reg, end_arg}, /* mov.ipc.r reg */
    "000000------1111" },

  { "hlt.n.n",  0b111111, {end_arg},  /* hlt.n.n */
    "000000----------"},
};

/* alu op names */
char * alu_ops[16] = {"bor", "bxor", "band", "lsh", "ursh", "srsh", "add", "sub", "mul", "bneg", "neg"};