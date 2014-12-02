/*
 * OK04: a basic blinker using the GPIO timer for delays.
 */

.section .init
.globl _start
_start:

	b   main

.section .text
.globl main
main:

	/* 
	 * Set up the stack to point to the memory after the
	 * initialisation and text areas.
	 */
	mov	sp,	#0x8000

	/* Set up ACT as an output pin. */
	mov	r0,	#16
	mov	r1,	#1
	bl	SetGPIOFunction

loop$:
	/* Turn on ACT. */
	mov	r0,	#16
	mov	r1,	#0
	bl	SetGPIO

	/* Wait for 100ms. */
	ldr	r0,	=100000
	bl	Wait

	/* Turn off ACT. */
	mov	r0,	#16
	mov	r1,	#1
	bl	SetGPIO

	/* Wait for 300ms. */
	ldr	r0,	=300000
	bl	Wait

	/* Rinse and repeat. */
	b	loop$
