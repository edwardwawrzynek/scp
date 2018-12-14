/* VBCC Backend for Small C Processor
 * In Progress - Doesn't Work Fully
 * Edward Wawrzynek 2018
*/

#include "supp.h"
#include <stdarg.h>

static char FILE_[]=__FILE__;

/* enables debug information */
#define DEBUG
#undef DEBUG

/*  Public data that MUST be there.                             */

/* Name and copyright. */
char cg_copyright[]="VBCC Small C Processor - Edward Wawrzynek 2018\nBackend is Unfinished and Experimental";

/*  Commandline-flags the code-generator accepts:
    0: just a flag
    VALFLAG: a value must be specified
    STRINGFLAG: a string can be specified
    FUNCFLAG: a function will be called
    apart from FUNCFLAG, all other versions can only be specified once */
int g_flags[MAXGF]={};

/* the flag-name, do not use names beginning with l, L, I, D or U, because
   they collide with the frontend */
char *g_flags_name[MAXGF]={};

/* the results of parsing the command-line-flags will be stored here */
union ppi g_flags_val[MAXGF];

/*  Alignment-requirements for all types in bytes.              */
zmax align[MAX_TYPE+1];

/*  Alignment that is sufficient for every object. (2) */
zmax maxalign;

/*  CHAR_BIT for the target machine. (8) */
zmax char_bit;

/* stack alignment (2) */
zmax stackalign;

/*  sizes of the basic types (in bytes) */
zmax sizetab[MAX_TYPE+1];

/*  Minimum and Maximum values each type can have.              */
/*  Must be initialized in init_cg().                           */
zmax t_min[MAX_TYPE+1];
zumax t_max[MAX_TYPE+1];
zumax tu_max[MAX_TYPE+1];

/*  Names of all registers. will be initialized in init_cg(),
    register number 0 is invalid, valid registers start at 1 */
char *regnames[MAXR+1];

/*  The Size of each register in bytes.                         */
zmax regsize[MAXR+1];

/*  a type which can store each register. (all ints) */
struct Typ *regtype[MAXR+1];

/*  regsa[reg]!=0 if a certain register is allocated and should */
/*  not be used by the compiler pass.                           */
int regsa[MAXR+1];

/*  Specifies which registers may be scratched by functions.    */
int regscratch[MAXR+1];

/* specifies the priority for the register-allocator, if the same
   estimated cost-saving can be obtained by several registers, the
   one with the highest priority will be used */
int reg_prio[MAXR+1];

/****************************************/
/*  Private data and functions.         */
/****************************************/

/** Sizes and alignment:
 * typename   | size  | aligment
 * char       | 1     | 1
 * short      | 2     | 2
 * int        | 2     | 2
 * long       | 4     | 2
 * long long  | 0(n/a)| 1(n/a)
 * float      | 4     | 2
 * double     | 4     | 2
 * long double| 4     | 2
 * void       | 0(n/a)| 1(n/a)
 * pointer    | 2     | 2
 * array      | 0(n/a)| 1(n/a)
 * struct     | 0(n/a)| 1(n/a)
 * union      | 0(n/a)| 1(n/a)
 * enum       | 2     | 2
 * funkt      | 0(n/a)| 1
 * NOTE: doubles are the same as floats (technical standard compliance) */

/* alignment of basic data-types, used to initialize align[] */
static long malign[MAX_TYPE+1]=  {1,1,2,2,2,1,2,2,2,1,2,1,1,1,2,1};
/* sizes of basic data-types, used to initialize sizetab[] */
static long msizetab[MAX_TYPE+1]={0,1,2,2,4,0,4,4,4,0,2,0,0,0,2,0};

/* used to initialize regtyp[] */
static struct Typ ityp={INT};

/* macros defined by the backend */
static char *marray[]={
		       "__SCP__",
		       0};

/* special registers */
static int sp, fp; /* stack and frame pointer */
static int tmp1, tmp2, tmp1_h, tmp2_h; /* temporary registers */
static int ret_reg;

/* print debug information if DEBUG is enables, else do nothing */
#ifdef DEBUG
  void debug(const char *format, ...){
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
}
#endif
#ifndef DEBUG
  static inline void debug(const char * format, ...){}
#endif

/* debugging routines */

/* print out a variable (val if drom an obj) */
void debug_var(struct Var *v, zmax val){
  debug("\tvar: %s\n", v->identifier);
  if(isauto(v->storage_class)){
    debug("\t\tauto %s: local offset %i, offset: %i\n", v->offset > 0 ? "local" : "argument", v->offset, val);
  }
  if(isextern(v->storage_class)){
    debug("\t\textern _%s + %i\n", v->identifier, val);
  }
  if(isstatic(v->storage_class)){
    debug("\t\tstatic l%u + %i\n", v->offset, val);
  }
}

/* print out an object */
void debug_obj(struct obj *o){
  if(o->flags == 0){
    debug("no obj\n");
    return;
  }
  debug("obj of type: ");
  if(o->flags & KONST){
    debug("KONST ");
  }
  if(o->flags & VAR){
    debug("VAR ");
  }
  if(o->flags & DREFOBJ){
    debug("DREFOBJ ");
  }
  if(o->flags & REG){
    debug("REG ");
  }
  if(o->flags & VARADR){
    debug("VARADR ");
  }
  debug("\n");
  if(o->flags & DREFOBJ){
    debug("\tdereference of:\n");
  }
  if(o->flags & REG){
    debug("\tin register %s\n", regnames[o->reg]);
  }
  if(o->flags & VARADR){
    debug("\taddress of:\n");
  }
  if(o->flags & KONST){
    debug("\tconstant: %i\n", o->val.vmax);
  } else if(!(o->flags & REG)){
    debug_var(o->v, o->val.vmax);
  }
}

/* assembly-prefixes for labels and external identifiers */
static char *labprefix="l",*idprefix="_";

