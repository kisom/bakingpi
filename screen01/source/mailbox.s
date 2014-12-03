/*
 * Mailbox reading and writing.
 *
 * This file contains code to read from and write to a mailbox.
 */

/*
 * MailboxAddress returns the base address for the mailbox.
 */
MailboxAddress:
	ldr	r0,	=0x2000B880
	mov	pc,	lr

/*
 * TODO: split out mailboxPolls and mailboxCheckRcpt to predicates.
 */

/*
 * MailboxRead reads a value from the mailbox specified in r0. The
 * value is returned in r0.
 */
.globl MailboxRead
MailboxRead:
	cmp	r0,	#7
	movhi	pc,	lr
	push	{lr}
	mov	r1,	r0
	bl	MailboxAddress

	mailboxRPoll$:
		ldr	r2,	[r0,#0x18]
		tst	r2,	#0x40000000
		beq	mailboxCheckRRcpt$
		push	{r0,r1}
		mov	r0,	#1
		bl	Wait
		pop	{r0,r1}
		b	mailboxRPoll$

	mailboxCheckRRcpt$:
		ldr	r2,	[r0,#0]
		and	r3,	r2,	#0b1111
		teq	r3,	r1
		bne	mailboxRPoll$
		
	and	r0,	r2,	#0xfffffff0
	pop	{pc}

/*
 * MailboxWrite writes the high 28 bits in r0 to the mailbox specified
 * in r1.
 */
.globl MailboxWrite
MailboxWrite:
	tst	r0,	#0b1111
	movne	pc,	lr
	cmp	r1,	#7
	movhi	pc,	lr
	push	{lr}

	push	{r0}
	bl	MailboxAddress

	mailboxWPoll$:
		ldr	r2,	[r0,#0x18]
		tst	r2,	#0x10000000
		beq	mailboxCheckWRcpt$
		push	{r0,r1}
		mov	r0,	#1
		bl	Wait
		pop	{r0,r1}
		b	mailboxRPoll$

	mailboxCheckWRcpt$:
		ldr	r2,	[r0,#0]
		and	r3,	r2,	#0b1111
		teq	r3,	r1
		bne	mailboxWPoll$
	
	mov	r1,	r0
	pop	{r0}
	str	r0,	[r1,#0x20]
	pop	{pc}
	