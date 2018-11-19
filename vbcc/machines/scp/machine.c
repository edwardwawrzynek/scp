/* VBCC Backend for Small C Processor
 * In Progress - Doesn't Work
 * Edward Wawrzynek 2018
*/

#include "supp.h"

static char FILE_[]=__FILE__;

/* hack to get to compile */
#define THREE_ADDR 0

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
static int ret_reg, ret_reg_h; /* return reg */

#define dt(t) (((t)&UNSIGNED)?udt[(t)&NQ]:sdt[(t)&NQ])
static char *sdt[MAX_TYPE+1]={"??","c","s","i","l","ll","f","d","ld","v","p"};
static char *udt[MAX_TYPE+1]={"??","uc","us","ui","ul","ull","f","d","ld","v","p"};

/* sections */
#define DATA 0
#define BSS 1
#define CODE 2
#define RODATA 3
#define SPECIAL 4

static long stack;
static int stack_valid;
static int section=-1,newobj;
static char *codename="\t.text\n",
  *dataname="\t.data\n",
  *bssname="",
  *rodataname="\t.section\t.rodata\n";

/* return-instruction */
static char *ret;

/* label at the end of the function (if any) */
static int exit_label;

/* assembly-prefixes for labels and external identifiers */
static char *labprefix="l",*idprefix="_";

#if FIXED_SP
/* variables to calculate the size and partitioning of the stack-frame
   in the case of FIXED_SP */
static long frameoffset,pushed,maxpushed,framesize;
#else
/* variables to keep track of the current stack-offset in the case of
   a moving stack-pointer */
static long notpopped,dontpop,stackoffset,maxpushed;
#endif

static long localsize,rsavesize,argsize;

static void emit_obj(FILE *f,struct obj *p,int t);

/* calculate the actual current offset of an object relativ to the
   stack-pointer; we use a layout like this:
   ------------------------------------------------
   | arguments to this function                   |
   ------------------------------------------------
   | return-address [size=4]                      |
   ------------------------------------------------
   | caller-save registers [size=rsavesize]       |
   ------------------------------------------------
   | local variables [size=localsize]             |
   ------------------------------------------------
   | arguments to called functions [size=argsize] |
   ------------------------------------------------
   All sizes will be aligned as necessary.
   In the case of FIXED_SP, the stack-pointer will be adjusted at
   function-entry to leave enough space for the arguments and have it
   aligned to 16 bytes. Therefore, when calling a function, the
   stack-pointer is always aligned to 16 bytes.
   For a moving stack-pointer, the stack-pointer will usually point
   to the bottom of the area for local variables, but will move while
   arguments are put on the stack.

   This is just an example layout. Other layouts are also possible.
*/

static long real_offset(struct obj *o)
{
  long off=zm2l(o->v->offset);
  if(off<0){
    /* function parameter */
    off=localsize+rsavesize+4-off-zm2l(maxalign);
  }

#if FIXED_SP
  off+=argsize;
#else
  off+=stackoffset;
#endif
  off+=zm2l(o->val.vmax);
  return off;
}


/* generate code to load the address of a variable into register r */
static void load_address(FILE *f,int r,struct obj *o,int type)
/*  Generates code to load the address of a variable into register r.   */
{
  if(!(o->flags&VAR)) ierror(0);
  if(o->v->storage_class==AUTO||o->v->storage_class==REGISTER){
    long off=real_offset(o);
    if(THREE_ADDR){
      emit(f,"\tadd.%s\t%s,%s,%ld\n",dt(POINTER),regnames[r],regnames[sp],off);
    }else{
      emit(f,"\tmov.%s\t%s,%s\n",dt(POINTER),regnames[r],regnames[sp]);
      if(off)
	emit(f,"\tadd.%s\t%s,%ld\n",dt(POINTER),regnames[r],off);
    }
  }else{
    emit(f,"\tmov.%s\t%s,",dt(POINTER),regnames[r]);
    emit_obj(f,o,type);
    emit(f,"\n");
  }
}
/* Generates code to load a memory object into register r. tmp is a
   general purpose register which may be used. tmp can be r. */
