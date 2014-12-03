/*
 * OK04: a basic blinker using the GPIO timer for delays.
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
	mov	sp,	#0x8000

	mov	r0,	#1024
	mov	r1,	#768
	mov	r2,	#16
	bl	InitialiseFrameBuffer

	teq	r0,	#0
	bne	draw$

	/*
	 * If the framebuffer reports an error, turn on the ACT LED.
	 */
	mov	r0,	#16
	mov	r1,	#1
	bl	SetGPIOFunction

	mov	r0,	#16
	mov	r1,	#0
	bl	SetGPIO

	dead$:
		b	dead$

	draw$:
		mov	r4,	r0

	render$:
		ldr	r3,	[r4,#32]
		mov	r1,	#768

	drawRow$:
		mov	r2,	#1024

	drawPixel$:
		strh	r0,	[r3]
		add	r3,	#2
		sub	r2,	#1
		teq	r2,	#0
		bne	drawPixel$

	sub	r1,	#1
	add	r0,	#1
	teq	r1,	#0
	bne	drawRow$

	b	render$
