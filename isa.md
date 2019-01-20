# ISA

## Conventions
The following conventions are used in asm commands and encodings.
### Types
* `n` - none type (no dst or src)
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
* `j` - a pc-relative jump adress
* `ra` - a pc relative adress to be converted to a non pc-relative adress (for loading pointer initial values)
* `c` - a condition code (see below)
* `sp` - a register used as a stack pointer
* `p` - an io port number
* `i` - an interrupt vector entry (one of 16 ints)
* `ipc` - the interrupt pc reg (pc copied to ipc reg on interupt)

### Registers
Registers are the program counter (pc), flags register (f), and registers r0-rf. By convention only, r0 is used as the stack pointer and r1 as the frame pointer. The hardware can use any register as a stack pointer, or have multiple stacks.

Extended register are formed by two registers next to each other starting on an even reg number. Extended registers are (e0, e2, e4, ... ec, ee)

Register Usage Conventions:

Reg|Extended|VBCC Usage
-|-|-
r0|e0 low |GPR
r1|e0 high|GPR
r2|e2 low |GPR
r3|e2 high|GPR
r4|e4 low |GPR
r5|e4 high|GPR
r6|e6 low |GPR
r7|e6 high|GPR
r8|e8 low |GPR
r9|e8 high|GPR
ra|ea low |GPR
rb|ea high|GPR
rc|ec low |Backend Temp
rd|ec high|Backend Temp
re|ee low |FP
rf|ee high|SP

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
All instructions that deal with immediate addresses are pc-relative. Pointer loads are not pc relative - real adresses for initilizing pointers should be loaded with `ld.r.ra`.

PC relative addresses are found by taking the address of (inst_addr + mem_addr + 2), where instr_addr is the address where the first word of the instruction is written, and mem_addr is the pc-relative addr. The +2 is because the pc will already be incremented past the instruction by the time it executes.

### Instruction System
SCP has 16 interrupt priority levels, ranging from int0 (highest priority) to intf (lowest priority).

SCP has two privilage levels, 0 (system privilage), and 1 (user privilage). Interrupts can only occur in user privilage. An interrupts raises the privilage level to system privilage, and jumps to the interrupt vector. Because the privilage was raised to system, the page table base register is not used for page table calculations. This means that the interrupt vector that is jumped to will be in the system memory (ptb 0).

If an interrupt occurs and scp is in system privilage, the interrupts will wait till the privilage level goes back to user to take effect.

NOTE: because inetrupts can only occur in user privilage and interrupts switch privilage to system priority, interrupts can't be interrupted by higher priority interrupts. Thus, interrupt priority only comes into play if there are two inetrupts waiting to happen at the same time.

Interrupts can be triggered by an external event, or by the `int.i.n` instruction. An interrupt is the only way to raise the privilage level from user privilage, and are used for system calls, etc. The interrupt instruction can trigger any interrupt, even if it is also wired to an external device.

### Opcode Encodings
Instr | opcode
-|-
`nop.n.n`               | 000000
`mov.r.r`               | 000001
`cmp.r.f`               | 000010
`ld.r.ra`               | 000011
`alu.r.r`               | 0001__
`alu.r.i`               | 0010__
`ld.r.i`                | 001100
`ld.r.m.(b/bs/w)`       | 001101
`ld.r.p.(b/bs/w)`       | 001110
`ld.r.p.off.(b/bs/w)`   | 001111
`st.r.m.(b/bs/w)`       | 010000
`st.r.p.(b/bs/w)`       | 010001
`st.r.p.off.(b/bs/w)`   | 010010
`jmp.c.j`               | 010011
`jmp.c.r`               | 010100
`push.r.sp`             | 010101
`pop.r.sp`              | 010110
`call.j.sp`             | 010111
`call.r.sp`             | 011000
`ret.n.sp`              | 011001
`out.r.p`               | 011010
`in.r.p`                | 011011
`int.i.n`               | 011100
`mmu.r.r`               | 011101
`ptb.r.n`               | 011110
`reti.ipc.n`            | 011111
`mov.r.ipc`             | 100000
`mov.ipc.r`             | 100001

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
  <td colspan=6>opcode</td>
  <td colspan=2>----</td>
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
  <td colspan=6>opcode</td>
  <td colspan=2>----</td>
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
  <td colspan=6>opcode</td>
  <td colspan=6>----</td>
  <td colspan=4>dst reg</td>
  <td>immediate value</td>
</tr>
</table>

### ld.r.m.(b/bs/w)
Load a value from memory into a register, sign extend if needed.
```
ld.r.m.b/bs/w dst mem
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

### ld.r.p.(b/bs/w)
Load a value pointed to by a register into a register, sign extend if needed.
```
ld.r.p.b/bs/w dst src
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

### ld.r.p.off.(b/bs/w)
Load a value pointed to by a register plus offset into a register, sign extend if needed.
```
ld.r.p.off.b/bs/w dst src off
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

NOTE: Store instructions with b and bs modes do the same thing, as we can't un sign extend

### st.r.m.(b/bs/w)
Store a value from a register into memory.
```
st.r.m.b/bs/w src mem
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

