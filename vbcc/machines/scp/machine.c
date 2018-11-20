/* VBCC Backend for Small C Processor
 * In Progress - Doesn't Work
 * Edward Wawrzynek 2018
*/

#include "supp.h"
#include <stdarg.h>

static char FILE_[]=__FILE__;

/* enables debug information */
#define DEBUG
/* #undef DEBUG */

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
    debug("\t\tauto %s: local offset %li, offset: %li\n", v->offset > 0 ? "local" : "argument", v->offset, val);
  }
  if(isextern(v->storage_class)){
    debug("\t\textern _%s + %li\n", v->identifier, val);
  }
  if(isstatic(v->storage_class)){
    debug("\t\tstatic l%u + %li\n", v->offset, val);
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
    debug("\tconstant: %li\n", o->val.vmax);
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
  emit(f, ";\tFunction %s\n;\tlocalsize: %u\n", v->identifier, offset);
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
  emit(f,"\tret.n.sp\tsp\n");
  emit(f, ";\tEnd of function %s\n", v->identifier);
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
    emit(f, "\talu.r.i sub sp %li\n", size);
  }

}

/* modify the stack pointer */
static void mod_stack(FILE *f, long change){
  stackoffset += change;
  if(change){
    emit(f, "\talu.r.i add sp %li\n", change);
  }
}

/* remove room made for locals and stackoffset */
static void remove_locals_and_stack(FILE *f){
  int s = stackoffset + localsize;
  /* only emit add if we need to */
  if(s){
    emit(f, "\talu.r.i add sp %s\n", s);
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
 * a temporary value may be loaded into the object before the final value is loaded
 * f is the file output stream
 * o is the object
 * typ is the type (from q1typ, q2typ, or ztyp) of the object
 * reg is the reg to load into */
static void load_into_reg(FILE *f, struct obj *o, int typ, int reg){

  /* clear all but unsigned from type */
  typ &= NU;

  /* make sure we have something */
  if(!o->flags){
    ierror(0);
  }

  /* load into reg, then apply drefobj if nessesary */
  if(o->flags & REG){
    if(o->reg != reg){
      emit(f, "\tmov.r.r %s %s\n", regnames[reg], regnames[o->reg]);
    }
  } else if (o->flags & KONST){
    emit(f, "\tld.r.i %s %li\n", regnames[reg], o->val.vmax);
  } else if (o->flags & VAR){
    /* storage class of the variable */
    int sc = o->v->storage_class;
    /* check if we are loading address of a var */
    if(o->flags & VARADR){
      /* should only be used with static or external variables */
      if(isextern(sc)){
        emit(f, "\tld.r.i %s %s%s +%li\n", regnames[reg], idprefix, o->v->identifier, o->val.vmax);
      }
      if(isstatic(sc)){
        emit(f, "\tld.r.i %s %s%i +%li\n", regnames[reg], idprefix, o->v->offset, o->val.vmax);
        }
    } else {
      /* handle externs and static */
      if(isextern(sc)){
        emit(f, "\tld.r.m.%s %s %s%s +%li\n", dt(typ), regnames[reg], idprefix, o->v->identifier, o->val.vmax);
      }
      if(isstatic(sc)){
        emit(f, "\tld.r.m.%s %s %s%i +%li\n", dt(typ), regnames[reg], labprefix, o->v->offset, o->val.vmax);
      }
      /* handle automatic variables */
      if(isauto(sc)){
        /* get offset */
        long off = real_stack_offset(o);
        /* emit with an offset if we need to */
        if(off){
          emit(f, "\tld.r.p.off.%s %s sp %li\n", dt(typ), regnames[reg], off);
        } else {
          emit(f, "\tld.r.p.%s %s sp\n", dt(typ), regnames[reg]);
        }
      }
    }
  }
  /* apply drefobj */
  if (o->flags & DREFOBJ){
    emit(f, "\tld.r.p.%s %s %s\n", dt(typ), regnames[reg], regnames[reg]);
  }
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
  if((op==INT||op==SHORT||op==POINTER)&&(tp==INT||tp==SHORT||tp==POINTER)){
    return 0;
  }
  /* all floats have the same representation */
  if(ISFLOAT(op)&&ISFLOAT(tp)) return 0;

  /* TODO: do we need conversions on char -> int or vice versa? */
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
  emit(f, ";\tvar: %s\n", v->identifier);

  if(v->storage_class == STATIC){
    if(ISFUNC(v->vtyp->flags)) return;
    /* TODO: test for new section creation here */

    /* TODO: do we need to check v->clist ? */
    emit(f,"%s%ld:\n",labprefix,zm2l(v->offset));
    gen_align(f,falign(v->vtyp));
  }
  if(v->storage_class == EXTERN){
    /* We only want to emit records for genuinely defined variables. For
	   * some reason, TENTATIVE is defined for some of this.
     * TODO: is this needed?*/
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

  debug("gen_code()\n");

  /* emit function label (resets stackoffset and push size) */
  function_top(f, v, offset);
  /* make space for locals (and set localsize) */
  make_locals(f, offset);

  /* check if the code uses a non scratch reg, and add it to regspushed */
  struct IC *ps = p;
  for(;ps;ps=ps->next){

  }

  /* set backend regs to be pushed */
  /* TODO: do we need to push backend regs ? */
  regspushed[tmp1] = regspushed[tmp1_h] = regspushed[tmp2] = regspushed[tmp2_h] = 1;

  /* push all registers that we need to */
  for(int i = 1; i < MAXR+1; i++){
    if(regspushed[i]){
      pushsize_push_reg(f, i);
    }
  }

  emit(f, ";\tBegin function body\n");
  /* go through each IC, and emit code */
  for(;p;p=p->next){
    debug("------------------------------\n");
    /* switch for each different IC */
    switch(p->code){
      case ASSIGN:
        debug("ASSIGN\n");

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
        /* TODO: call a general arithmetic routine */
        break;

      case ADDRESS:
        debug("ADDRESS\n");

        break;

      case CALL:
        debug("CALL\n");

        break;

      case CONVERT:
        debug("CONVERT\n");

        break;
      case ALLOCREG:
        debug("ALLOCREG\n");

        break;
      case FREEREG:
        debug("FREEREG\n");

        break;
      case COMPARE:
        debug("COMPARE\n");

        break;
      case TEST:
        debug("TEST\n");

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
        /* call a general conditional branch emitter */
        break;

      case PUSH:
        debug("PUSH\n");

        break;
      case ADDI2P:
        debug("ADDI2P\n");

        break;
      case SUBIFP:
        debug("SUBIFP\n");

        break;
      case SUBPFP:
        debug("SUBPFP\n");

        break;
      case GETRETURN:
        debug("GETRETURN\n");

        break;
      case SETRETURN:
        debug("SETRETURN\n");

        break;
      case MOVEFROMREG:
        debug("MOVEFROMREG\n");

        break;
      case MOVETOREG:
        debug("MOVETOREG\n");

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
    debug("operand 1:\n");
    debug_obj(&(p->q1));
    debug("operand 2:\n");
    debug_obj(&(p->q2));
    debug("target:\n");
    debug_obj(&(p->z));

  }
  /* emit function epilouge */
  emit(f,";\tEnd function body\n");
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
  printf("Exiting SCP Backend\n");
  /* write a comment at the end of asm output noting the end */
  if(f != NULL){
    emit(f, ";\tEnd of VBCC SCP generated section\n");
  }
}

void init_db(FILE *f)
{
}
void cleanup_db(FILE *f)
{
}
