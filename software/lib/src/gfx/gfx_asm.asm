; SCP GFX library asm support
; This is just the time critical drawing routines (which is nearly all the drawing routines)

  .text
  .align
; Color the pixel at position x(ra), y(rb) with color(rc)
__gfx_pixel:
  .global __gfx_pixel
  alu.r.i mul rb 320
  alu.r.r add ra rb
  out.r.p ra 9
  out.r.p rc 10
  ret.n.sp sp

  .text
  .align

; Draw a rectangle at x(ra),y(rb) with width(rc), height(rd), and color(re)
__gfx_rect:
  .global __gfx_rect
; r0 is current x value, r1 is current y value
  push.r.sp r0 sp
  push.r.sp r1 sp
; r2 is temp
  push.r.sp r2 sp

; Load x value
  mov.r.r r0 ra
lrectloop_x:
; test current x < x+w
  mov.r.r r2 ra
  alu.r.r add r2 rc
  cmp.r.f r0 r2
  jmp.c.j ge lrectloop_x_end
; loop x body
; load y value
  mov.r.r r1 rb
lrectloop_y:
; test current y < y+h
  mov.r.r r2 rb
  alu.r.r add r2 rd
  cmp.r.f r1 r2
  jmp.c.j ge lrectloop_y_end
; loop y body
  mov.r.r r2 r1
  alu.r.i mul r2 320
  alu.r.r add r2 r0
  out.r.p r2 9
  out.r.p re 10

;loop y last
  alu.r.i add r1 1
  jmp.c.j GLgle lrectloop_y

lrectloop_y_end:

;loop x last
  alu.r.i add r0 1
  jmp.c.j GLgle lrectloop_x
lrectloop_x_end:
lrect_exit:
  pop.r.sp r2 sp
  pop.r.sp r1 sp
  pop.r.sp r0 sp
  ret.n.sp sp


; put char c(rc) on screen at position x(ra), y(rb)
  .text
  .align
__gfx_put_char:
  .global __gfx_put_char
  alu.r.i mul rb 80
  alu.r.r add ra rb
  out.r.p ra 5
  out.r.p rc 6
  ret.n.sp sp

; read a char from position x(ra), y(rb)
  .text
  .align
__gfx_read_char:
  .global __gfx_read_char
  alu.r.i mul rb 80
  alu.r.r add ra rb
  out.r.p ra 5
  in.r.p re 6
  ret.n.sp sp