### st.r.p.(b/bs/w)
Store a value from a register into the memory addr pointed to by a register.
```
st.r.p.b/bs/w src dst
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

### st.r.p.off.(b/bs/w)
Store a value from a register into the memory addr pointed to by a register plus an offset.
```
st.r.p.p.off.b/bs/w src dst off
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
### jmp.c.j
Perform a conditional jump to a fixed addr.
```
jmp.c.j cond addr
; if flags | cond then pc = pc + addr
```
Note - an unconditional jump can be performed by using `0b11111` as the condition code.

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=1>-</td>
  <td colspan=5>cond</td>
  <td colspan=4>---</td>
  <td>address</td>
</tr>
</table>

### jmp.c.r
Perform a conditional jump to a non pc-relative addr in a register.
```
jmp.c.r cond reg
; if flags | cond then pc = reg
```
Note - an unconditional jump can be performed by using `0b11111` as the condition code.

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=1>-</td>
  <td colspan=5>cond</td>
  <td colspan=4>reg</td>
</tr>
</table>

## Stack instructions
### push.r.sp
Push a register onto a stack.
```
push.r.sp reg sp
; sp = sp - 2
; (sp) = reg
```
Note - The register used as a stack pointer must be aligned on word boundries.

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=2>---</td>
  <td colspan=4>sp</td>
  <td colspan=4>reg</td>
</tr>
</table>

### pop.r.sp
Pop a value off a stack into a register.
```
pop.r.sp reg sp
; sp = sp + 2
; reg = (sp - 2)
```
Note - The register used as a stack pointer must be aligned on word boundries.

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=2>---</td>
  <td colspan=4>sp</td>
  <td colspan=4>reg</td>
</tr>
</table>

### call.j.sp
Perform a function call to a pc relative adress.
```
call.i.sp sp addr
; sp = sp - 2
; (sp) = pc + 2
; pc = pc + addr
```

<table>
<tr>
<th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=2>---</td>
  <td colspan=4>sp</td>
  <td colspan=4>---</td>
  <td>function address</td>
</tr>
</table>

### call.r.sp
Perform a function call to a non pc-relative address in a register.
```
call.r.sp reg sp
; sp = sp - 2
; (sp) = pc
; pc = reg
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=2>---</td>
  <td colspan=4>sp</td>
  <td colspan=4>reg</td>
</tr>
</table>

### ret.n.sp
Return from a function call, given a return adress on the top of the stack.
```
ret.n.sp sp
; sp = sp + 2
; pc = (sp - 2)
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=2>---</td>
  <td colspan=4>sp</td>
  <td colspan=4>---</td>
</tr>
</table>

## IO Instructions

### out.r.p
Output a register to the specified io port number.
```
out.r.p reg port_num
; io[port_num] = reg
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=6>---</td>
  <td colspan=4>reg</td>
  <td colspan=1>port_num</td>
</tr>
</table>

### in.r.p
Read a value from the specified io port into a register.
```
in.r.p reg port_num
; reg = io[port_num]
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0<th>val16
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=6>---</td>
  <td colspan=4>reg</td>
  <td colspan=1>port_num</td>
</tr>
</table>

## Interrupt Instructions
### int.i.n
Perform an interrupt to the specified interrupt vector.
```
int.i.n vector
; pc_cpy = pc
; pc = int_vectors[vector]
; priv_lv = 0
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=6>---</td>
  <td colspan=4>vector</td>
</tr>
</table>

### reti.ipc.n
Return from an interrupt. Copies ipc to pc, and sets priv_lv to 1 (usr).
```
reti.ipc.n
; pc = ipc
; priv_lv = 1
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=10>---</td>
</tr>
</table>

### mov.r.ipc
Copy the value in a register into the ipc reg.
```
mov.r.ipc reg
; ipc = reg
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=6>---</td>
  <td colspan=4>reg</td>
</tr>
</table>

### mov.ipc.r
Copy the value in the ipc reg to a reg.
```
mov.ipc.r reg
; reg = ipc
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=6>---</td>
  <td colspan=4>reg</td>
</tr>
</table>

## MMU Instructions
### mmu.r.r
Set the mmu entry pointed to by (reg2>>11) + ptb to the low byte of reg1.
priv_lv must be sys(0) going into the instruction. It will be sys(0) coming out of it.
```
mmu.r.r reg2 reg1
; priv_lv = 0
; page_table[ptb + (reg2 >> 11)] = reg1;
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=2>---</td>
  <td colspan=4>reg2</td>
  <td colspan=4>reg1</td>
</tr>
</table>

### ptb.r.n
Set the ptb to the value in reg. priv_lv should be sys(0) going into instruction. Calling in sys(1) will cause a strange jump and likely crash.
```
ptb.r.n reg
; ptb = reg
```
<table>
<tr>
  <th>f<th>e<th>d<th>c<th>b<th>a<th>9<th>8<th>7<th>6<th>5<th>4<th>3<th>2<th>1<th>0
</tr>
<tr>
  <td colspan=6>opcode</td>
  <td colspan=6>---</td>
  <td colspan=4>reg</td>
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