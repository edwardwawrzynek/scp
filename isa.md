# ISA

## Conventions
The following conventions are used in asm commands and encodings.
### Types
* `r` - register (dst register generally encoded in last nibble of instruction)
  * `f` - the alu flags register (not one fo the general purpose registers)
* `i` - immediate constants (encoded in word after instruction)
* `m` - a fixed location in memory (pc relative)
  * `mb` - an unsigned byte in memory
  * `mbs` - a signed byte in memory
  * `mw` - a word in memory (signed or unsigned, no sign extension needed)
* `p` - a memory location pointed to by a register (not pc relative)
  * `pb` - an unsigned byte in memory
  * `pbs` - a signed byte in memory
  * `pw` - a word in memory
* `off` - an addressing offset (stored in word after instruction)
* `ra` - a pc relative adress to be converted to a non pc-relative adress (for loading pointer initial values)
* `c` - a condition code (see below)
* `sp` - a register used as a stack pointer

### Registers
Registers are the program counter (pc), flags register (f), and registers r0-rf. By convention only, r0 is used as the stack pointer and r1 as the frame pointer. The hardware can use any register as a stack pointer, or have multiple stacks.

Extended register are formed by two registers next to each other starting on an even reg number. Extended registers are (e0, e2, e4, ... ec, ee)

Register Usage Conventions:

Reg|Extended|VBCC Usage
-|-|-
r0|e0 low |SP
r1|e0 high|FP
r2|e2 low |Backend Tmp
r3|e2 high|Backend Tmp
r4|e4 low |GPR
r5|e4 high|GPR
r6|e6 low |GPR
r7|e6 high|GPR
r8|e8 low |GPR
r9|e8 high|GPR
ra|ea low |GPR
rb|ea high|GPR
rc|ec low |GPR
rd|ec high|GPR
re|ee low |GPR
rf|ee high|GPR

### ALU ops
There are 16 possible alu operations, stored as 4-bit alu opcodes. They are:
```
0 - | (bitwise or)
1 - ^ (bitwise xor)
2 - & (bitwise and)
3 - << (left shift)
4 - >> (unsigned right shift)
5 - >> (signed right shift)
6 - + (addition)
7 - - (subtraction)
8 - * (multiplication)
9 - ~ (bitwise complement) (of first operand)
a - - (unary minus) (of first operand)
b -
c -
d -
e -
f -

```

### Condition Codes
Condition codes in the flag register are set by the `cmp` instruction. They are five bit values, encoded as follows:

4|3|2|1|0
-|-|-|-|-
signed greater than|signed less than|unsigned greater than|unsigned less than|equal to

A conditional is a five bit value. It is or'd with the flags register, so multiple conditions can be combined. Thus, the following are all the posibilities for unsigned numbers:
```
000 - false
001 - ==
010 - <
011 - <=
100 - >
101 - >=
110 - !=
111 - true
```
NOTE: the flags register starts with the value 1 loaded so that an uncoditional jump always works.

### Encoding Shorthands
* `s/u` - signedness of the value. 0=unsigned, 1=signed
* `b/w` - width of the value. 0=word, 1=byte

### PC Relative Instructions
All instructions that deal with immediate addresses are pc-relative. Pointer loads are not pc relative - real adresses for initilizing pointers should be loaded with `ld.r.

## Nop Instructions
### nop
Do nothing
```
nop
; nothing
```
<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=10>----</td>
</tr>
</table>

## Move Instructions
### mov.r.r
Copy one register to another.
```
mov.r.r dst src
; dst = src
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=4>opcode</td>
  <td colspan=4>----</td>
  <td colspan=4>srcreg </td>
  <td colspan=4>dst reg</td>
</tr>
</table>

## ALU Instructions
### alu.r.r
Perform an alu operation on two registers, and stores the result in the first register.
```
alu.r.r op dst src
; dst = dst op src
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=4>opcode</td>
  <td colspan=4>alu op</td>
  <td colspan=4>src reg</td>
  <td colspan=4>dst reg</td>
</tr>
</table>

### alu.r.i
Perform an alu operation on a register and an immediate, and stores the result in the register.
```
alu.r.r op dst imd
; dst = dst op imd
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=4>opcode</td>
  <td colspan=4>alu op</td>
  <td colspan=4>----</td>
  <td colspan=4>dst reg</td>
  <td>immediate value</td>
</tr>
</table>

### cmp.r.f
Compare two registers, and set alu flags based on comparison.
```
cmp.r.f reg1 reg2
; flags = reg1 cmp reg2
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=4>opcode</td>
  <td colspan=4>----</td>
  <td colspan=4>reg2</td>
  <td colspan=4>reg1</td>
</tr>
</table>

## Load Instructions

### ld.r.i
Load an immediate into a register.
```
ld.r.i dst imd
; dst = imd
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=8>opcode</td>
  <td colspan=4>----</td>
  <td colspan=4>dst reg</td>
  <td>immediate value</td>
