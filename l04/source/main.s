/*
 * OK04: a basic blinker using the GPIO timer for delays.
 */

.section .init
.globl   _start
_start:

b   main

.section    .text
.globl      main
main:

  /* Set up the stack to point to the memory after the initialisation
   * and text areas.
   */
  mov   sp, #0x8000

  mov   r0, #16
  mov   r1, #1
  bl    SetGPIOFunction

loop$:
  mov   r0, #16
  mov   r1, #0
  bl    SetGPIO

  ldr   r0, =100000
  bl    Wait

  mov   r0, #16
  mov   r1, #1
  bl    SetGPIO

  ldr   r0, =200000
  bl    Wait

  b     loop$
