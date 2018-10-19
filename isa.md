# ISA

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
; dst = (mem)
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

## Store Instructions

### st.r.(mb/mbs/mw)
Store a value from a register into memory.
```
st.r.mb/mbs/mw src mem
; (mem) = src
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