</tr>
</table>

### ld.r.(mb/mbs/mw)
Load a value from memory into a register, sign extend if needed.
```
ld.r.mb/mbs/mw dst mem
; dst = (pc + mem)
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=1>b/w</td>
  <td colspan=1>s/u</td>
  <td colspan=4>----</td>
  <td colspan=4>dst reg</td>
  <td>memory address</td>
</tr>
</table>

### ld.r.(pb/pbs/pw)
Load a value pointed to by a register into a register, sign extend if needed.
```
ld.r.pb/pbs/pw dst src
; dst = (src)
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=1>b/w</td>
  <td colspan=1>s/u</td>
  <td colspan=4>src reg</td>
  <td colspan=4>dst reg</td>
</tr>
</table>

### ld.r.(pb/pbs/pw) + off
Load a value pointed to by a register plus offset into a register, sign extend if needed.
```
ld.r.pb/pbs/pw dst src off
; dst = (src + off)
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=1>b/w</td>
  <td colspan=1>s/u</td>
  <td colspan=4>src reg</td>
  <td colspan=4>dst reg</td>
  <td>address offset</td>
</tr>
</table>

### ld.r.ra
Load a not pc-relative adress from a pc-relative adress immediate into a register.
```
ld.r.ra dst addr
; dst = pc + addr
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=6>-----</td>
  <td colspan=4>dst reg</td>
  <td>address</td>
</tr>
</table>

## Store Instructions

### st.r.(mb/mbs/mw)
Store a value from a register into memory.
```
st.r.mb/mbs/mw src mem
; (pc + mem) = src
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=1>b/w</td>
  <td colspan=1>-</td>
  <td colspan=4>----</td>
  <td colspan=4>src reg</td>
  <td>memory address</td>
</tr>
</table>

### st.r.(pb/pbs/pw)
Store a value from a register into the memory addr pointed to by a register.
```
st.r.pb/pbs/pw src dst
; (dst) = src
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=1>b/w</td>
  <td colspan=1>-</td>
  <td colspan=4>dst reg</td>
  <td colspan=4>src reg</td>
</tr>
</table>

### st.r.(pb/pbs/pw) + off
Store a value from a register into the memory addr pointed to by a register plus an offset.
```
st.r.pb/pbs/pw src dst off
; (dst + off) = src
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=1>b/w</td>
  <td colspan=1>-</td>
  <td colspan=4>dst reg</td>
  <td colspan=4>src reg</td>
  <td>address offset</td>
</tr>
</table>

## Jump Instructions
### jmp.c.i
Perform a conditional jump to a fixed addr.
```
jmp.c.i cond addr
; if flags | cond then pc = addr
```
Note - an unconditional jump can be performed by using `0b111` as the condition code.

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=3>---</td>
  <td colspan=3>cond</td>
  <td colspan=4>---</td>
  <td>address</td>
</tr>
</table>

### jmp.c.r
Perform a conditional jump to an addr in a register.
```
jmp.c.r cond reg
; if flags | cond then pc = reg
```
Note - an unconditional jump can be performed by using `0b111` as the condition code.

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=3>---</td>
  <td colspan=3>cond</td>
  <td colspan=4>reg</td>
</tr>
</table>

## Stack instructions
### push.r.sp
Push a register onto a stack.
```
push.r.sp reg sp
; (sp - 2) = reg
; sp = sp - 2
```
Note - The register used as a stack pointer must be aligned on word boundries.

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=2>---</td>
  <td colspan=4>reg</td>
  <td colspan=4>sp</td>
</tr>
</table>

### pop.r.sp
Pop a value off a stack into a register.
```
pop.r.sp reg sp
; reg = (sp)
; sp = sp + 2
```
Note - The register used as a stack pointer must be aligned on word boundries.

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=2>---</td>
  <td colspan=4>reg</td>
  <td colspan=4>sp</td>
</tr>
</table>

### call.i.sp
Perform a function call to a fixed addr.
```
call.i.sp sp imd
; (sp - 2) = pc
; sp = sp - 2
; pc = imd
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=6>---</td>
  <td colspan=4>sp</td>
  <td>function address</td>
</tr>
</table>

### call.r.sp
Perform a function call to an address in a register.
```
call.r.sp reg sp
; (sp - 2) = pc
; sp = sp - 2
; pc = reg
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=2>---</td>
  <td colspan=4>reg</td>
  <td colspan=4>sp</td>
</tr>
</table>

## Pipeline
Three stages: EX (Execute), MEM (Memory Access), RW (Register Writeback)

-|EX|MEM|RW
-|-|-|-
Memory Access|Instr Register Word 1|Memory Instruction|Instr Register Word 2
Alu|Offset Add|Alu instructions|-
Register Write|-|sp increment/deincrement|Main Write Back

### Clocks

CLK0 - Earlier Clock - MMU clk, alu op, reg write back

CLK1 - Delayed Clock - RAM clk, microcode clk