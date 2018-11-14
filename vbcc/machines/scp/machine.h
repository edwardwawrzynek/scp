/* SCP Backend for VBCC */

/** register usage by backend:
 * r0: non-scratch register (we have to save/restore it)
 * r1: non-scratch register (we have to save/restore it)
 * r2: non-scratch register (we have to save/restore it)
 * r3: non-scratch register (we have to save/restore it)
 * r4: non-scratch register (we have to save/restore it)
 * r5: non-scratch register (we have to save/restore it)
 * r6: scratch register (vbcc saves this for us)
 * r7: scratch register (vbcc saves this for us)
 * r8: scratch register (vbcc saves this for us)
 * r9: scratch register (vbcc saves this for us)
 * ra: scratch register (vbcc saves this for us)
 * rb: Function Return Value
 * rc: Backend Temp1
 * rd: Backend Temp 2
 * re: Frame Pointer
 * rf: Stack Pointer
**/

/** stack layout used by backend (top is high addr, bottom low addr - stack grows downwards)
 * For this function:
int f(int arg1, char arg2){
    char local1;
    int local2;

    ...
 }
The stack layout is the following (SP and FP show where they are after the prologue):
 * ---HIGH ADDR---
 * arg1         (high byte)
 * arg1         (low byte)
 * ---          (args are passed as a min 2 bytes)
 * arg2         (only byte)
 * return_addr  (high byte)(from call command)
 * return_addr  (low byte)
 * saved_fp     (high byte)(from function prologue)
 * saved_fp     (low byte)      <- FP
 * local1       (only byte)
 * local2       (high byte)
 * local2       (low byte)      <- SP
 * ---LOW_ADDR---
**/

/** function prologue and epilogue:
 * push.r.sp FP SP  ; Push FP from pervious function
 * mov.r.r   FP SP  ; Init new FP (points to push'd old FP)
 * ;    Function Body, modifying SP
 * ;    Local variables are accessed based on FP
 * ;    So, local1 is FP-#1, local2 FP-#3, etc
 * mov.r.r   SP FP  ; Restore SP (points to push'd old FP)
 * pop.r.sp  FP SP  ; Pop old FP off stack
 * ret.n.sp SP      ; Return - because of pop, SP points to ret addr
 *
 * calling a function: (assuming two arguments in r0 and r1)
 * NOTE: arguments are pushed right to left
 * push.r.sp r1 SP
 * push.r.sp r0 SP
 * call.j.sp SP function
 * alu.r.i add SP #4
 */
#include "dt.h"

struct AddressingMode{
    int never_used;
};

/*  The number of registers of the target machine. */
#define MAXR 16

/*  Number of commandline-options the code-generator accepts.       */
#define MAXGF 20

/*  If this is set to zero vbcc will not generate ICs where the     */
/*  target operand is the same as the 2nd source operand.           */
/*  This can sometimes simplify the code-generator, but usually     */
/*  the code is better if the code-generator allows it.             */
#define USEQ2ASZ 1

/*  This specifies the smallest integer type that can be added to a */
/*  pointer.                                                        */
#define MINADDI2P INT

/*  If the bytes of an integer are ordered most significant byte    */
/*  byte first and then decreasing set BIGENDIAN to 1.              */
#define BIGENDIAN 0

/*  If the bytes of an integer are ordered lest significant byte    */
/*  byte first and then increasing set LITTLEENDIAN to 1.           */
#define LITTLEENDIAN 1

/*  Note that BIGENDIAN and LITTLEENDIAN are mutually exclusive.    */

/*  If switch-statements should be generated as a sequence of       */
/*  SUB,TST,BEQ ICs rather than COMPARE,BEQ ICs set this to 1.      */
/*  This can yield better code on some machines.                    */
#define SWITCHSUBS 0

/*  In optimizing compilation certain library memcpy/strcpy-calls   */
/*  with length known at compile-time will be inlined using an      */
/*  ASSIGN-IC if the size is less or equal to INLINEMEMCPY.         */
/*  The type used for the ASSIGN-IC will be UNSIGNED|CHAR.          */
#define INLINEMEMCPY 1024

/*  Parameters are sometimes passed in registers without __reg.     */
#define HAVE_REGPARMS 1

/*  Parameters on the stack should be pushed in order rather than   */
/*  in reverse order.                                               */
#define ORDERED_PUSH FIXED_SP

/*  Structure for reg_parm().                                       */
struct reg_handle{
    unsigned long gregs;
    unsigned long fregs;
};

/*  We have some target-specific variable attributes.               */
#define HAVE_TARGET_ATTRIBUTES

/* We have target-specific pragmas */
#define HAVE_TARGET_PRAGMAS

/*  We keep track of all registers modified by a function.          */
#define HAVE_REGS_MODIFIED 1

/* We have a implement our own cost-functions to adapt
   register-allocation */
#define HAVE_TARGET_RALLOC 1
#define cost_move_reg(x,y) 1
#define cost_load_reg(x,y) 2
#define cost_save_reg(x,y) 2
#define cost_pushpop_reg(x) 3

/* size of buffer for asm-output, this can be used to do
   peephole-optimizations of the generated assembly-output */
#define EMIT_BUF_LEN 1024 /* should be enough */
/* number of asm-output lines buffered */
#define EMIT_BUF_DEPTH 4

/*  We have no asm_peephole to optimize assembly-output */
#define HAVE_TARGET_PEEPHOLE 0

/* we do not have a mark_eff_ics function, this is used to prevent
   optimizations on code which can already be implemented by efficient
   assembly */
#undef HAVE_TARGET_EFF_IC

/* we only need the standard data types (no bit-types, different pointers
   etc.) */
#undef HAVE_EXT_TYPES
#undef HAVE_TGT_PRINTVAL

/* we do not need extra elements in the IC */
#undef HAVE_EXT_IC

/* we do not use unsigned int as size_t (but unsigned long, the default) */
#undef HAVE_INT_SIZET

/* we do not need register-pairs */
#undef HAVE_REGPAIRS


/* do not create CONVERT ICs from integers smaller than int to floats */
#define MIN_INT_TO_FLOAT_TYPE INT

/* do not create CONVERT ICs from floats to ints smaller than int */
#define MIN_FLOAT_TO_INT_TYPE INT

/* do not create CONVERT_ICs from floats to unsigned integers */
#define AVOID_FLOAT_TO_UNSIGNED 1

/* do not create CONVERT_ICs from unsigned integers to floats */
#define AVOID_UNSIGNED_TO_FLOAT 1