/* stack layout:
   ------------------------------------------------
   | arguments to this function                   |
   ------------------------------------------------
   | return-address [size=2]                      |
   ------------------------------------------------
   | push'd regs from prologue [size=pushsize]    |
   ------------------------------------------------
   | local variables [size=localsize]             |
   ------------------------------------------------
   | other push'd stuff [size=stackoffset]        |
   ------------------------------------------------
*/
/* size of locals (in bytes) */
static long localsize;
/* size of regs pushed (in bytes) */
static long pushsize;
/* size of otherthings pushed (for any other reason) */
static long stackoffset;

/* get the real offset from the stack pointer for a variable on the stack */
/* off is negative if the object is a function argument, positive for locals */
static long real_stack_offset(struct obj *o)
{
  long off=zm2l(o->v->offset);
  if(off<0){
    /* function parameter */
    off=localsize + pushsize + 2 - off -zm2l(maxalign);
  }
  /* we don't have to do anything special for locals */

  /* add offset added by stackoffset */
  off += stackoffset;

  /* add offset in object (structs, etc) */
  off+=zm2l(o->val.vmax);

  return off;
}

/* generates the function entry code, and reset pushsize and stackoffset */
static void function_top(FILE *f,struct Var *v,long offset)
{
  /* put in text section */
  emit(f, "\t.text\n");
  if(v->storage_class==EXTERN){
    emit(f,"%s%s:\n",idprefix,v->identifier);
    if((v->flags&(INLINEFUNC|INLINEEXT))!=INLINEFUNC){
      emit(f,"\t.global\t%s%s\n",idprefix,v->identifier);
    }
  }else{
    emit(f,"%s%ld:\n",labprefix,zm2l(v->offset));
  }
  pushsize = 0;
  stackoffset = 0;
}

/* generates the function exit code */
static void function_bottom(FILE *f,struct Var *v,long offset)
{
  emit(f,"\tret.n.sp sp\n");
}

/* push/pop a register (effects stackoffset) */
static void push_reg(FILE *f, int reg){
  stackoffset += 2;
  emit(f, "\tpush.r.sp %s sp\n", regnames[reg]);
}
static void pop_reg(FILE *f, int reg){
  stackoffset -= 2;
  emit(f, "\tpop.r.sp %s sp\n", regnames[reg]);
}

/* push/pop a reg in function prolouge and epilouge, effecting pushsize */
static void pushsize_push_reg(FILE *f, int reg){
  pushsize += 2;
  emit(f, "\tpush.r.sp %s sp\n", regnames[reg]);
}

static void pushsize_pop_reg(FILE *f, int reg){
  pushsize -= 2;
  emit(f, "\tpop.r.sp %s sp\n", regnames[reg]);
}

/* make room for locals, and set localsize */
static void make_locals(FILE *f, long size){
  localsize = size;
  /* only emit sub if we need to make space */
  if(size){
    emit(f, "\talu.r.i sub sp %i\n", size);
  }

}

/* modify the stack pointer */
static void mod_stack(FILE *f, long change){
  stackoffset -= change;
  if(change){
    emit(f, "\talu.r.i add sp %i\n", change);
  }
}

/* remove room made for locals and stackoffset */
static void remove_locals_and_stack(FILE *f){
  int s = stackoffset + localsize;
  /* only emit add if we need to */
  if(s){
    emit(f, "\talu.r.i add sp %i\n", s);
  }
  stackoffset = 0;
  localsize = 0;
}

/* loading and storing routines */

/* names of types used in some (.dc, etc) encodings */
#define dt(t) (((t)&UNSIGNED)?udt[(t)&NQ]:sdt[(t)&NQ])
static char *sdt[MAX_TYPE+1]={"??","bs","w","w","l","-","l","l","l","-","w"};
static char *udt[MAX_TYPE+1]={"??","b","w","w","l","-","l","l","l","-","w"};

#define isreg(x) ((p->x.flags&(REG|DREFOBJ))==REG)
#define isconst(x) ((p->x.flags&(KONST|DREFOBJ))==KONST)

/**
 * load an object into a register
 * doesn't use any other registers
 * f is the file output stream
 * o is the object
 * real_type is the type (from q1typ, q2typ, or ztyp) of the object
 * reg is the reg to load into */
static void load_into_reg(FILE *f, struct obj *o, int real_type, int reg){

  /* clear all but unsigned from type */
  real_type &= NU;

  int typ = real_type;

  /* if it is a dereference, load it as a pointer */
  if(o->flags & DREFOBJ){
    typ = POINTER;
  }

  /* make sure we have something to load */
  if(!o->flags){
    ierror(0);
  }

  /* load into reg, then apply drefobj if nessesary */
  /* TODO: add special case with REG|DREFOBJ - doesn't need the move before hand, we can just use old reg as source */
  if(o->flags & REG){
    if(o->reg != reg){
      emit(f, "\tmov.r.r %s %s\n", regnames[reg], regnames[o->reg]);
    }
  } else if (o->flags & KONST){
    emit(f, "\tld.r.i %s %i\n", regnames[reg], o->val.vmax);
  } else if (o->flags & VAR){
    /* check if we are loading address of a var */
    if(o->flags & VARADR){
      /* should only be used with static or external variables */
      if(isextern(o->v->storage_class)){
        emit(f, "\tld.r.ra %s %s%s+%i\n", regnames[reg], idprefix, o->v->identifier, o->val.vmax);
      }
      if(isstatic(o->v->storage_class)){
        emit(f, "\tld.r.ra %s %s%i+%i\n", regnames[reg], labprefix, o->v->offset, o->val.vmax);
        }
    } else {
      /* handle externs and static */
      if(isextern(o->v->storage_class)){
        emit(f, "\tld.r.m.%s %s %s%s+%i\n", dt(typ), regnames[reg], idprefix, o->v->identifier, o->val.vmax);
      }
      if(isstatic(o->v->storage_class)){
        emit(f, "\tld.r.m.%s %s %s%i+%i\n", dt(typ), regnames[reg], labprefix, o->v->offset, o->val.vmax);
      }
      /* handle automatic variables */
      if(isauto(o->v->storage_class)){
        /* get offset */
        long off = real_stack_offset(o);
        /* emit with an offset if we need to */
        if(off){
          emit(f, "\tld.r.p.off.%s %s sp %i\n", dt(typ), regnames[reg], off);
        } else {
          emit(f, "\tld.r.p.%s %s sp\n", dt(typ), regnames[reg]);
        }
      }
    }
  }
  /* apply drefobj */
  if (o->flags & DREFOBJ){
    /* use a pointer object */
    emit(f, "\tld.r.p.%s %s %s\n", dt(real_type), regnames[reg], regnames[reg]);
  }
}

