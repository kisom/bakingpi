/*
 * GPIO manipulation functions
 */

.globl GetGpioAddress
GetGpioAddress:
  ldr r0, =0x20200000
  mov pc, lr

.globl SetGpioFunction
SetGpioFunction:
  /* 
   * The value of r0 should be between 0 and 53 (there are 54 pins),
   * and r1 must be less than 7 as there are 8 functions per pin.
   */
  cmp   r0, #53
  cmpls r1, #7

  /*
   * If these checks fail, return without doing anything.
   */
  movhi pc, lr

  /*
   * Save the return address onto the stack.
   */
   push {lr}

   mov  r2, r0
   bl   GetGpioAddress

   /* Set up the loop that ensures that r0 will contain the address in
    * the GPIO controller of the pin's function settings. This is
    * equivalent to GPIO controller address + 4 * (GPIO pin # / 10).
    */
functionLoop$:
   cmp    r2, #9
   subhi  r2, #10
   addhi  r0, #4
   bhi    functionLoop$
 
  /*
   * NOTE: ARMv6 lets you shift an argument prior to using it. In this
   * case, it's faster to compute (r2 + (r2 << 1)), which is equivalent
   * to (r2 + (r2 * 2)), which is the same as (r2 * 3), but much faster
   * than a multiply instruction.
   */
  add     r2, r2,lsl #1
  lsl     r1, r2
  str     r1, [r0]

  /*
   * The previous lr value is on the stack. Instead of popping it into
   * the lr and moving it into the pc, we can pop directly into the
   * pc.
   */
  pop     {pc}
 
 /*
  * extra credit: this function will set the GPIO pin, but in the
  * process, will cause all the pins in the same block to go back
  * to zero. Figure out how to ignore the pins other than the three
  * that are needed.
  */
 
.globl SetGpio
SetGpio:
  /*
   * alias .req register defines alias to mean the register being
   * referred to.
   */
  pinNum .req r0
  pinVal .req r1

  cmp   pinNum, #53
  movhi pc, lr
  push  {lr}
  mov   r2, pinNum
  .unreq pinNum /* the opposite of .req */
  pinNum .req r2
  bl     GetGpioAddress
  gpioAddr .req r0

  pinBank .req r3
  lsr     pinBank,  pinNum, #5
  lsl     pinBank,  #2
  add     gpioAddr, pinBank
  .unreq  pinBank

  and     pinNum, #31
  setBit  .req    r3
  mov     setBit, #1
  lsl     setBit, pinNum
  .unreq  pinNum

  /* teq -> test if equal */
  teq     pinVal, #0
  .unreq  pinVal
  streq   setBit, [gpioAddr, #40]
  strne   setBit, [gpioAddr, #28]
  .unreq  setBit
  .unreq  gpioAddr
  pop {pc}
