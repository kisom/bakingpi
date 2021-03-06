/*
 * OK03: a basic blinker, functionally.
 *
 * "In assembly code, functions are just ideas we have."
 */
 .section .init
.globl _start
_start:

/*
 * The ABI:
 *
 * 1. Registers 0-3 are used as inputs to the function.
 * 2. Registers 4-12 must have their values preserved.
 * 3. The function's output goes in r0.
 * 4. The lr register contains the address of the instruction after
 *    the function call.
 * 5. The stack pointer must be returned to its original value when
 *    the function exits.
 */

 /*
  * Manipulating the stack: there are instructions for this in the
  * ARM instruction set. push{r4,r5} pushes registers r4 and r5 onto
  * the stack, and pop{r4,r5} takes them off the stack.
  */

b main

.section  .text
main:
  /*
   * Make room for the stack.
   */
  mov sp, #0x8000

  pinNum  .req  r0
  pinFunc .req  r1
  mov     pinNum,   #16
  mov     pinFunc,  #1
  bl	SetGpioFunction
  .unreq  pinNum
  .unreq  pinFunc


mainLoop$:
  bl  ActOn
  bl  Wait
  bl  ActOff
  bl  Wait
  bl  mainLoop$
 
 