/**
 * load the address of an object into a register
 * doesn't use any other registers
 * f is the file output stream
 * o is the object
 * real_type is the type (from q1typ, q2typ, or ztyp) of the object (not used)
 * reg is the reg to load the address into */
static void load_address(FILE *f, struct obj *o, int real_type, int reg){

  /* type doesn't matter, as we are loading an address (always a pointer) */

  /* if the object is a derefrence, we can just load it without the derefrence */
  if(o->flags & DREFOBJ){
    /* clear DREFOBJ */
    o->flags &= ~0b100000;
    load_into_reg(f, o, POINTER, reg);
  } else if (o->flags & KONST){
    /* can't take addr of a constant */
    ierror(0);
  } else if (o->flags & VARADR){
    /* can't take address of address */
    ierror(0);
  } else if (o->flags & VAR){
    /* we have to take the address of a non derefrenced, non VARADR variable */
    /* handle externs and static */
      if(isextern(o->v->storage_class)){
        emit(f, "\tld.r.ra %s %s%s+%i\n", regnames[reg], idprefix, o->v->identifier, o->val.vmax);
      }
      if(isstatic(o->v->storage_class)){
        emit(f, "\tld.r.ra %s %s%i+%i\n", regnames[reg], labprefix, o->v->offset, o->val.vmax);
      }
      /* handle automatic variables */
      if(isauto(o->v->storage_class)){
        /* get offset */
        long off = real_stack_offset(o);
        /* move sp to reg and odd offset */
        emit(f, "\tmov.r.r %s sp\n", regnames[reg]);
        if(off){
          emit(f, "\talu.r.i add %s %i\n", regnames[reg], off);
        }
      }

  } else {
    /* can't load address of whatever this is */
    ierror(0);
  }
}

/**
 * store the value in a register into an object
 * f is the file output stream
 * o is the object
 * real_type is the type (from q1typ, q2typ, or ztyp) of the object
 * reg is the reg to load into
 * tmp is a reg that can be used as a temporary */
static void store_from_reg(FILE *f, struct obj *o, int real_type, int reg, int tmp){
  /* clear all but unsigned from type */
  real_type &= NU;
  int typ = real_type;
  /* handle cases that can be made more efficient */
  if((o->flags & REG) && !(o->flags & DREFOBJ)){
    /* move regs if they are different */
    if(reg != o->reg){
      emit(f, "\tmov.r.r %s %s\n", regnames[o->reg], regnames[reg]);
    }

  } else if(((o->flags & VAR) == VAR)){
    if(isextern(o->v->storage_class)){
      emit(f, "\tst.r.m.%s %s %s%s+%i\n", dt(typ), regnames[reg], idprefix, o->v->identifier, o->val.vmax);
    }
    if(isstatic(o->v->storage_class)){
      emit(f, "\tst.r.m.%s %s %s%i+%i\n", dt(typ), regnames[reg], labprefix, o->v->offset, o->val.vmax);
    }
    /* handle automatic variables */
    if(isauto(o->v->storage_class)){
      /* get offset */
      long off = real_stack_offset(o);
      /* emit with an offset if we need to */
      if(off){
        emit(f, "\tst.r.p.off.%s %s sp %i\n", dt(typ), regnames[reg], off);
      } else {
        emit(f, "\tst.r.p.%s %s sp\n", dt(typ), regnames[reg]);
      }
    }
  } else {
    /* load address into tmp, and store value in reg at address pointed to be tmp */
    load_address(f, o, typ, tmp);
    emit(f, "\tst.r.p.%s %s %s\n", dt(typ), regnames[reg], regnames[tmp]);
  }
}

/**
 * given an object, see if we can load/store it from a reg
 * o is the object
 * real_type is the type of the object (not used)
 * tmp is a temporary reg that can be used as the source
 * returns the reg to put the result into */
static int source_reg(FILE *f, struct obj *o, int real_type, int tmp){
  /* if the source is a reg (not drefrenced), target that */
  if(o->flags & REG && !(o->flags & DREFOBJ)){
    return o->reg;
  }
  /* otherwise, put in tmp */
  else{
    return tmp;
  }
}

/**
 * given a source object, (and the destination object (only used for picking reg)),
 * see if we can load the source into a reg that if efficient, or return the tmp reg
 * src is the object being loaded
 * dst is the object being loaded into (just used for reg - doesn't actual load into it)
 * real_type is the type of the object (not used)
 * tmp is a temporary reg that can be used as the source
 * returns the reg to put the result into */
static int find_reg_to_load(FILE *f, struct obj *src, struct obj *dst, int real_type, int tmp){
  /* if the destination is a reg, load to that */
  if(dst->flags & REG && !(dst->flags & DREFOBJ)){
    return dst->reg;
  }
  /* if the object is in a reg, keep it there */
  if(src->flags & REG && !(src->flags & DREFOBJ)){
    return src->reg;
  }
  /* otherwise, put in tmp */
  else{
    return tmp;
  }
}