static void load_reg(FILE *f,int r,struct obj *o,int type)
{
  type&=NU;
  if(o->flags&VARADR){
    load_address(f,r,o,POINTER);
  }else{
    if((o->flags&(REG|DREFOBJ))==REG&&o->reg==r)
      return;
    emit(f,"\tmov.%s\t%s,",dt(type),regnames[r]);
    emit_obj(f,o,type);
    emit(f,"\n");
  }
}

/*  Generates code to store register r into memory object o. */
static void store_reg(FILE *f,int r,struct obj *o,int type)
{
  type&=NQ;
  emit(f,"\tmov.%s\t",dt(type));
  emit_obj(f,o,type);
  emit(f,",%s\n",regnames[r]);
}

/*  Yields log2(x)+1 or 0. */
static long pof2(zumax x)
{
  zumax p;int ln=1;
  p=ul2zum(1L);
  while(ln<=32&&zumleq(p,x)){
    if(zumeqto(x,p)) return ln;
    ln++;p=zumadd(p,p);
  }
  return 0;
}

static struct IC *preload(FILE *,struct IC *);

static void function_top(FILE *,struct Var *,long);
static void function_bottom(FILE *f,struct Var *,long);

#define isreg(x) ((p->x.flags&(REG|DREFOBJ))==REG)
#define isconst(x) ((p->x.flags&(KONST|DREFOBJ))==KONST)

static int q1reg,q2reg,zreg;

static char *ccs[]={"eq","ne","lt","ge","le","gt",""};
static char *logicals[]={"or","xor","and"};
static char *arithmetics[]={"slw","srw","add","sub","mullw","divw","mod"};

/* Does some pre-processing like fetching operands from memory to
   registers etc. */
static struct IC *preload(FILE *f,struct IC *p)
{
  int r;

  if(isreg(q1))
    q1reg=p->q1.reg;
  else
    q1reg=0;

  if(isreg(q2))
    q2reg=p->q2.reg;
  else
    q2reg=0;

  if(isreg(z)){
    zreg=p->z.reg;
  }else{
    if(ISFLOAT(ztyp(p)))
      zreg=tmp1;
    else
      zreg=tmp1;
  }

  if((p->q1.flags&(DREFOBJ|REG))==DREFOBJ&&!p->q1.am){
    p->q1.flags&=~DREFOBJ;
    load_reg(f,tmp1,&p->q1,q1typ(p));
    p->q1.reg=tmp1;
    p->q1.flags|=(REG|DREFOBJ);
  }
  if(p->q1.flags&&!isreg(q1)){
    if(ISFLOAT(q1typ(p)))
      q1reg=tmp1;
    else
      q1reg=tmp1;
    load_reg(f,q1reg,&p->q1,q1typ(p));
    p->q1.reg=q1reg;
    p->q1.flags=REG;
  }

  if((p->q2.flags&(DREFOBJ|REG))==DREFOBJ&&!p->q2.am){
    p->q2.flags&=~DREFOBJ;
    load_reg(f,tmp1,&p->q2,q2typ(p));
    p->q2.reg=tmp1;
    p->q2.flags|=(REG|DREFOBJ);
  }
  if(p->q2.flags&&!isreg(q2)){
    if(ISFLOAT(q2typ(p)))
      q2reg=tmp2;
    else
      q2reg=tmp2;
    load_reg(f,q2reg,&p->q2,q2typ(p));
    p->q2.reg=q2reg;
    p->q2.flags=REG;
  }
  return p;
}

/* save the result (in zreg) into p->z */
void save_result(FILE *f,struct IC *p)
{
  if((p->z.flags&(REG|DREFOBJ))==DREFOBJ&&!p->z.am){
    p->z.flags&=~DREFOBJ;
    load_reg(f,tmp2,&p->z,POINTER);
    p->z.reg=tmp2;
    p->z.flags|=(REG|DREFOBJ);
  }
  if(isreg(z)){
    if(p->z.reg!=zreg)
      emit(f,"\tmov.%s\t%s,%s\n",dt(ztyp(p)),regnames[p->z.reg],regnames[zreg]);
  }else{
    store_reg(f,zreg,&p->z,ztyp(p));
  }
}

