typedef enum ArgType {reg, alu, cnst, label} ArgType;

typedef struct Instr {char * name; ArgType types[10]; char * encoding;} Instr;

Instr instructions[] = {
  { "nop.n.n", {},              /* nop.n.n */
      "000000----------" },
  { "mov.r.r", {reg, reg},      /* mov.r.r dst src */
      "000000--22221111" },
  { "alu.r.r", {alu, reg, reg}, /* alu.r.r op dst src */
      "0000111133332222" },
  { "alu.r.i", {alu, reg, cnst},/* alu.r.i op dst imd */
      "00001111----2222 3333333333333333" },
  { "cmp.r.f", {reg, reg},      /* cmp.r.f reg1 reg2 */
      "000000--22221111" }
};