/**
 * load an object into a reg, and return that register (combination of source_reg and load_into_reg)
 * if the object is already in a reg, use that, else load it into a tmp
 * o is the object
 * real_type is the type
 * tmp is a temporary reg that can be used
 * returns reg that it was loaded into */
static int load_obj(FILE *f, struct obj *o, int real_type, int tmp){
  int reg = source_reg(f, o, real_type, tmp);
  load_into_reg(f, o, real_type, reg);

  return reg;
}

/**
 * return 1 if an arithmetic instruction is single operand, 0 otherwise */
static int is_single_operand(int code){
  switch(code){
    case MINUS:
    case KOMPLEMENT:
      return 1;
    default:
      return 0;
  }
}

/**
 * handle an arithmetic instruction
 * called from arithmetic */
static void do_arithmetic(FILE *f, struct obj * q1, struct obj * q2, struct obj * z, int op, int q1type, int q2type, int ztype){
  /* source regs (reg1 will also be target) */
  int reg1, reg2;
  /* if true, q2 is konst, so use alu.r.i instead of alu.r.r */
  int q2_konst = 0;
  /* if there is only a single operand, and we can ignore the second */
  int single_op = is_single_operand(op);

  if((q2->flags & KONST) == KONST){
    q2_konst = 1;
  }
  /* get reg1 and reg2, loading them into tmp1 and tmp2 if needed
    try to load reg1 into z reg if we can*/
  reg1 = source_reg(f, z, ztype, tmp1);
  if(!single_op){
    reg2 = source_reg(f, q2, q2type, tmp2);
  }

  /* load args */
  load_into_reg(f, q1, q1type, reg1);
  if((!q2_konst) && (!single_op)){
    load_into_reg(f, q2, q2type, reg2);
  }

  /* emit start of alu instruction */
  if(q2_konst){
    emit(f, "\talu.r.i ");
  } else {
    emit(f, "\talu.r.r ");
  }
  /* emit alu name for each operation */
  switch(op){
    case OR:
      debug("OR\n");
      emit(f, "bor");
      break;
    case XOR:
      debug("XOR\n");
      emit(f, "bxor");
      break;
    case AND:
      debug("AND\n");
      emit(f, "band");
      break;
    case LSHIFT:
      debug("LSHIFT\n");
      emit(f, "lsh");
      break;
    case RSHIFT:
      /* we need to check if it is a signed or unsigned shift */
      debug("RSHIFT\n");
      if(q1type & UNSIGNED){
        emit(f, "ursh");
      } else {
        emit(f, "srsh");
      }
      break;
    case ADD:
      debug("ADD\n");
      emit(f, "add");
      break;
    case SUB:
      debug("SUB\n");
      emit(f, "sub");
      break;
    case MULT:
      debug("MULT\n");
      emit(f, "mul");
      break;
    case DIV:
      debug("DIV\n");
      /* not implemented */
      /* needs to check sign */
      printf("DIV not implemented\n");
      ierror(0);
      break;
    case MOD:
      debug("MOD\n");
      /* not implemented */
      /* needs to check sign */
      printf("MOD not implemented\n");
      ierror(0);
      break;
    case KOMPLEMENT:
      debug("KOMPLEMENT\n");
      emit(f, "bneg");
      break;
    case MINUS:
      debug("MINUS\n");
      emit(f, "neg");
      break;
  }
  /* finish alu instruction */
  if(!q2_konst){
    if(single_op){
      /* use tmp1 as second arg - it doesn't matter anyway */
      emit(f, " %s %s\n", regnames[reg1], regnames[tmp1]);
    } else {
      emit(f, " %s %s\n", regnames[reg1], regnames[reg2]);
    }
  } else {
    emit(f, " %s %i\n", regnames[reg1], q2->val.vmax);
  }
  /* store result, using tmp2 if needed (result may be in tmp1) */
  store_from_reg(f, z, ztype, reg1, tmp2);
}

static void arithmetic(FILE *f, struct IC *p){
  do_arithmetic(f, &(p->q1), &(p->q2), &(p->z), p->code, q1typ(p), q2typ(p), ztyp(p));
}



/* signed-ness of last comparison (1=signed, 0=unsigned) */
static int compare_signed = 1;

/* handle a compare instruction */
static void compare(FILE *f, struct IC *p){
  /* load both args */
  int reg1 = load_obj(f, &(p->q1), q1typ(p), tmp1);
  int reg2 = load_obj(f, &(p->q2), q2typ(p), tmp2);
  emit(f, "\tcmp.r.f %s %s\n", regnames[reg1], regnames[reg2]);
  /* set sign */
  if((q1typ(p)&UNSIGNED) || (q2typ(p)&UNSIGNED)){
    compare_signed = 0;
  } else {
    compare_signed = 1;
  }
}

/* handle a test instruction (same as comparing to 0) */
static void test(FILE *f, struct IC *p){
  /* load arg */
  int reg1 = load_obj(f, &(p->q1), q1typ(p), tmp1);
  int reg2 = tmp2;
  /* load 0 into tmp2 */
  emit(f, "\tld.r.i %s %i\n", regnames[tmp2], 0);
  /* compare */
  emit(f, "\tcmp.r.f %s %s\n", regnames[reg1], regnames[reg2]);
  /* set sign */
  if((q1typ(p)&UNSIGNED)){
    compare_signed = 0;
  } else {
    compare_signed = 1;
  }

}