/* prints an object */
static void emit_obj(FILE *f,struct obj *p,int t)
{
  if((p->flags&(KONST|DREFOBJ))==(KONST|DREFOBJ)){
    emitval(f,&p->val,p->dtyp&NU);
    return;
  }
  if(p->flags&DREFOBJ) emit(f,"(");
  if(p->flags&REG){
    emit(f,"%s",regnames[p->reg]);
  }else if(p->flags&VAR) {
    if(p->v->storage_class==AUTO||p->v->storage_class==REGISTER)
      emit(f,"%ld(%s)",real_offset(p),regnames[sp]);
    else{
      if(!zmeqto(l2zm(0L),p->val.vmax)){emitval(f,&p->val,LONG);emit(f,"+");}
      if(p->v->storage_class==STATIC){
        emit(f,"%s%ld",labprefix,zm2l(p->v->offset));
      }else{
        emit(f,"%s%s",idprefix,p->v->identifier);
      }
    }
  }
  if(p->flags&KONST){
    emitval(f,&p->val,t&NU);
  }
  if(p->flags&DREFOBJ) emit(f,")");
}

/* generates the function entry code */
static void function_top(FILE *f,struct Var *v,long offset)
{
  rsavesize=0;
  if(v->storage_class==EXTERN){
    if((v->flags&(INLINEFUNC|INLINEEXT))!=INLINEFUNC)
      emit(f,"\t.global\t%s%s\n",idprefix,v->identifier);
    emit(f,"%s%s:\n",idprefix,v->identifier);
  }else
    emit(f,"%s%ld:\n",labprefix,zm2l(v->offset));
}
/* generates the function exit code */
static void function_bottom(FILE *f,struct Var *v,long offset)
{
  emit(f,ret);
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
  fp=0xe + 1;
  tmp1=0xa + 1;
  tmp1_h=0xb + 1;
  tmp2=0xc + 1;
  tmp2_h=0xd + 1;
  ret_reg=0x8 + 1;
  ret_reg_h=0x9 + 1;

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

  /* function return extended reg */
  regnames[9] = "r8";
  regscratch[9] = 0;
  regsa[9] = 1;

  regnames[10] = "r9";
  regscratch[10] = 0;
  regsa[10] = 1;

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

  /* Frame Pointer */
  regnames[15] = "fp";
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
  /* floats and 32 bits will in theory be returned in extended ret_reg, for now keep as pointer
  TODO: should they be returned as a pointer anyway? (one more reg free) */
  if(ISFLOAT(t->flags)){
    return 0;
  }
  if(ISSTRUCT(t->flags)||ISUNION(t->flags))
    return 0;
  /* return everything less than or equal to two bytes in ret_reg */
  if(zmleq(szof(t),l2zm(2L))){
      return ret_reg;
  }
  /* make sure pointers are returned in ret_reg (they should be anyway, as <= 2 bytes) */
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
  /*int constflag;char *sec;
  if(v->clist) constflag=is_const(v->vtyp);
  if(v->storage_class==STATIC){
    if(ISFUNC(v->vtyp->flags)) return;
    if(!special_section(f,v)){
      if(v->clist&&(!constflag||(g_flags[2]&USEDFLAG))&&section!=DATA){emit(f,dataname);if(f) section=DATA;}
      if(v->clist&&constflag&&!(g_flags[2]&USEDFLAG)&&section!=RODATA){emit(f,rodataname);if(f) section=RODATA;}
      if(!v->clist&&section!=BSS){emit(f,bssname);if(f) section=BSS;}
    }
    if(v->clist||section==SPECIAL){
      gen_align(f,falign(v->vtyp));
      emit(f,"%s%ld:\n",labprefix,zm2l(v->offset));
    }else
      emit(f,"\t.lcomm\t%s%ld,",labprefix,zm2l(v->offset));
    newobj=1;
  }
  if(v->storage_class==EXTERN){
    emit(f,"\t.globl\t%s%s\n",idprefix,v->identifier);
    if(v->flags&(DEFINED|TENTATIVE)){
      if(!special_section(f,v)){
	if(v->clist&&(!constflag||(g_flags[2]&USEDFLAG))&&section!=DATA){emit(f,dataname);if(f) section=DATA;}
	if(v->clist&&constflag&&!(g_flags[2]&USEDFLAG)&&section!=RODATA){emit(f,rodataname);if(f) section=RODATA;}
	if(!v->clist&&section!=BSS){emit(f,bssname);if(f) section=BSS;}
      }
      if(v->clist||section==SPECIAL){
	gen_align(f,falign(v->vtyp));
        emit(f,"%s%s:\n",idprefix,v->identifier);
      }else
        emit(f,"\t.global\t%s%s\n\t.%scomm\t%s%s,",idprefix,v->identifier,(USE_COMMONS?"":"l"),idprefix,v->identifier);
      newobj=1;
    }
  }*/
  /* TODO: figure out what all of this does */

  if(v->storage_class == STATIC){
    if(ISFUNC(v->vtyp->flags)) return;
    /* TODO: test for new section creation here */

    /* TODO: do we need to check v->clist ? */
    gen_align(f,falign(v->vtyp));
    emit(f,"%s%ld:\n",labprefix,zm2l(v->offset));
  }
  if(v->storage_class == EXTERN){
    /* We only want to emit records for genuinely defined variables. For
	   * some reason, TENTATIVE is defined for some of this.
     * TODO: is this needed?*/
    if(v->flags&(DEFINED|TENTATIVE)){
      gen_align(f,falign(v->vtyp));
      emit(f,"%s%ld:\n",labprefix,zm2l(v->offset));
    }
    emit(f, "\t.global\t%s\n", v->identifier);
  }

}

