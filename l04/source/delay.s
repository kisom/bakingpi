/*
 Table 1.1 GPIO Controller Registers 
Address	Size	Name	      Description		   Read or Write
20003000	4	Control / Status  Register used to control and clear timer channel comparator matches.	RW
20003004	8	Counter	   A counter that increments at 1MHz.	R
2000300C	4	Compare 0	 0th Comparison register.	RW
20003010	4	Compare 1	 1st Comparison register.	RW
20003014	4	Compare 2	 2nd Comparison register.	RW
20003018	4	Compare 3	 3rd Comparison register.	RW

 * The RPi has no RTC, so the timer is the only way to keep time.
 *
 * The counter is 64-bit, but registers are 32-bit, so two registers
 * must be used. The ldrd (load register double) instruction will load
 * a pair of registers: ldrd regLow, regHi, [src, #val].
 */

/*
 * previous implementation of Wait
 */
.globl PrevWait
PrevWait:
  push {lr}
  mov r2,#0x3F0000
  wait1$:
  sub r2,#1
  cmp r2,#0
  bne wait1$
  pop {pc}


.globl TimerAddress
TimerAddress:
  ldr r0, =0x20003000
  mov pc, lr

.globl getTimeStamp
getTimeStamp:
  push {lr}
  bl   TimerAddress
  ldrd r0, r1, [r0, #4]
  pop {pc}

.globl Wait
Wait:
  delay .req  r2
  mov   delay,  r0
  push  {lr}
  bl    getTimeStamp
  start .req  r3
  mov   start, r0

 waitLoop$:
  bl    getTimeStamp
  sub   r1,  r0, start
  cmp   r1,  delay
  bls   waitLoop$
  .unreq delay
  .unreq start
  pop   {pc}