/* handle a branch instruction */
static void branch(FILE *f, struct IC *p){
  /* emit start */
  emit(f, "\tjmp.c.j ");
  /* emit proper condition code */
  switch(p->code){
    case BEQ:
      debug("BEQ\n");
      /* signedness doesn't matter */
      emit(f, "e");
      break;
    case BNE:
      debug("BNE\n");
      /* signedness doesn't matter */
      emit(f, "GLgl");
      break;
    case BLT:
      debug("BLT\n");
      if(compare_signed){
        emit(f, "L");
      } else {
        emit(f, "l");
      }
      break;
    case BGE:
      debug("BGE\n");
      if(compare_signed){
        emit(f, "Ge");
      } else {
        emit(f, "ge");
      }
      break;
    case BLE:
      debug("BLE\n");
      if(compare_signed){
        emit(f, "Le");
      } else {
        emit(f, "le");
      }
      break;
    case BGT:
      debug("BGT\n");
      if(compare_signed){
        emit(f, "G");
      } else {
        emit(f, "g");
      }
      break;
    case BRA:
      debug("BRA\n");
      /* signedness doesn't matter */
      emit(f, "LGlge");
      break;
  }
  emit(f, " %s%i\n", labprefix, p->typf);
}

/****************************************/
/*  End of private data and functions.  */
/****************************************/

/*  Does necessary initializations for the code-generator. Gets called  */
/*  once at the beginning and should return 0 in case of problems.      */
int init_cg(void)
{
  int i;
  /*  Initialize some values which cannot be statically initialized   */
  /*  because they are stored in the target's arithmetic.             */
  maxalign=l2zm(2L);
  char_bit=l2zm(8L);
  stackalign=l2zm(2L);

  /* create sizetab and align */
  for(i=0;i<=MAX_TYPE;i++){
    sizetab[i]=l2zm(msizetab[i]);
    align[i]=l2zm(malign[i]);
  }

  /*  Reserve a few registers for use by the code-generator (these variables are just placeholders for easy access in backend)     */
  /*  This is not optimal but simple.  */
  /* they are their reg number +1 so we can call regnames[sp], etc */
  sp=0xf + 1;
  tmp1=0xa + 1;
  tmp1_h=0xb + 1;
  tmp2=0xc + 1;
  tmp2_h=0xd + 1;
  ret_reg=0xe + 1;

  /* init registers */
  regnames[0] = "noreg"; /* na */
  regscratch[0] = 0;
  regsa[0] = 1;

  /* non scratch registers usable by vbcc */
  regnames[1] = "r0";
  regscratch[1] = 0;
  regsa[1] = 0;

  regnames[2] = "r1";
  regscratch[2] = 0;
  regsa[2] = 0;

  regnames[3] = "r2";
  regscratch[3] = 0;
  regsa[3] = 0;

  regnames[4] = "r3";
  regscratch[4] = 0;
  regsa[4] = 0;

  /* scratch registers usable by vbcc */
  regnames[5] = "r4";
  regscratch[5] = 1;
  regsa[5] = 0;

  regnames[6] = "r5";
  regscratch[6] = 1;
  regsa[6] = 0;

  regnames[7] = "r6";
  regscratch[7] = 1;
  regsa[7] = 0;

  regnames[8] = "r7";
  regscratch[8] = 1;
  regsa[8] = 0;

  regnames[9] = "r8";
  regscratch[9] = 1;
  regsa[9] = 0;

  regnames[10] = "r9";
  regscratch[10] = 1;
  regsa[10] = 0;

  /* backend temp 1 extended reg */
  regnames[11] = "ra";
  regscratch[11] = 0;
  regsa[11] = 1;

  regnames[12] = "rb";
  regscratch[12] = 0;
  regsa[12] = 1;

  /* backend temp 2 extended reg */
  regnames[13] = "rc";
  regscratch[13] = 0;
  regsa[13] = 1;

  regnames[14] = "rd";
  regscratch[14] = 0;
  regsa[14] = 1;

  /* Return Register (32 bits returned as pointer) */
  regnames[15] = "re";
  regscratch[15] = 0;
  regsa[15] = 1;

  /* Stack Pointer */
  regnames[16] = "sp";
  regscratch[16] = 0;
  regsa[16] = 1;

  /* all regs are 2 bytes, and can be stored as an int */
  for(i = 1; i < 17; i++){
    regsize[i] = l2zm(2L);
    regtype[i] = &ityp;
  }

  /* isa is completely orthagonal, so no need to set reg_prio */

  /*  Don't use multiple ccs.   */
  multiple_ccs=0;

  /*  Initialize the min/max-settings. Note that the types of the     */
  /*  host system may be different from the target system and you may */
  /*  only use the smallest maximum values ANSI guarantees if you     */
  /*  want to be portable.                                            */
  /*  That's the reason for the subtraction in t_min[INT]. Long could */
  /*  be unable to represent -2147483648 on the host system.          */
  /*t_min[UNSIGNED|CHAR]=t_min[UNSIGNED|SHORT]=t_min[UNSIGNED|INT]=t_min[UNSIGNED|LONG]=l2zm(0L);
  t_min[CHAR]=l2zm(-128L);
  t_min[SHORT]=l2zm(-32768L);
  t_min[INT]=l2zm(-32768L);
  t_min[LONG]=zmsub(l2zm(-2147483647L),l2zm(1L));
  t_min[LLONG]=0;
  t_min[MAXINT]=t_min(LONG);

  t_max[CHAR]=ul2zum(127L);
  t_max[SHORT]=ul2zum(32767UL);
  t_max[INT]=ul2zum(32767UL);
  t_max[LONG]=ul2zum(2147483647UL);
  t_max[LLONG]=0;
  t_max[MAXINT]=t_max(LONG);

  tu_max[CHAR]=ul2zum(255UL);
  tu_max[SHORT]=ul2zum(65535UL);
  tu_max[INT]=ul2zum(65535UL);
  tu_max[LONG]=ul2zum(4294967295UL);
  tu_max[LLONG]=0;
  tu_max[MAXINT]=t_max(UNSIGNED|LONG);

  t_max[UNSIGNED|CHAR]=ul2zum(255UL);
  t_max[UNSIGNED|SHORT]=ul2zum(65535UL);
  t_max[UNSIGNED|INT]=t_max[UNSIGNED|SHORT];
  t_max[UNSIGNED|LONG]=ul2zum(4294967295UL);*/

  t_min[CHAR]=l2zm(-128L);
  t_min[SHORT]=l2zm(-32768L);
  t_min[INT]=t_min(SHORT);
  t_min[LONG]=zmsub(l2zm(-2147483647L),l2zm(1L));
  t_min[LLONG]=t_min(LONG);
  t_min[MAXINT]=t_min(LONG);

  t_max[CHAR]=ul2zum(127L);
  t_max[SHORT]=ul2zum(32767UL);
  t_max[INT]=t_max(SHORT);
  t_max[LONG]=ul2zum(2147483647UL);
  t_max[LLONG]=t_max(LONG);
  t_max[MAXINT]=t_max(LONG);

  tu_max[CHAR]=ul2zum(255UL);
  tu_max[SHORT]=ul2zum(65535UL);
  tu_max[INT]=t_max(UNSIGNED|SHORT);
  tu_max[LONG]=ul2zum(4294967295UL);
  tu_max[LLONG]=t_max(UNSIGNED|LONG);
  tu_max[MAXINT]=t_max(UNSIGNED|LONG);


  target_macros=marray;


  return 1;
}