void gen_dc(FILE *f,int t,struct const_list *p)
/*  This function has to create static storage          */
/*  initialized with const-list p.                      */
{
  emit(f,"\tdc.%s\t",dt(t&NQ));
  if(!p->tree){
    if(ISFLOAT(t)){
      /*  auch wieder nicht sehr schoen und IEEE noetig   */
      unsigned char *ip;
      ip=(unsigned char *)&p->val.vdouble;
      emit(f,"0x%02x%02x%02x%02x",ip[0],ip[1],ip[2],ip[3]);
      if((t&NQ)!=FLOAT){
	emit(f,",0x%02x%02x%02x%02x",ip[4],ip[5],ip[6],ip[7]);
      }
    }else{
      emitval(f,&p->val,t&NU);
    }
  }else{
    emit_obj(f,&p->tree->o,t&NU);
  }
  emit(f,"\n");newobj=0;
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
  int c,t,i;
  struct IC *m;
  argsize=0;

  for(c=1;c<=MAXR;c++) regs[c]=regsa[c];
  maxpushed=0;

  /*FIXME*/
  ret="\trts\n";

  for(m=p;m;m=m->next){
    c=m->code;t=m->typf&NU;
    if(c==ALLOCREG) {regs[m->q1.reg]=1;continue;}
    if(c==FREEREG) {regs[m->q1.reg]=0;continue;}

    /* convert MULT/DIV/MOD with powers of two */
    if((t&NQ)<=LONG&&(m->q2.flags&(KONST|DREFOBJ))==KONST&&(t&NQ)<=LONG&&(c==MULT||((c==DIV||c==MOD)&&(t&UNSIGNED)))){
      eval_const(&m->q2.val,t);
      i=pof2(vmax);
      if(i){
        if(c==MOD){
          vmax=zmsub(vmax,l2zm(1L));
          m->code=AND;
        }else{
          vmax=l2zm(i-1);
          if(c==DIV) m->code=RSHIFT; else m->code=LSHIFT;
        }
        c=m->code;
	gval.vmax=vmax;
	eval_const(&gval,MAXINT);
	if(c==AND){
	  insert_const(&m->q2.val,t);
	}else{
	  insert_const(&m->q2.val,INT);
	  p->typf2=INT;
	}
      }
    }
#if FIXED_SP
    if(c==CALL&&argsize<zm2l(m->q2.val.vmax)) argsize=zm2l(m->q2.val.vmax);
#endif
  }

  for(c=1;c<=MAXR;c++){
    if(regsa[c]||regused[c]){
      BSET(regs_modified,c);
    }
  }

  localsize=(zm2l(offset)+3)/4*4;
#if FIXED_SP
  /*FIXME: adjust localsize to get an aligned stack-frame */
#endif

  function_top(f,v,localsize);

#if FIXED_SP
  pushed=0;
#endif

  for(;p;p=p->next){
    c=p->code;t=p->typf;
    if(c==NOP) {p->z.flags=0;continue;}
    if(c==ALLOCREG) {regs[p->q1.reg]=1;continue;}
    if(c==FREEREG) {regs[p->q1.reg]=0;continue;}
    if(c==LABEL) {emit(f,"%s%d:\n",labprefix,t);continue;}
    if(c==BRA){
      if(0/*t==exit_label&&framesize==0*/)
	emit(f,ret);
      else
	emit(f,"\tb\t%s%d\n",labprefix,t);
      continue;
    }
    if(c>=BEQ&&c<BRA){
      emit(f,"\tb%s\t",ccs[c-BEQ]);
      if(isreg(q1)){
	emit_obj(f,&p->q1,0);
	emit(f,",");
      }
      emit(f,"%s%d\n",labprefix,t);
      continue;
    }
    if(c==MOVETOREG){
      load_reg(f,p->z.reg,&p->q1,regtype[p->z.reg]->flags);
      continue;
    }
    if(c==MOVEFROMREG){
      store_reg(f,p->z.reg,&p->q1,regtype[p->z.reg]->flags);
      continue;
    }
    if((c==ASSIGN||c==PUSH)&&((t&NQ)>POINTER||((t&NQ)==CHAR&&zm2l(p->q2.val.vmax)!=1))){
      ierror(0);
    }
    p=preload(f,p);
    c=p->code;
    if(c==SUBPFP) c=SUB;
    if(c==ADDI2P) c=ADD;
    if(c==SUBIFP) c=SUB;
    if(c==CONVERT){
      if(ISFLOAT(q1typ(p))||ISFLOAT(ztyp(p))) ierror(0);
      if(sizetab[q1typ(p)&NQ]<sizetab[ztyp(p)&NQ]){
	if(q1typ(p)&UNSIGNED)
	  emit(f,"\tzext.%s\t%s\n",dt(q1typ(p)),regnames[zreg]);
	else
	  emit(f,"\tsext.%s\t%s\n",dt(q1typ(p)),regnames[zreg]);
      }
      save_result(f,p);
      continue;
    }
    if(c==KOMPLEMENT){
      load_reg(f,zreg,&p->q1,t);
      emit(f,"\tcpl.%s\t%s\n",dt(t),regnames[zreg]);
      save_result(f,p);
      continue;
    }
    if(c==SETRETURN){
      load_reg(f,p->z.reg,&p->q1,t);
      BSET(regs_modified,p->z.reg);
      continue;
    }
    if(c==GETRETURN){
      if(p->q1.reg){
        zreg=p->q1.reg;
	save_result(f,p);
      }else
        p->z.flags=0;
      continue;
    }
    if(c==CALL){
      int reg;
      /*FIXME*/
#if 0
      if(stack_valid&&(p->q1.flags&(VAR|DREFOBJ))==VAR&&p->q1.v->fi&&(p->q1.v->fi->flags&ALL_STACK)){
	if(framesize+zum2ul(p->q1.v->fi->stack1)>stack)
	  stack=framesize+zum2ul(p->q1.v->fi->stack1);
      }else
	stack_valid=0;
#endif
      if((p->q1.flags&(VAR|DREFOBJ))==VAR&&p->q1.v->fi&&p->q1.v->fi->inline_asm){
        emit_inline_asm(f,p->q1.v->fi->inline_asm);
      }else{
	emit(f,"\tcall\t");
	emit_obj(f,&p->q1,t);
	emit(f,"\n");
      }
      /*FIXME*/
#if FIXED_SP
      pushed-=zm2l(p->q2.val.vmax);
#endif
      if((p->q1.flags&(VAR|DREFOBJ))==VAR&&p->q1.v->fi&&(p->q1.v->fi->flags&ALL_REGS)){
	bvunite(regs_modified,p->q1.v->fi->regs_modified,RSIZE);
      }else{
	int i;
	for(i=1;i<=MAXR;i++){
	  if(regscratch[i]) BSET(regs_modified,i);
	}
      }
      continue;
    }
    if(c==ASSIGN||c==PUSH){
      if(t==0) ierror(0);
      if(c==PUSH){
#if FIXED_SP
	emit(f,"\tmov.%s\t%ld(%s),",dt(t),pushed,regnames[sp]);
	emit_obj(f,&p->q1,t);
	emit(f,"\n");
	pushed+=zm2l(p->q2.val.vmax);
#else
	emit(f,"\tpush.%s\t",dt(t));
	emit_obj(f,&p->q1,t);
	emit(f,"\n");
	//push(zm2l(p->q2.val.vmax));
#endif
	continue;
      }
      if(c==ASSIGN){
	load_reg(f,zreg,&p->q1,t);
	save_result(f,p);
      }
      continue;
    }
    if(c==ADDRESS){
      load_address(f,zreg,&p->q1,POINTER);
      save_result(f,p);
      continue;
    }
    if(c==MINUS){
      load_reg(f,zreg,&p->q1,t);
      emit(f,"\tneg.%s\t%s\n",dt(t),regnames[zreg]);
      save_result(f,p);
      continue;
    }
    if(c==TEST){
      emit(f,"\ttst.%s\t",dt(t));
      if(multiple_ccs)
	emit(f,"%s,",regnames[zreg]);
      emit_obj(f,&p->q1,t);
      emit(f,"\n");
      if(multiple_ccs)
	save_result(f,p);
      continue;
    }
    if(c==COMPARE){
      emit(f,"\tcmp.%s\t",dt(t));
      if(multiple_ccs)
	emit(f,"%s,",regnames[zreg]);
      emit_obj(f,&p->q1,t);
      emit(f,",");
      emit_obj(f,&p->q2,t);
      emit(f,"\n");
      if(multiple_ccs)
	save_result(f,p);
      continue;
    }
    if((c>=OR&&c<=AND)||(c>=LSHIFT&&c<=MOD)){
      if(!THREE_ADDR)
	load_reg(f,zreg,&p->q1,t);
      if(c>=OR&&c<=AND)
	emit(f,"\t%s.%s\t%s,",logicals[c-OR],dt(t),regnames[zreg]);
      else
	emit(f,"\t%s.%s\t%s,",arithmetics[c-LSHIFT],dt(t),regnames[zreg]);
      if(THREE_ADDR){
	emit_obj(f,&p->q1,t);
	emit(f,",");
      }
      emit_obj(f,&p->q2,t);
      emit(f,"\n");
      save_result(f,p);
      continue;
    }
    pric2(stdout,p);
    ierror(0);
  }
  function_bottom(f,v,localsize);
  if(stack_valid){
    if(!v->fi) v->fi=new_fi();
    v->fi->flags|=ALL_STACK;
    v->fi->stack1=stack;
  }
  emit(f,"# stacksize=%lu%s\n",zum2ul(stack),stack_valid?"":"+??");
}

/*
int reg_parm(struct reg_handle *m, struct Typ *t,int vararg,struct Typ *d)
{
  int f;
  f=t->flags&NQ;
  if(f<=LONG||f==POINTER){
    if(m->gregs>=GPR_ARGS)
      return 0;
    else
      return FIRST_GPR+3+m->gregs++;
  }
  if(ISFLOAT(f)){
    if(m->fregs>=FPR_ARGS)
      return 0;
    else
      return FIRST_FPR+2+m->fregs++;
  }
  return 0;
}*/

int handle_pragma(const char *s)
{
}
void cleanup_cg(FILE *f)
{
  printf("Exiting SCP Backend\n");
  /* write a comment at the end of asm output noting the end */
  if(f != NULL){
    fprintf(f, ";\tEnd of VBCC SCP generated section\n");
  }
}

void init_db(FILE *f)
{
}
void cleanup_db(FILE *f)
{
}
