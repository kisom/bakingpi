.globl InitialiseFrameBuffer
InitialiseFrameBuffer:
	push	{r4,lr}
	ldr	r4,	=FrameBufferInfo
	str	r0,	[r4,#0]
	str	r0,	[r4,#8]
	str	r1,	[r4,#4]
	str	r1,	[r4,#12]

	mov	r0,	r4
	add	r0,	#0x40000000
	mov	r1,	#1
	bl	MailboxWrite

	mov	r0,	#1
	bl	MailboxRead

	teq	r0,	#0
	movne	r0,	#0
	popne	{r4,lr}

	mov	r0,	r4
	pop	{r4,pc}


.section .data
.align 4
.globl FrameBufferInfo
FrameBufferInfo:
.int 1024 /* #0 Physical Width */
.int 768 /* #4 Physical Height */
.int 1024 /* #8 Virtual Width */
.int 768 /* #12 Virtual Height */
.int 0 /* #16 GPU - Pitch */
.int 16 /* #20 Bit Depth */
.int 0 /* #24 X */
.int 0 /* #28 Y */
.int 0 /* #32 GPU - Pointer */
.int 0 /* #36 GPU - Size */