int freturn(struct Typ *t)
/*  Returns the register in which variables of type t are returned. */
/*  If the value cannot be returned in a register returns 0.        */
/*  A pointer MUST be returned in a register. The code-generator    */
/*  has to simulate a pseudo register if necessary.                 */
{
  /* floats and 32 bits are returned using the implicit pointer argument system */
  if(ISFLOAT(t->flags)){
    return 0;
  }
  if(ISSTRUCT(t->flags)||ISUNION(t->flags))
    return 0;
  /* return everything less than or equal to two bytes in ret_reg */
  if(zmleq(szof(t),l2zm(2L))){
      return ret_reg;
  }
  /* make sure pointers are returned in ret_reg (they should be anyway, as they are <= 2 bytes) */
  if(ISPOINTER(t->flags)){
    return ret_reg;
  }

  return 0;
}

int reg_pair(int r,struct rpair *p)
/* Returns 0 if the register is no register pair. If r  */
/* is a register pair non-zero will be returned and the */
/* structure pointed to p will be filled with the two   */
/* elements.                                            */
{
  return 0;
}

int regok(int r,int t,int mode)
/*  Returns 0 if register r cannot store variables of   */
/*  type t. If t==POINTER and mode!=0 then it returns   */
/*  non-zero only if the register can store a pointer   */
/*  and dereference a pointer to mode.                  */
{
  /* don't do anything with noreg */
  if(r==0){
    return 0;
  }
  t&=NQ;
  /* we can store two byte or less ints in any reg */
  if(t>=CHAR && t <= INT){
    return 1;
  }
  /* we can store pointers in any reg */
  if(ISPOINTER(t)){
    return 1;
  }
  /* TODO: implement extended regs to allow storing 32 bit values in regs */
  if(ISFLOAT(t)){
    return 0;
  }
  return 0;
}

int dangerous_IC(struct IC *p)
/*  Returns zero if the IC p can be safely executed     */
/*  without danger of exceptions or similar things.     */
/*  vbcc may generate code in which non-dangerous ICs   */
/*  are sometimes executed although control-flow may    */
/*  never reach them (mainly when moving computations   */
/*  out of loops).                                      */
/*  Typical ICs that generate exceptions on some        */
/*  machines are:                                       */
/*      - accesses via pointers                         */
/*      - division/modulo                               */
/*      - overflow on signed integer/floats             */
{
  /* scp doesn't have exceptions (yet) */
  return 0;
}

int must_convert(int o,int t,int const_expr)
/*  Returns zero if code for converting np to type t    */
/*  can be omitted.                                     */
/*  On the PowerPC cpu pointers and 32bit               */
/*  integers have the same representation and can use   */
/*  the same registers.                                 */
{
  int op=o&NQ,tp=t&NQ;
  /* ints and pointers are both 2 bytes */
  /* We need converts from chars to ints, or else char loads may try to load wors from memory */
  if((op==INT||op==SHORT||op==POINTER)&&(tp==INT||tp==SHORT||tp==POINTER)){
    return 0;
  }
  /* all floats have the same representation */
  if(ISFLOAT(op)&&ISFLOAT(tp)) return 0;

  return 1;
}

int shortcut(int code,int typ)
{
  return 0;
}

void gen_ds(FILE *f,zmax size,struct Typ *t)
/*  This function has to create <size> bytes of storage */
/*  initialized with zero.                              */
{
  emit(f, "\t.ds\t%ld\n", zm2l(size));
}

void gen_align(FILE *f,zmax align)
/*  This function has to make sure the next data is     */
/*  aligned to multiples of <align> bytes.              */
{
  /* TODO: allow alignments more than two bytes (not needed by backend - does frontend need it?) */
  if(zm2l(align)==2) emit(f,"\t.align\n");
  if(zm2l(align)>2) printf("Can't generate align more than two bytes\n");
}

