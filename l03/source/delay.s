.globl Wait
Wait:
  push {lr}
  mov r2,#0x3F0000
  wait1$:
  sub r2,#1
  cmp r2,#0
  bne wait1$
  pop {pc}
