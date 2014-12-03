/*
 * OK05p: a patterned blinker using the GPIO timer for delays. This
 * version is built for the Raspberry Pi B+.
 */

.section .init
.globl _start
_start:

	b	main

.section .text
.globl main
main:

	/* 
	 * Set up the stack to point to the memory after the initialisation
	 * and text areas.
	 */
	mov   sp,	#0x8000

	/* Set up ACT as an output pin. */
	mov	r0,	#47
	mov	r1,	#1
	bl	SetGPIOFunction

	ldr	r4,	=pattern
	ldr	r4,	[r4]
	mov	r5,	#0

loop$:
	mov	r1,	#1
	lsl	r1,	r5
	and	r1,	r4

	mov	r0,	#47
	bl	SetGPIO

	ldr	r0,	=100000
	bl	Wait

	cmp	r5,	#32
	movhi	r5,	#0
	addle	r5,	#1

	b	loop$


.section .data
.align 2
/*
pattern:
	.int	0b11111111101010100010001000101010
 */

pattern:
	.int	0b01010100111011101110010101000000