void gen_var_head(FILE *f,struct Var *v)
/*  This function has to create the head of a variable  */
/*  definition, i.e. the label and information for      */
/*  linkage etc.                                        */
{
  int constflag = 0;
  if(v->clist){
    constflag=is_const(v->vtyp);
  }
  /* blank space to make clear new variables */
  emit(f, "\n");
  /* emit section information */
  if((v->clist&&(!constflag))){
    emit(f, "\t.data\n");
  }
  if((v->clist) && constflag){
    emit(f, "\t.rodata\n");
  }
  if(!(v->clist) && (!constflag)){
    emit(f, "\t.bss\n");
  }
  if(!(v->clist) && constflag){
    /* read only bss (just goes in .rodata - let the assembler figure that one out) */
    emit(f, "\t.robss\n");
  }

  if(v->storage_class == STATIC){
    if(ISFUNC(v->vtyp->flags)) return;
    emit(f,"%s%ld:\n",labprefix,zm2l(v->offset));
    gen_align(f,falign(v->vtyp));
  }
  if(v->storage_class == EXTERN){
    /* We only want to emit records for genuinely defined variables. For
	   * some reason, TENTATIVE is defined for some of this */
    if(v->flags&(DEFINED|TENTATIVE)){
      emit(f,"%s%s:\n",idprefix,v->identifier);
      emit(f, "\t.global\t%s%s\n", idprefix, v->identifier);
      gen_align(f,falign(v->vtyp));
    } else{
      /* this seems to be extern variables */
      emit(f, "\t.extern\t%s%s\n", idprefix, v->identifier);
    }
  }

}

void gen_dc(FILE *f,int t,struct const_list *p)
/*  This function has to create static storage          */
/*  initialized with const-list p.                      */
{
  emit(f,"\t.dc.%s\t",dt(t&NQ));
  if(!p->tree){
    if(ISFLOAT(t)){
      /*  emit single precision IEEE format (same as host, very hacky)
        TODO: make sure this is properly emitted for doubles (same as floats on target, but not host) */
      unsigned char *ip;
      ip=(unsigned char *)&p->val.vdouble;
      emit(f,"0x%02x%02x%02x%02x",ip[0],ip[1],ip[2],ip[3]);
    }else{
      emitval(f,&p->val,t&NU);
    }
  }else{
    /* TODO: what does this mean ? */
    /* emit_obj(f,&p->tree->o,t&NU); */
    printf("Need to implement proper print_obj\n");
  }
  emit(f,"\n");
}


/*  The main code-generation routine.                   */
/*  f is the stream the code should be written to.      */
/*  p is a pointer to a doubly linked list of ICs       */
/*  containing the function body to generate code for.  */
/*  v is a pointer to the function.                     */
/*  offset is the size of the stackframe the function   */
/*  needs for local variables.                          */

