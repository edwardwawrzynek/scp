; SCP GFX library asm support
; This is just the time critical drawing routines (which is nearly all the drawing routines)

  .text
  .align
; Color the pixel at position x(ra), y(rb) with color(rc)
_gfx_pixel:
  .global _gfx_pixel
  alu.r.i mul rb 320
  alu.r.r add ra rb
  out.r.p ra 9
  out.r.p rc 10
  ret.n.sp sp

  .text
  .align

; Draw a rectangle at x(ra),y(rb) with width(rc), height(rd), and color(re)
_gfx_rect:
  .global _gfx_rect
; r0 is current x value, r1 is current y value
  push.r.sp r0 sp
  push.r.sp r1 sp
; r2 is temp
  push.r.sp r2 sp

; if x or y < 0, exit
  ld.r.i r2 0
  cmp.r.f ra r2
  jmp.c.j L lrect_exit

  ld.r.i r2 0
  cmp.r.f rb r2
  jmp.c.j L lrect_exit
  
; if x+w > 320 or y+h > 200, exit
  ld.r.i r2 320
  mov.r.r r0 ra
  alu.r.r add r0 rc
  cmp.r.f r0 r2
  jmp.c.j G lrect_exit

  ld.r.i r2 200
  mov.r.r r0 rb
  alu.r.r add r0 rd
  cmp.r.f r0 r2
  jmp.c.j G lrect_exit

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

; Set the background to the color in ra
  .text
  .align
_gfx_background:
  .global _gfx_background
  ld.r.i rb 0
lbackgroundloop:
  out.r.p rb 9
  out.r.p ra 10
  alu.r.i add rb 1
  ld.r.i rc 64000
  cmp.r.f rb rc
  jmp.c.j lgLg lbackgroundloop

  ret.n.sp sp

; put char c(rc) on screen at position x(ra), y(rb)
  .text
  .align
_gfx_put_char:
  .global _gfx_put_char
  alu.r.i mul rb 80
  alu.r.r add ra rb
  out.r.p ra 5
  out.r.p rc 6
  ret.n.sp sp