void gen_code(FILE *f,struct IC *p,struct Var *v,zmax offset)
/*  The main code-generation.                                           */
{
  /* which registers are to be pushed in prolouge and poped in epilouge */
  int regspushed[MAXR+1];
  memset(regspushed, 0, (MAXR+1)*sizeof(int));
  /* general reg variables */
  int reg1, reg2;

  debug("gen_code()\n");

  /* emit function label (resets stackoffset and push size) */
  function_top(f, v, offset);

  /* vbcc marks the regs that a function used that needs to be pushed in regused - push these */
  for(int i = 1; i < MAXR+1; i++){
    if(regused[i]){
      regspushed[i] = 1;

      /* check that the reg is actually used in the code somewhere other than a ALLOCREG or FREEREG */
      struct IC *ps = p;
      char used = 0;
      for(;ps;ps=ps->next){
        if(ps->code != ALLOCREG && ps->code != FREEREG){
          if(ps->q1.reg == i || ps->q2.reg == i || ps->z.reg == i){
            used = 1;
            break;
          }
        }
      }

      if(!used){
        regspushed[i] = 0;
        if(i < tmp1){
          debug("warning: VBCC marked reg %s in use, but backend didn't find it in use anywhere. It is not being used\n", regnames[i]);
        }
      }
    }
  }

  /* vbcc marks backend regs as used - they don't need to be pushed. clear them in regspushed */
  regspushed[tmp1] = regspushed[tmp1_h] = regspushed[tmp2] = regspushed[tmp2_h] = regspushed[ret_reg] = regspushed[sp] = 0;

  /* push all registers that we need to */
  for(int i = 1; i < MAXR+1; i++){
    if(regspushed[i]){
      pushsize_push_reg(f, i);
    }
  }

  /* make space for locals (and set localsize) */
  make_locals(f, offset);

  /* go through each IC, and emit code */
  for(;p;p=p->next){
    debug("------------------------------\n");
    /* switch for each different IC */
    switch(p->code){
      case ASSIGN:
        debug("ASSIGN: size: %u\n", opsize(p));
        /* move q1 to z */

        /* TODO: do assigns with structs and arrays using memcpy */
        if((q1typ(p)&NQ) > POINTER){
          printf("Memcpy assign not implemented\n");
          ierror(0);
        }
        /* get reg to load into */
        reg1 = find_reg_to_load(f, &(p->q1), &(p->z), ztyp(p), tmp1);
        /* load */
        load_into_reg(f, &(p->q1), q1typ(p), reg1);
        /* store */
        store_from_reg(f, &(p->z), q1typ(p), reg1, tmp2);
        break;
      /* alu ops */
      case OR:
      case XOR:
      case AND:
      case LSHIFT:
      case RSHIFT:
      case ADD:
      case SUB:
      case MULT:
      case DIV:
      case MOD:
      case KOMPLEMENT:
      case MINUS:
        /* handles all of the arithemtic operations */
        arithmetic(f, p);
        break;

      case ADDRESS:
        debug("ADDRESS\n");
        /* find reg to use */
        reg1 = source_reg(f, &(p->z), ztyp(p), tmp1);
        /* load address */
        load_address(f, &(p->q1), q1typ(p), reg1);
        /* and store */
        store_from_reg(f, &(p->z), ztyp(p), reg1, tmp2);
        break;

      case CALL:
        debug("CALL\n");
        /* check for inline assembly */
        if((p->q1.flags & (VAR|DREFOBJ)) == VAR && p->q1.v->fi && p->q1.v->fi->inline_asm){
          emit_inline_asm(f,p->q1.v->fi->inline_asm);
        }
        /* check if it is a call to a static or extern location */
        else if(((p->q1.flags & VAR) == VAR)){
          if(isextern(p->q1.v->storage_class)){
            emit(f, "\tcall.j.sp sp %s%s\n", idprefix, p->q1.v->identifier);
          }
          if(isstatic(p->q1.v->storage_class)){
            emit(f, "\tcall.j.sp sp %s%i\n", labprefix, p->q1.v->offset);
          }
        } else {
          /* load address of object into a reg, and call it */
          reg1 = source_reg(f, &(p->q1), q1typ(p), tmp1);
          load_address(f, &(p->q1), q1typ(p), reg1);
          /* call */
          emit(f, "\tcall.r.sp %s sp\n", regnames[reg1]);
        }
        /* add number of bytes pushed to sp */
        mod_stack(f, p->q2.val.vmax);
        /* clear stack size */

        break;

      case CONVERT:
        debug("CONVERT\n");
        /* move q1 to z */

        /* get reg to load into */
        reg1 = find_reg_to_load(f, &(p->q1), &(p->z), ztyp(p), tmp1);
        /* load */
        load_into_reg(f, &(p->q1), q1typ(p), reg1);
        /* TODO: handle floating point, and do sign extends for ints to words */
        if( ((q1typ(p)&NQ) > INT && (q1typ(p)&NQ != POINTER)) || ((q2typ(p)&NQ) > INT && (q2typ(p)&NQ != POINTER))){
          printf("Can't do conversions from long types now\n");
          ierror(0);
        }
        /* store */
        store_from_reg(f, &(p->z), ztyp(p), reg1, tmp2);
        break;

        break;
      case ALLOCREG:
        debug("ALLOCREG\n");

        break;
      case FREEREG:
        debug("FREEREG\n");

        break;
      case COMPARE:
        debug("COMPARE\n");
        compare(f, p);
        break;
      case TEST:
        debug("TEST\n");
        test(f, p);
        break;
      case LABEL:
        debug("LABEL: %u\n", p->typf);
        /* use labprefix */
        emit(f, "%s%i:\n", labprefix, p->typf);
        break;
      /* conditional branches or unconditional branches */
      case BEQ:
      case BNE:
      case BLT:
      case BGE:
      case BLE:
      case BGT:
      case BRA:
        branch(f, p);
        break;

      case PUSH:
        debug("PUSH: Size: %u (Push Size: %u)\n", opsize(p), pushsize(p));

        /* TODO: do pushes with structs and arrays using memcpy */
        if((q1typ(p)&NQ) > POINTER){
          printf("Memcpy push not implemented\n");
          ierror(0);
        } else {
          /* get reg to load into */
          int reg1 = source_reg(f, &(p->q1), q1typ(p), tmp1);
          /* load */
          load_into_reg(f, &(p->q1), q1typ(p), reg1);
          /* gen push */
          push_reg(f, reg1);
        }

        break;
      case ADDI2P:
        debug("ADDI2P\n");
        /* just an addition */
        do_arithmetic(f, &(p->q1), &(p->q2), &(p->z), ADD, q1typ(p), q2typ(p), ztyp(p));
        break;
      case SUBIFP:
        debug("SUBIFP\n");
        /* just a subtraction */
        do_arithmetic(f, &(p->q1), &(p->q2), &(p->z), SUB, q1typ(p), q2typ(p), ztyp(p));

        break;
      case SUBPFP:
        debug("SUBPFP\n");
        /* just a subtraction */
        do_arithmetic(f, &(p->q1), &(p->q2), &(p->z), SUB, q1typ(p), q2typ(p), ztyp(p));

        break;
      case GETRETURN:
        debug("GETRETURN\n");
        /* load the from reg q1.reg into z */
        /* q1.reg should be ret_reg */
        if(p->q1.reg != ret_reg){
          /* TODO: this happens when returning a struct - nothing has to be done? (looks like it from reading other backends) */
        } else {
          store_from_reg(f, &(p->z), ztyp(p), ret_reg, tmp1);
        }
        break;
        break;
      case SETRETURN:
        debug("SETRETURN\n");
        /* load the value into reg z.reg */
        /* z.reg should be ret_reg */
        if(p->z.reg != ret_reg){
          ierror(0);
        }
        load_into_reg(f, &(p->q1), q1typ(p), ret_reg);
        break;

      /* TODO: are MOVEFROMREG and MOVETOREG correct ? */
      case MOVEFROMREG:
        debug("MOVEFROMREG\n");

        store_from_reg(f, &(p->z), ztyp(p), p->q1.reg, tmp2);

        break;
      case MOVETOREG:
        debug("MOVETOREG\n");

        load_into_reg(f, &(p->q1), q1typ(p), p->z.reg);

        break;
      case NOP:
        debug("NOP\n");
        break;

      default:
        printf("No such IC\n");
        ierror(0);
        break;
    }
    /* print args and target */
    debug("operand 1: typ: %u\n", q1typ(p));
    debug_obj(&(p->q1));
    debug("operand 2: typ: %u\n", q2typ(p));
    debug_obj(&(p->q2));
    debug("target: type %u\n", ztyp(p));
    debug_obj(&(p->z));

  }
  /* emit function epilouge */
  /* remove stack and locals */
  remove_locals_and_stack(f);
  /* pop all registers that we need to (done in reverse order)*/
  for(int i = MAXR; i > 0; i--){
    if(regspushed[i]){
      pushsize_pop_reg(f, i);
    }
  }
  /* return */
  function_bottom(f, v, offset);

}

int handle_pragma(const char *s)
{
}
void cleanup_cg(FILE *f)
{
  /* output ending module to make sure multiple asms compiled togeather don't overlap on local labels */
  emit(f, ";\tEnd of VBCC generated section\n\t.module\n\n");
}

void init_db(FILE *f)
{
}
void cleanup_db(FILE *f)
{
}
